# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TorifukuFaucet.Repo.insert!(%TorifukuFaucet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for i <- 1..1000 do
  txid = "txid#{i}"
  address = "address#{i}"
  ip_address = "ip_address#{i}"
  date = Date.utc_today()
  value = i

  {:ok, _} =
    %TorifukuFaucet.Faucet.Transaction{}
    |> TorifukuFaucet.Faucet.Transaction.changeset(%{
      type: "MonacoinTestnet",
      txid: txid,
      address: address,
      ip_address: ip_address,
      date: date,
      value: value
    })
    |> TorifukuFaucet.Repo.insert()

  {:ok, _} =
    %TorifukuFaucet.Faucet.Transaction{}
    |> TorifukuFaucet.Faucet.Transaction.changeset(%{
      type: "Monacoin",
      txid: txid,
      address: address,
      ip_address: ip_address,
      date: date,
      value: value
    })
    |> TorifukuFaucet.Repo.insert()

  {:ok, _} =
    %TorifukuFaucet.Faucet.Transaction{}
    |> TorifukuFaucet.Faucet.Transaction.changeset(%{
      type: "Koto",
      txid: txid,
      address: address,
      ip_address: ip_address,
      date: date,
      value: value
    })
    |> TorifukuFaucet.Repo.insert()
end
