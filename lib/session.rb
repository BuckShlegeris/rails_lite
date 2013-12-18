require "json"

class Session
  def initialize(request,response)
    @content = {}
    request.cookies.each do |cookie|
      if cookie.name == "rails-lite-session"
        @content = JSON.parse(cookie.value)
        return
      end
    end

  end

  def [](key)
    @content[key]
  end

  def []=(key, value)
    @content[key] = value
  end

  def save(response)
    new_cookie = WEBrick::Cookie.new("rails-lite-session",
                                     @content.to_json)
    response.cookies << new_cookie
  end
end

