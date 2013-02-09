require 'cookie_cutter/test_support/fake_cookie_jar'

module CookieCutter
  module TestSupport
    module Stubs
      module Finders
        def find(*args)
          new(TestSupport::FakeCookieJar.find)
        end

        def stub
          new(TestSupport::FakeCookieJar.new)
        end
      end

      def stub_all
        TestSupport::FakeCookieJar.empty!
        CookieCutter::Base::class_eval do
          extend Finders
        end
      end
    end
  end
end