defmodule Mercury.Model.User do
  use Ecto.Schema
  alias Mercury.Model

  schema "user" do
    field(:name, :string)
    many_to_many(:servers, Model.Server, join_through: "server_user")
  end
end
