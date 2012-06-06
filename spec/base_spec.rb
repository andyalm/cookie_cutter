require 'rspec'
require 'cookie_cutter'
require_relative 'support/fake_cookie_jar'
require 'active_support/core_ext'

class SingleValuedCookie < CookieCutter::Base
  store_as :svc
end

class MultiValuedCookie < CookieCutter::Base
  store_as :mvc

  has_attribute :value1
  has_attribute :value2, store_as: 'val2'
end

class MyMixedCaseCookie < CookieCutter::Base
  store_as :my_uppercase_cookie

  has_attribute :mixed_case_key, store_as: 'mixedcasekey'
end

describe CookieCutter::Base do
  let(:cookie_jar) { FakeCookieJar.new }
  it 'should not not update the cookie_jar when no value is set' do
    SingleValuedCookie.new(cookie_jar)
    cookie_jar.to_hash.should be_empty
  end
  describe 'domain' do
    it 'does not set domain if not given' do
      class CookieWithNoDomain < CookieCutter::Base
        store_as :cwnd
      end
      cookie = CookieWithNoDomain.new(cookie_jar)
      cookie.value = "my value"
      cookie_jar.metadata_for(:cwnd)[:domain].should be_nil
    end
    it 'uses given domain when saving cookie' do
      class CookieWithDomain < CookieCutter::Base
        store_as :cwd
        domain :all
      end
      cookie = CookieWithDomain.new(cookie_jar)
      cookie.value = "my value"
      cookie_jar.metadata_for(:cwd)[:domain].should == :all
    end
  end
  describe 'lifetime' do
    it 'default to a session cookie' do
      class CookieWithNoLifetimeSpecified < CookieCutter::Base
        store_as :cwnls
      end
      cookie = CookieWithNoLifetimeSpecified.new(cookie_jar)
      cookie.value = "my value"
      cookie_jar.metadata_for(:cwnls)[:expires].should be_nil
    end
    it 'sets expires to now plus lifetime' do
      now = Time.now
      lifetime = 60
      class CookieWithLifetimeSpecified < CookieCutter::Base
        store_as :cwls

        lifetime 60
      end
      cookie = CookieWithLifetimeSpecified.new(cookie_jar)
      cookie.value = "my value"
      cookie_jar.metadata_for(:cwls)[:expires].should be_within(0.01).of(now + lifetime)
    end
    it 'sets expires to 20 years from now if made permanent!' do
      now = Time.now
      class PermanentCookie < CookieCutter::Base
        store_as :pc
        is_permanent
      end
      cookie = PermanentCookie.new(cookie_jar)
      cookie.value = "my value"
      cookie_jar.metadata_for(:pc)[:expires].should be_within(0.01).of(20.years.from_now)
    end
  end
  describe 'single valued cookie' do
    let(:single_valued_cookie) { SingleValuedCookie.new(cookie_jar) }
    it 'should update the cookie jar when value is updated' do
      single_valued_cookie.value = "ordinary value"
      cookie_jar[:svc].should == "ordinary value"
    end
    it 'can be read via ordinary cookie jar' do
      single_value_cookie = SingleValuedCookie.new(FakeCookieJar.new({ svc: "preset value" }))
      single_value_cookie.value.should == "preset value"
    end
  end
  describe 'multi-valued cookie' do
    let(:multi_valued_cookie) { MultiValuedCookie.new(cookie_jar) }
    it 'should update the cookie jar when an attribute is updated' do
      multi_valued_cookie.value1 = "myval"
      cookie_jar[:mvc][:value1].should == "myval"
    end
    it 'generates getters and setters for each attribute' do
      multi_valued_cookie.value1 = "myval1"
      multi_valued_cookie.value2 = "myval2"

      multi_valued_cookie.value1.should == "myval1"
      multi_valued_cookie.value2.should == "myval2"
    end
    it "privatizes the singular 'value' getter and setter" do
      expect { multi_valued_cookie.value = "myval"}.should raise_error(NoMethodError)
      expect { multi_valued_cookie.value}.should raise_error(NoMethodError)
    end
    it "can override stored attribute name with :store_as option" do
      multi_valued_cookie.value2 = "myval2"
      cookie_jar[:mvc][:val2].should == "myval2"
    end
  end
end