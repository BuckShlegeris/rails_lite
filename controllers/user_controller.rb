class UserController < BaseController
  def show
    session["lol"] = (session["lol"] || 0) + 1
    render :show
  end

  def root
    show_html "lol, root"
  end

  def form
    render :form
  end

  def puts
    show_html "putting!!!!1!"
  end
end