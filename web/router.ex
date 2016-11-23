defmodule UmlHdxir.Router do
  use UmlHdxir.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", UmlHdxir do
    pipe_through :api
    get "/", DetectController, :index
  end
end
