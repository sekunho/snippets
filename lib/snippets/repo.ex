defmodule Snippets.Repo do
  use Ecto.Repo,
    otp_app: :snippets,
    adapter: Ecto.Adapters.Postgres
end
