defmodule TorifukuFaucet.Rpc do
  defmacro __using__(_opts) do
    quote do
      def getnewaddress do
        case run(url(), rpc_user(), rpc_password(), "getnewaddress", []) do
          %{"error" => nil, "result" => address} -> address
          _ -> :error
        end
      end

      def getbalance do
        case run(url(), rpc_user(), rpc_password(), "getbalance", []) do
          %{"error" => nil, "result" => balance} -> balance
          _ -> :error
        end
      end

      def sendtoaddress(address) do
        amount = amount(getbalance())

        case run(url(), rpc_user(), rpc_password(), "sendtoaddress", [address, amount]) do
          %{"error" => nil, "result" => txid} ->
            {:ok, {txid, amount}}

          %{"error" => error} ->
            IO.inspect(error)
            :error
        end
      end

      defp run(url, rpc_user, rpc_password, method, params) do
        IO.inspect({url, rpc_user, rpc_password, method, params})
        auth = [hackney: [basic_auth: {rpc_user, rpc_password}]]
        body = %{method: method, params: params, id: "jsonrpc"} |> Jason.encode!()
        headers = %{"content_type" => "application/json"}

        case HTTPoison.post(url, body, headers, auth) do
          {:ok, %{body: body}} -> Jason.decode!(body)
          _ -> :error
        end
      end

      defp amount(balance) do
        (balance * 5.527638190954774e-7) |> Float.round(7)
      end
    end
  end
end
