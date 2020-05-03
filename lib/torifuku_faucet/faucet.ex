defmodule TorifukuFaucet.Faucet do
  @moduledoc """
  The Faucet context.
  """

  import Ecto.Query, warn: false
  alias TorifukuFaucet.Repo

  alias TorifukuFaucet.Faucet.Transaction

  @max_page 50

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions(type, current_page, per_page) do
    limit = if current_page <= @max_page, do: per_page, else: 0

    Repo.all(
      from t in Transaction,
        where: t.type == ^type,
        order_by: [desc: t.id],
        offset: ^((current_page - 1) * per_page),
        limit: ^limit
    )
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}, module \\ TorifukuFaucet.Rpc.Monacoin.Testnet) do
    if Repo.exists?(
         from t in Transaction,
           where: t.type == ^attrs["type"],
           where: t.ip_address == ^attrs["ip_address"],
           where: t.date == ^attrs["date"]
       ) ||
         Repo.exists?(
           from t in Transaction,
             where: t.type == ^attrs["type"],
             where: t.address == ^attrs["address"],
             where: t.date == ^attrs["date"]
         ) do
      {:error, Transaction.changeset(%Transaction{}, attrs)}
    else
      case module.sendtoaddress(attrs["address"]) do
        {:ok, {txid, amount}} ->
          %Transaction{}
          |> Transaction.changeset(Map.merge(attrs, %{"txid" => txid, "value" => amount}))
          |> IO.inspect()
          |> Repo.insert()

        :error ->
          {:error, Transaction.changeset(%Transaction{}, attrs)}
      end
    end
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
