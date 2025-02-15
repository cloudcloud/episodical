defmodule Episodical.Repo do
  use Ecto.Repo,
    otp_app: :episodical,
    adapter: Ecto.Adapters.Postgres
end
