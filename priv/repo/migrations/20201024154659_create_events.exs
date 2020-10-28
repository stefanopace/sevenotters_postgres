defmodule SevenottersPostgres.Repo.Migrations.CreateEvents   do
  use Ecto.Migration

  @table :events

  def up do
    create table(@table, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string, null: false
      add :counter, :bigint, null: false
      add :request_id, :string, null: true
      add :process_id, :string, null: true
      add :correlation_id, :string, null: false
      add :correlation_module, :string, null: false
      add :date, :naive_datetime, null: false
      add :payload, :json, null: false, default: "{}"
    end

    create index(@table, [:type])
  end

  def down do
    drop table(@table)
  end
end
