defmodule SevenottersPostgres.Repo.Migrations.CreateProcesses   do
  use Ecto.Migration

  @table :processes

  def up do
    create table(@table, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :process_id, :string, null: false
      add :status, :string, null: false
      add :state, :json, null: false, default: "{}"
    end

    create unique_index(@table, [:process_id])
    create index(@table, [:status])
  end

  def down do
    drop table(@table)
  end
end
