defmodule TorifukuFaucetWeb.TransactionLive.FormComponent do
  use TorifukuFaucetWeb, :live_component

  alias TorifukuFaucet.Faucet

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Faucet.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Faucet.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :new, transaction_params) do
    IO.inspect(transaction_params)

    verify(transaction_params["recaptcha_token"])
    |> do_save_transaction(socket, transaction_params)
  end

  defp do_save_transaction({:error, body}, socket, _transaction_params) do
    IO.inspect(body)

    {:noreply,
     socket
     |> put_flash(:error, "Transaction created unsuccessfully")
     |> push_redirect(to: socket.assigns.return_to)}
  end

  defp do_save_transaction({:ok, body}, socket, transaction_params) do
    IO.inspect(body)

    attrs =
      transaction_params
      |> Map.merge(%{"type" => socket.assigns.type})
      |> Map.merge(%{
        "date" => Date.utc_today()
      })
      |> Map.merge(%{"ip_address" => socket.assigns.ip})

    case Faucet.create_transaction(attrs, save_module(socket.assigns.type)) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Transaction created unsuccessfully")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp save_module("Koto"), do: TorifukuFaucet.Rpc.Koto.Mainnet

  defp save_module("Monacoin"), do: TorifukuFaucet.Rpc.Monacoin.Mainnet

  defp save_module("MonacoinTestnet"), do: TorifukuFaucet.Rpc.Monacoin.Testnet

  @headers [
    {"Content-type", "application/x-www-form-urlencoded"},
    {"Accept", "application/json"}
  ]

  @verify_url "https://www.google.com/recaptcha/api/siteverify"

  @re_captcha_secret_key Application.get_env(:torifuku_faucet, :re_captcha_secret_key)

  defp verify(token) do
    body = %{secret: @re_captcha_secret_key, response: token} |> URI.encode_query()

    case HTTPoison.post(@verify_url, body, @headers) do
      {:ok, response} ->
        body = response.body |> Jason.decode!()

        if body["success"] do
          {:ok, body}
        else
          {:error, body}
        end

      _ ->
        {:error, :verify_error}
    end
  end
end
