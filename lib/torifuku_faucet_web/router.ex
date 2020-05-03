defmodule TorifukuFaucetWeb.Router do
  use TorifukuFaucetWeb, :router
  import Plug.BasicAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TorifukuFaucetWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TorifukuFaucetWeb do
    pipe_through :browser

    live "/", PageLive, :index

    # live "/transactions", TransactionLive.Index, :index
    # live "/transactions/new", TransactionLive.Index, :new

    live "/monacoin/testnet", MonacoinLive.Testnet, :index
    live "/monacoin/testnet/new", MonacoinLive.Testnet, :new
    live "/monacoin", MonacoinLive.Mainnet, :index
    live "/monacoin/new", MonacoinLive.Mainnet, :new
    live "/koto", KotoLive.Mainnet, :index
    live "/koto/new", KotoLive.Mainnet, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", TorifukuFaucetWeb do
  #   pipe_through :api
  # end

  @dashboard_username Application.get_env(:torifuku_faucet, :dashboard_username)
  @dashboard_password Application.get_env(:torifuku_faucet, :dashboard_password)

  pipeline :admins_only do
    plug :basic_auth, username: @dashboard_username, password: @dashboard_password
  end

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", metrics: TorifukuFaucetWeb.Telemetry
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TorifukuFaucetWeb.Telemetry
    end
  end
end
