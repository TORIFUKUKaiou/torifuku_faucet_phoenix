defmodule TorifukuFaucet.FaucetTest do
  use TorifukuFaucet.DataCase

  alias TorifukuFaucet.Faucet

  describe "transactions" do
    alias TorifukuFaucet.Faucet.Transaction

    @valid_attrs %{
      address: "some address",
      date: ~D[2010-04-17],
      ip_address: "some ip_address",
      txid: "some txid",
      type: "some type",
      value: 120.5
    }
    @update_attrs %{
      address: "some updated address",
      date: ~D[2011-05-18],
      ip_address: "some updated ip_address",
      txid: "some updated txid",
      type: "some updated type",
      value: 456.7
    }
    @invalid_attrs %{address: nil, date: nil, ip_address: nil, txid: nil, type: nil, value: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Faucet.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Faucet.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Faucet.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Faucet.create_transaction(@valid_attrs)
      assert transaction.address == "some address"
      assert transaction.date == ~D[2010-04-17]
      assert transaction.ip_address == "some ip_address"
      assert transaction.txid == "some txid"
      assert transaction.type == "some type"
      assert transaction.value == 120.5
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Faucet.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Faucet.update_transaction(transaction, @update_attrs)

      assert transaction.address == "some updated address"
      assert transaction.date == ~D[2011-05-18]
      assert transaction.ip_address == "some updated ip_address"
      assert transaction.txid == "some updated txid"
      assert transaction.type == "some updated type"
      assert transaction.value == 456.7
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Faucet.update_transaction(transaction, @invalid_attrs)
      assert transaction == Faucet.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Faucet.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Faucet.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Faucet.change_transaction(transaction)
    end
  end
end
