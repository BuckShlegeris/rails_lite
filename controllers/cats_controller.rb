class CatsController < BaseController
  def show
    p params["id"]
    @cat = Cat.find(params["id"])
    session["lol"] = (session["lol"] || 0) + 1
    flash["lol"] = "hello world"
    render :show
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    render :new
  end

  def create
    @cat = Cat.new(params["cat"])

    if @cat.save
      @cats = Cat.all
      render :index
    else
      render :new
    end
  end
end