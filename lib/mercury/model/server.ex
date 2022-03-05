defmodule Mercury.Model.Server do
  use Ecto.Schema
  alias Mercury.Model

  schema "server" do
    field(:name, :string)
    many_to_many(:users, Model.User, join_through: "server_user")
  end
end
