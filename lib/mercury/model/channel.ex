defmodule Mercury.Model.Channel do
  use Ecto.Schema
  alias Mercury.Model

  schema "channel" do
    field(:name, :string)
    belongs_to(:server, Model.Server)
  end
end
