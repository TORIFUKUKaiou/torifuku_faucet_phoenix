defmodule TorifukuFaucetWeb.MonacoinLive.Mainnet do
  use TorifukuFaucetWeb.CoinLive

  @transaction_type "Monacoin"
  @address_cache_key :monacoin_mainnet

  defp page_title, do: "Monacoin Faucet"
  defp balance, do: TorifukuFaucet.Rpc.Monacoin.Mainnet.getbalance()
  defp transaction_type, do: @transaction_type
  defp address_cache_key, do: @address_cache_key
  defp getnewaddress, do: TorifukuFaucet.Rpc.Monacoin.Mainnet.getnewaddress()
end
