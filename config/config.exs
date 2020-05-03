# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :torifuku_faucet,
  ecto_repos: [TorifukuFaucet.Repo],
  dashboard_username: System.get_env("FAUCET_DASHBOARD_USERNAME"),
  dashboard_password: System.get_env("FAUCET_DASHBOARD_PASSWORD"),
  monacoin_testnet_faucet_rpc_host: System.get_env("MONACOIN_TESTNET_FAUCET_RPC_HOST"),
  monacoin_testnet_faucet_rpc_user: System.get_env("MONACOIN_TESTNET_FAUCET_RPC_USER"),
  monacoin_testnet_faucet_rpc_password: System.get_env("MONACOIN_TESTNET_FAUCET_RPC_PASSWORD"),
  monacoin_mainnet_faucet_rpc_host: System.get_env("MONACOIN_MAINNET_FAUCET_RPC_HOST"),
  monacoin_mainnet_faucet_rpc_user: System.get_env("MONACOIN_MAINNET_FAUCET_RPC_USER"),
  monacoin_mainnet_faucet_rpc_password: System.get_env("MONACOIN_MAINNET_FAUCET_RPC_PASSWORD"),
  koto_mainnet_faucet_rpc_host: System.get_env("KOTO_MAINNET_FAUCET_RPC_HOST"),
  koto_mainnet_faucet_rpc_user: System.get_env("KOTO_MAINNET_FAUCET_RPC_USER"),
  koto_mainnet_faucet_rpc_password: System.get_env("KOTO_MAINNET_FAUCET_RPC_PASSWORD"),
  re_captcha_site_key: System.get_env("FAUCET_RECAPTCHA_SITE_KEY"),
  re_captcha_secret_key: System.get_env("FAUCET_RECAPTCHA_SECRET_KEY")

# Configures the endpoint
config :torifuku_faucet, TorifukuFaucetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QXrGSyy0VE7jVaUSXlmhpDtf7ee2cSfOr2cg2TOKFZoZe9J2BIgcVwAVpoOV+dMu",
  render_errors: [view: TorifukuFaucetWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TorifukuFaucet.PubSub,
  live_view: [signing_salt: "0sVfp1HR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
