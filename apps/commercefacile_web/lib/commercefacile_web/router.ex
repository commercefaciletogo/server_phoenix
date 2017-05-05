defmodule Commercefacile.Web.Router do
  use Commercefacile.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Commercefacile.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/ads", PageController, :ads

    get "/help", InfoPageController, :help
    get "/about", InfoPageController, :about
    get "/terms", InfoPageController, :terms
    get "/privacy", InfoPageController, :privacy
    get "/contact", InfoPageController, :contact
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", Commercefacile.Web do
  #   pipe_through :api
  # end
end
