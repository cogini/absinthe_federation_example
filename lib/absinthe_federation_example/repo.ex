defmodule AbsintheFederationExample.Repo do
  use Ecto.Repo,
    otp_app: :absinthe_federation_example,
    adapter: Ecto.Adapters.Postgres
end
