require 'json'
require 'webrick'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @cookie_value = cookie.nil? ? {} : JSON.parse(cookie.value)
      end
    end
  end

  def [](key)         # session is a hash
    @cookie_value["#{key}"]
  end

  def []=(key, val)   # session is a hash
    @cookie_value["#{key}"] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie_value.to_json)
    res.cookies << cookie
  end
end
