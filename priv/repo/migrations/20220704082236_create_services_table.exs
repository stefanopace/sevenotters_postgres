defmodule SevenottersPostgres.Repo.Migrations.CreateServicesTable do
  use Ecto.Migration

  @table :services

  def change do
    create table(@table, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:server_name, :string, null: false)
      add(:state, :json, null: false, default: "{}")

      timestamps(type: :naive_datetime_usec, updated_at: false)
    end

    create(unique_index(@table, [:server_name]))
  end
end
