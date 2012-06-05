
module CookieCutter
  class Base
    def self.find(request)
      new(request.cookie_jar)
    end

    def self.has_name(name)
      @cookie_name = name
    end

    def self.cookie_name
      @cookie_name
    end

    def self.has_value_named(value_name, options={})
      raise "CookieCutter value names must by symbols. #{value_name} is not a symbol" unless value_name.is_a?(Symbol)
      #make value and value= private when the cookie has one or more named values
      private :value, :value=, :set_value

      value_key = (options[:store_as] || value_name).to_sym
      send :define_method, value_name do
        get_named_value(value_key)
      end
      setter_method_name = "#{value_name.to_s}=".to_sym
      send :define_method, setter_method_name do |value|
        set_named_value(value_key, value)
      end
    end

    def initialize(cookie_jar)
      @cookie_jar = cookie_jar
    end

    def value
      @cookie_jar[self.class.cookie_name]
    end

    def value=(val)
      @cookie_jar[self.class.cookie_name] = { value: val }
    end

    alias_method :set_value, :value=

    private
    def set_named_value(value_name, val)
      values_hash = value() || {}
      values_hash[value_name] = val
      set_value(values_hash)
    end

    def get_named_value(value_name)
      values_hash = value() || {}
      values_hash[value_name]
    end
  end
end