class FakeCookieJar < Hash
  def [](key)
    cookie = super
    if cookie
      cookie[:value]
    else
      nil
    end
  end

  def initialize(*args)
    if args.any?
      cookies = args.first
      cookies.keys.each do |cookie_name|
        self[cookie_name] = { value: cookies[cookie_name] }
      end
    end
  end
end