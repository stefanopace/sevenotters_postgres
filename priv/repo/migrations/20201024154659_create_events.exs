defmodule SevenottersPostgres.Repo.Migrations.CreateEvents   do
  use Ecto.Migration

  @table :events

  def up do
    create table(@table, primary_key: false) do
      add :counter, :bigint, primary_key: true
      add :type, :string, null: false
      add :request_id, :string, null: true
      add :process_id, :string, null: true
      add :correlation_id, :string, null: true
      add :correlation_module, :string, null: false
      add :date, :naive_datetime, null: false
      add :payload, :json, null: false, default: "{}"
    end

    create unique_index(@table, [:type, :counter])
    create unique_index(@table, [:correlation_id, :counter])
  end

  def down do
    drop table(@table)
  end
end
