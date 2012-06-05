class FakeCookieJar
  def [](name)
    cookie = @cookies[name]
    if cookie
      cookie[:value]
    else
      nil
    end
  end

  def []=(name, value)
    @cookies[name] = value
  end

  def initialize(*args)
    @cookies = {}
    if args.any?
      cookies = args.first
      cookies.keys.each do |cookie_name|
        self[cookie_name] = { value: cookies[cookie_name] }
      end
    end
  end

  def to_hash
    @cookies
  end

  def metadata_for(name)
    @cookies[name]
  end
end