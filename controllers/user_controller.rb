class UserController < BaseController
  def show
    session["lol"] = (session["lol"] || 0) + 1
    flash["lol"] = "hello world"
    render :show
  end

  def root
    show_html "lol, root"
  end

  def form
    render :form
  end

  def putting_things
    show_html "putting!!!!1!"
  end
end