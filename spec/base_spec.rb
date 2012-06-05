require 'rspec'
require 'cookie_cutter'
require_relative 'support/fake_cookie_jar'

class SingleValuedCookie < CookieCutter::Base
  has_name :svc
end

class MultiValuedCookie < CookieCutter::Base
  has_name :mvc

  has_value_named :value1
  has_value_named :value2, store_as: 'val2'
end

class MyMixedCaseCookie < CookieCutter::Base
  has_name :my_uppercase_cookie

  has_value_named :mixed_case_key, store_as: 'mixedcasekey'
end

describe CookieCutter::Base do
  let(:cookie_jar) { FakeCookieJar.new }
  it 'should not not update the cookie_jar when no value is set' do
    SingleValuedCookie.new(cookie_jar)
    cookie_jar.should be_empty
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
    it 'should update the cookie jar when a value is updated' do
      multi_valued_cookie.value1 = "myval"
      puts "spec cookie_jar: #{cookie_jar}"
      cookie_jar[:mvc][:value1].should == "myval"
    end
    it 'generates getters and setters for each named value' do
      multi_valued_cookie.value1 = "myval1"
      multi_valued_cookie.value2 = "myval2"

      multi_valued_cookie.value1.should == "myval1"
      multi_valued_cookie.value2.should == "myval2"
    end
    it "privatizes 'value' getter and setter" do
      expect { multi_valued_cookie.value = "myval"}.should raise_error(NoMethodError)
      expect { multi_valued_cookie.value}.should raise_error(NoMethodError)
    end
  end
end