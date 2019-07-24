use Mix.Config

config :ex_chargebee,
  site: System.get_env("CHARGEBEE_SITE"),
  api_key: System.get_env("CHARGEBEE_API_KEY")
