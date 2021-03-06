# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """
# secret_key_base =
#   System.get_env("SECRET_KEY_BASE") ||
#     raise """
#     environment variable SECRET_KEY_BASE is missing.
#     You can generate one by calling: mix phx.gen.secret
#     """



config :read_pg, ReadPg.Repo,
  username: "postgres",
  password: "postgres",
  database: "drg_prod",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 36


config :read_pg, ReadPgWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "3009"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: "02kWiRb2hX1WLfm4/EfLCQHOWe/w0w2QVCSXkOgXJSxtA7lOZvehTUHTmykFemqd"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :read_pg, ReadPgWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
