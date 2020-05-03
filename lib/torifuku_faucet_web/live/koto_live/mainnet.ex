defmodule TorifukuFaucetWeb.KotoLive.Mainnet do
  use TorifukuFaucetWeb.CoinLive

  @transaction_type "Koto"
  @address_cache_key :koto_mainnet

  defp page_title, do: "Koto Faucet"
  defp balance, do: TorifukuFaucet.Rpc.Koto.Mainnet.getbalance()
  defp transaction_type, do: @transaction_type
  defp address_cache_key, do: @address_cache_key
  defp getnewaddress, do: TorifukuFaucet.Rpc.Koto.Mainnet.getnewaddress()
end
