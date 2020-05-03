defmodule TorifukuFaucet.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :string, null: false
      add :txid, :text, null: false
      add :address, :string, null: false
      add :ip_address, :string, null: false
      add :date, :date, null: false
      add :value, :float, null: false

      timestamps()
    end

    create index(:transactions, [:type])
    create unique_index(:transactions, [:type, :ip_address, :date])
    create unique_index(:transactions, [:type, :address, :date])
  end
end
