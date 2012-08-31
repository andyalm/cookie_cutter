module CookieCutter
  class CookieAttribute
    attr_reader :name

    def initialize(name, options)
      @name = name
      @options = options
    end

    def storage_key
      (@options[:store_as] || @name).to_sym
    end
  end
end