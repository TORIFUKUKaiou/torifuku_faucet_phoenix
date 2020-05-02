defmodule TorifukuFaucet.Repo do
  use Ecto.Repo,
    otp_app: :torifuku_faucet,
    adapter: Ecto.Adapters.Postgres
end
