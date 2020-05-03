defmodule TorifukuFaucet.Faucet.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :address, :string
    field :date, :date
    field :ip_address, :string
    field :txid, :string
    field :type, :string
    field :value, :float
    field :recaptcha_token, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:type, :txid, :address, :ip_address, :date, :value])
    |> validate_required([:type, :txid, :address, :ip_address, :date, :value])
    |> unique_constraint(:type, name: :transactions_type_ip_address_date_index)
    |> unique_constraint(:type, name: :transactions_type_address_date_index)
  end
end
