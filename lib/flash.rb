require "json"

class Flash
  def initialize(request,response)
    @content = {}
    @new_content = {}
    request.cookies.each do |cookie|
      p [cookie.name, cookie.value]
      if cookie.name == "rails-lite-flash"
        @content = JSON.parse(cookie.value)
        return
      end
    end
  end

  def [](key)
    @content[key.to_s]
  end

  def []=(key, value)
    @content[key.to_s] = value
    @new_content[key.to_s] = true
  end

  def save(response)
    filtered_content = @content.select { |k,v| @new_content.include?(k) }

    new_cookie = WEBrick::Cookie.new("rails-lite-flash",
                                     @content.to_json)

    response.cookies << new_cookie
  end
end