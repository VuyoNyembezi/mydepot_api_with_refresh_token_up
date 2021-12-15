defmodule MydepotApi.Repo do
  use Ecto.Repo,
    otp_app: :mydepot_api,
    adapter: Ecto.Adapters.Postgres
end
