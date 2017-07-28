defmodule Commercefacile.Web.Router do
  use Commercefacile.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :uploader do
    plug :fetch_session
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Commercefacile.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "/auth" do
      get "/enregistrer", AuthController, :get_register
      post "/enregistrer", AuthController, :post_register
      get "/numero", AuthController, :get_verify
      post "/numero", AuthController, :post_verify
      get "/code", AuthController, :get_code
      post "/code", AuthController, :post_code
      get "/connecter", AuthController, :get_login
      post "/connecter", AuthController, :post_login
      get "/réinitialiser", AuthController, :get_reset
      post "/réinitialiser", AuthController, :post_reset
      get "/mot-de-passe", AuthController, :get_reset_verify
      get "/nouveau-numero", AuthController, :get_new_verify
      delete "/se-deconnecter", AuthController, :logout
    end

    get "/annonces", AdController, :index
    get "/annonces/créer", AdController, :create
    post "/annonces", AdController, :save #not yet tested
    get "/annonces/:uuid", AdController, :show
    

    get "/help", InfoPageController, :help
    get "/about", InfoPageController, :about
    get "/terms", InfoPageController, :terms
    get "/privacy", InfoPageController, :privacy
    get "/contact", InfoPageController, :contact

    scope "/uploads" do
      post "/", UploadController, :upload
      delete "/:reference", UploadController, :delete
    end

    scope "/:phone" do
      get "/", UserController, :dashboard
      get "/boutique", UserController, :shop
      get "/favoris", UserController, :favorites
      get "/paramètres", UserController, :settings
    end
    
  end

  # Other scopes may use custom stacks.
  scope "/api/mobile", Commercefacile.Web.Api.Mobile do
    pipe_through :api

    scope "/auth" do
      post "/register", AuthenticationController, :register
      post "/login", AuthenticationController, :login
      post "/code", AuthenticationController, :code
      post "/phone", AuthenticationController, :phone
      post "/reset", AuthenticationController, :reset
    end

    scope "/ads" do
      get "/", AdController, :list
      post "/", AdController, :create
      get "/:uuid", AdController, :show
      put "/:uuid", AdController, :update
      delete "/:uuid", AdController, :delete
    end 

    scope "/account" do
      get "/ads", AccountController, :ads
      put "/", AccountController, :information
      put "/password", AccountController, :password
    end

    scope "/upload" do
      post "/", UploadController, :upload
      delete "/", UploadController, :remove
    end

    get "/categories", MiscellaneousController, :categories
    get "/locations", MiscellaneousController, :locations

    get "/:phone/shop", AccountController, :shop
  end
end
