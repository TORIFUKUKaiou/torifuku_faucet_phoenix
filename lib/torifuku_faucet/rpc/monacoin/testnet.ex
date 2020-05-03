defmodule TorifukuFaucet.Rpc.Monacoin.Testnet do
  use TorifukuFaucet.Rpc

  @url "http://#{Application.get_env(:torifuku_faucet, :monacoin_testnet_faucet_rpc_host)}:19402"
  @rpc_user Application.get_env(:torifuku_faucet, :monacoin_testnet_faucet_rpc_user)
  @rpc_password Application.get_env(:torifuku_faucet, :monacoin_testnet_faucet_rpc_password)

  defp url(), do: @url
  defp rpc_user(), do: @rpc_user
  defp rpc_password(), do: @rpc_password
end
