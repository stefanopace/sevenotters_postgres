defmodule SevenottersPostgres.Repo do
  use Ecto.Repo,
    otp_app: :sevenotters_postgres,
    adapter: Ecto.Adapters.Postgres
end
