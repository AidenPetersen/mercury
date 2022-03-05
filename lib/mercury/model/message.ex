defmodule Mercury.Model.Message do
  use Ecto.Schema
  alias Mercury.Model

  schema "message" do
    field(:name, :string)
    belongs_to(:channel, Model.Channel)
    belongs_to(:user, Model.User)
  end
end
