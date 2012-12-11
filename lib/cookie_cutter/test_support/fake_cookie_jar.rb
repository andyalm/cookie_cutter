module CookieCutter
  module TestSupport
    class FakeCookieJar
      class << self
        def find
          @instance ||= FakeCookieJar.new
        end

        def empty!
          @instance = nil
        end
      end

      def [](name)
        cookie = @cookies[name]
        cookie ? cookie[:value] : nil
      end

      def []=(name, value)
        @cookies[name] = value
        @deleted_cookies.delete_if{|n| name == n}
      end

      def delete(name, options)
        @cookies.delete(name)
        @deleted_cookies << name
      end

      def initialize(*args)
        @cookies = {}
        @deleted_cookies = []
        if args.any?
          cookies = args.first
          cookies.keys.each do |cookie_name|
            self[cookie_name] = { value: cookies[cookie_name] }
          end
        end
      end

      def deleted?(name)
        @deleted_cookies.include?(name)
      end

      def to_hash
        @cookies
      end

      def metadata_for(name)
        @cookies[name]
      end
    end
  end
end