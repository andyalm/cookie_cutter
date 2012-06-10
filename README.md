# CookieCutter

WARNING: CookieCutter is very early in its development cycle (pre-alpha).

CookieCutter provides a nice DSL for defining your cookies so that you can formalize your cookie definitions.
This leads to DRY-er code by ensuring that concerns such as the domain and lifetime of a cookie are consistent.
It also makes it easy to know what info you are putting into your cookies, which is becoming more important
these days as more laws surrounding cookies get written.

## Installation

Add this line to your application's Gemfile:

    gem 'cookie_cutter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cookie_cutter

## Usage Examples

### Define your cookie

    class MyCookie < CookieCutter::Base
      store_as :my
      domain :all
      is_permanent
      secure_requests_only
      http_only
      has_attribute :language
      has_attribute :country
    end

### Use your cookie

    #writes your cookie
    cookie = MyCookie.find(request)
    cookie.language = "fr"

    #reads your cookie
    cookie = MyCookie.find(request)
    puts "My language is #{cookie.language}"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
