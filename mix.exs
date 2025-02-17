defmodule SevenottersPostgres.MixProject do
  use Mix.Project

  def project do
    [
      app: :sevenotters_postgres,
      version: "0.2.2",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Seven Otters PostgreSQL support",
      source_url: "https://github.com/sevenotters",
      homepage_url: "https://www.sevenotters.org",

      # Package
      description: "PostgreSQL persistence support for Seven Otters.",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SevenottersPostgres.Application, []}
    ]
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nicola Fiorillo"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sevenotters/sevenotters_postgres"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:atomic_map, "~> 0.9"},
      {:ecto_sql, "~> 3.4"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:postgrex, "~> 0.15"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
