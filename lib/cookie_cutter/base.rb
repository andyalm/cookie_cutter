
module CookieCutter
  class Base
    class << self
      def find(request)
        new(request.cookie_jar)
      end

      attr_reader :cookie_name
      def store_as(name)
        @cookie_name = name
      end

      attr_reader :cookie_domain
      def domain(domain_value)
        @cookie_domain = domain_value
        add_handler do |cookie|
          cookie[:domain] = domain_value
        end
      end

      attr_reader :cookie_lifetime
      def lifetime(seconds)
        @cookie_lifetime = seconds
        add_handler do |cookie|
          cookie[:expires] = (Time.now + seconds)
        end
      end

      def is_permanent
        twenty_years = 60 * 60 * 24 * 365.25 * 20
        lifetime twenty_years
      end

      def has_attribute(value_name, options={})
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

      def add_options(cookie)
        handlers.each do |handler|
          handler.call(cookie)
        end
      end

      def add_handler(&block)
        handlers << block
      end

      def handlers
        @handlers ||= []
      end
    end

    def initialize(cookie_jar)
      @cookie_jar = cookie_jar
    end

    def value
      @cookie_jar[self.class.cookie_name]
    end

    def value=(val)
      cookie = { value: val }
      self.class.add_options(cookie)
      @cookie_jar[self.class.cookie_name] = cookie
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