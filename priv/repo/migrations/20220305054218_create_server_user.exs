defmodule Mercury.Repo.Migrations.CreateServerUser do
  use Ecto.Migration

  def change do
    create table(:server_user) do
      add :user_id, references(:user)
      add :server_id, references(:server)
      add :role, :decimal
    end
  end
end
