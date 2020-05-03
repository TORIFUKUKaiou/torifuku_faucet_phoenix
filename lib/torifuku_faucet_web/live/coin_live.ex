defmodule TorifukuFaucetWeb.CoinLive do
  defmacro __using__(_opts) do
    quote do
      use TorifukuFaucetWeb, :live_view

      alias TorifukuFaucet.Faucet
      alias TorifukuFaucet.Faucet.Transaction

      @re_captcha_site_key Application.get_env(:torifuku_faucet, :re_captcha_site_key)

      @impl true
      def mount(_params, _session, socket) do
        if info = get_connect_info(socket) do
          {:ok,
           socket
           |> assign(page: 1, per_page: 10)
           |> assign(ip: ip(info))
           |> assign(recaptcha_token: nil)
           |> fetch(), temporary_assigns: [transactions: []]}
        else
          {:ok,
           socket
           |> assign(page: 1, per_page: 10)
           |> assign(ip: nil)
           |> assign(recaptcha_token: nil)
           |> fetch(), temporary_assigns: [transactions: []]}
        end
      end

      def handle_event("load-more", _, %{assigns: assigns} = socket) do
        {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
      end

      def handle_event("get-recaptcha-token", params, socket) do
        {:noreply, assign(socket, :recaptcha_token, params["recaptcha-token"])}
      end

      @impl true
      def handle_params(params, _url, socket) do
        {:noreply, apply_action(socket, socket.assigns.live_action, params)}
      end

      defp apply_action(socket, :new, params) do
        socket
        |> assign(:page_title, "New Transaction")
        |> assign(:balance, balance())
        |> assign(:transaction, %Transaction{type: transaction_type()})
      end

      defp apply_action(socket, :index, %{"recaptcha_token" => recaptcha_token}) do
        apply_action(socket, :index, [])
        |> assign(:recaptcha_token, recaptcha_token)
      end

      defp apply_action(socket, :index, _params) do
        socket
        |> assign(:page_title, page_title())
        |> assign(:balance, balance())
        |> assign(:transaction, nil)
        |> assign(:recaptcha_token, nil)
        |> assign(:wallet_address, wallet_address())
        |> assign(:re_captcha_site_key, @re_captcha_site_key)
      end

      defp fetch(%{assigns: %{page: page, per_page: per}} = socket) do
        assign(socket, transactions: Faucet.list_transactions(transaction_type(), page, per))
      end

      defp wallet_address do
        case TorifukuFaucet.Address.Cache.fetch(address_cache_key()) do
          {:ok, address} ->
            address

          :error ->
            address = getnewaddress()
            :ok = TorifukuFaucet.Address.Cache.put(address_cache_key(), address)
            address
        end
      end

      defp ip(info) do
        if Map.has_key?(info, :x_headers) && Enum.count(info.x_headers) > 0 do
          Enum.find(info.x_headers, {"x-forwarded-for", "127.0.0.1"}, fn {key, _value} ->
            key == "x-forwarded-for"
          end)
          |> elem(1)
        else
          info.peer_data.address
          |> Tuple.to_list()
          |> Enum.join(if tuple_size(info.peer_data.address) == 4, do: ".", else: ":")
        end
      end
    end
  end
end
