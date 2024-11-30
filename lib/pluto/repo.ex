defmodule Pluto.Repo do
  use Ecto.Repo,
    otp_app: :pluto,
    adapter: Ecto.Adapters.Postgres
end
