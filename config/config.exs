use Mix.Config

# Configures the endpoint
config :uml_hdxir, UmlHdxir.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9NtHRl33suP4CbK11GrVHiMDAqIanmXUnmbA8PuMQlpPrpUTo9mMZas/BGscuNky",
  render_errors: [view: UmlHdxir.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UmlHdxir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
