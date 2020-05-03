defmodule TorifukuFaucetWeb.MonacoinLive.Testnet do
  use TorifukuFaucetWeb.CoinLive

  @transaction_type "MonacoinTestnet"
  @address_cache_key :monacoin_testnet

  defp page_title, do: "Monacoin testnet4 Faucet"
  defp balance, do: TorifukuFaucet.Rpc.Monacoin.Testnet.getbalance()
  defp transaction_type, do: @transaction_type
  defp address_cache_key, do: @address_cache_key
  defp getnewaddress, do: TorifukuFaucet.Rpc.Monacoin.Testnet.getnewaddress()
end
