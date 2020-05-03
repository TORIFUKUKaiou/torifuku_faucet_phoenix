defmodule TorifukuFaucet.Rpc.Koto.Mainnet do
  use TorifukuFaucet.Rpc

  @url "http://#{Application.get_env(:torifuku_faucet, :koto_mainnet_faucet_rpc_host)}:8432"
  @rpc_user Application.get_env(:torifuku_faucet, :koto_mainnet_faucet_rpc_user)
  @rpc_password Application.get_env(:torifuku_faucet, :koto_mainnet_faucet_rpc_password)

  defp url(), do: @url
  defp rpc_user(), do: @rpc_user
  defp rpc_password(), do: @rpc_password
end
