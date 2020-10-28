defmodule SevenottersPostgres.Repo.Migrations.CreateSnapshots   do
  use Ecto.Migration

  @table :snapshots

  def up do
    create table(@table, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :correlation_id, :string, null: false
      add :snapshot, :json, null: false, default: "{}"
    end

    create unique_index(@table, [:correlation_id])
  end

  def down do
    drop table(@table)
  end
end
