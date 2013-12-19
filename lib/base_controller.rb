load "./lib/session.rb"
load "./lib/flash.rb"

Dir.entries("./models").each do |model|
  next if [".",".."].include? model
  require "./models/#{model}"
end

class BaseController
  attr_accessor :response, :request, :params, :class_name, :routes

  def initialize
    # As soon as we call redirect_to or render, we set this to be true.
    @response_decided = false
  end

  def redirect_to(destination)
    if @response_decided
      throw "You've edited the response in two places, which is bad"
    else
      response.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, destination)
      @response_decided = true
    end
  end

  def show_html(string)
    if @response_decided
      throw "You've edited the response in two places, which is bad"
    else
      response.content_type = "text/html"
      response.body = string
      @response_decided = true
      self.session.save(response)
      self.flash.save(response)
    end
  end

  def render(name)
    template_text = File.read("./views/#{class_name}/#{name}.html.erb")
    template = ERB.new(template_text)
    template_result = template.result(binding)

    application_template_text = File.read("./views/layouts/application.html.erb")

    application_template_text.gsub!("<% yield %>", template_result)

    application_template = ERB.new(application_template_text)
    application_template_result = application_template.result(binding)

    show_html(application_template_result)
  end

  def session
    @session ||= Session.new(@request, @response)
  end

  def flash
    @flash ||= Flash.new(@request, @response)
    @flash
  end


  def link_to(name, url)
    "<a href=\"#{url}\">#{name}</a>"
  end

  def button_to(name, url, **options)
    out = "<form method=\"POST\" action=\"#{url}\">"
    out += "<input type=\"submit\" value=\"#{name}\">"
    if options[:method]
      out += "<input
                    type=\"hidden\"
                    name=\"_method\"
                    value=\"#{options[:method]}\">"
    end
    out += "</form>"
  end

  def method_missing(name, *args, &block)
    out = url_helper(name, args)
    if out
      out
    else
      super
    end
  end

  def url_helper(url_name, args)
    @routes.each do |route|
      if route.response.gsub('#','_')+"_url" == url_name.to_s
        return route.path.source
      end
    end

    throw "uh, can't help that much..."
  end

end
