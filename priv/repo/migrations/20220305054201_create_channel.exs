defmodule Mercury.Repo.Migrations.CreateChannel do
  use Ecto.Migration

  def change do
    create table(:channel) do
      add :name, :string
      add :server_id, references(:server)
    end
  end
end
