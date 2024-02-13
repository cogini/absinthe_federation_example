defmodule AbsintheFederationExample.News.Link do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "links" do
    field :description, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :description])
    |> validate_required([:url, :description])
  end
end
