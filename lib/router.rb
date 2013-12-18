
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

  def draw(&prc)
    prc.call
  end

  def put(params)
    params.each do |key, value|
      @routes << Route.new(:put, key, value)
    end
  end

  def get(params)
    params.each do |key, value|
      @routes << Route.new(:get, key, value)
    end
  end

  def post(params)
    params.each do |key, value|
      @routes << Route.new(:post, key, value)
    end
  end



  def respond(request, response)
    request.path + request.query.to_s + request.request_method.to_s

    @routes.each do |route|
      if route.match?(request)
        route.respond(request, response)
        return
      end
    end

    # If none of the routes have captured the request...
    response.content_type = "text/html"
    response.body = "<h1>404.</h1>Here's the request: <br><pre>"+
                            request.to_s+"</pre>"
  end

end

class Route
  attr_accessor :method, :path, :response

  def initialize(method, path, response)
    @method = method
    @path = Regexp::new(path)
    @response = response
  end

  def match?(request)
    return false unless self.method.to_s ==
                                              translate_request_method(request)

    return false unless request.path.match(@path)

    $~[0].length == request.path.length
  end

  def translate_request_method(request)
    request.query["_method"] || request.request_method.downcase
  end


  def respond(request, response)
    puts "Directing request to #{self.response}"
    load "./lib/base_controller.rb"
    class_name, method_name = self.response.split('#')
    load "./controllers/#{class_name}_controller.rb"
    controller = classyify(class_name).new

    controller.request = request
    controller.response = response
    controller.class_name = class_name

    controller.params = get_params(request)

    p controller.params

    controller.send(method_name)

    puts response.to_s
  end

  def get_params(request)
    # Get params from the query
    params = request.query

    # Get params from wildcards in the url
    match_data = @path.match(request.path)
    named_captures = @path.named_captures

    named_captures.each do |named_capture, places|
      throw "Invalid url regex" if places.length > 1
      params[named_capture] = match_data[places[0]]
    end

    # Get params from forms
    # assignments = request.body.split("&") rescue []
    # assignments.each do |assignment|
    #   lhs, rhs = assignment.split("=")
    # #  params[lhs] = rhs
    # end
    neatify(params)
  end

  def neatify(params)
    neater_hash = {}

    params.each do |key, value|
      # This regex splits "a[b][c]"" to ["a", "b", "c"]

      nesting = key.split(/\]\[|\[|\]/)
      (nesting.length - 1).times do |depth|
        hash_name = '["' + nesting[0..depth].join('"]["') + '"]'
        eval "neater_hash#{hash_name} ||= {}"
      end

      hash_name = '["' + nesting.join('"]["') + '"]'
      eval "neater_hash#{hash_name} ||= \"#{value}\""
    end

    neater_hash
  end

  def classyify(string)
    eval(string.split("_").map(&:capitalize).join("") + "Controller")
  end
end
