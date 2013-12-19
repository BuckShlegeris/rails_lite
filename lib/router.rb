load "./lib/route.rb"

def respond(request, response)
  puts "*"*100
  puts "responding to request"
  router = Router.new
  router.respond(request, response)
end

class Router
  attr_accessor :routes

  def initialize
    @routes = []

    File.open("./config/routes.rb") do |file|
      eval(file.read)
    end
  end

  method_names = %w(get put show post delete edit update)

  method_names.each do |method_name|
    define_method(method_name) do |routes|
      routes.each do |key, value|
        @routes << Route.new(method_name.to_sym, key, value)
      end
    end
  end

  def resources(name)
    draw do
      get "/#{name}/(?<id>\\d+)" => "#{name}\#show"
      get "/#{name}" =>"#{name}\#index"
      get "/#{name}/new" => "#{name}\#new"
      post "/#{name}" => "#{name}\#create"
      delete "/#{name}/(?<id>\\d+)" => "#{name}\#delete"
      get "/#{name}/(?<id>\\d+)/edit" => "#{name}\#edit"
      put "/#{name}/(?<id>\\d+)" => "#{name}\#update"
    end
  end

  def draw(&prc)
    prc.call
  end

  def respond(request, response)
    request.path + request.query.to_s + request.request_method.to_s

    @routes.each do |route|
      if route.match?(request)
        route.respond(request, response, @routes)
        return
      end
    end

    # If none of the routes have captured the request...
    response.content_type = "text/html"
    response.body = "<h1>404.</h1>Here's the request: <br><pre>"+
                            request.to_s+"</pre>"
  end
end
