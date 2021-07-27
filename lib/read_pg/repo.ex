defmodule ReadPg.Repo do
  use Ecto.Repo,
    otp_app: :read_pg,
    adapter: Ecto.Adapters.Postgres
end
