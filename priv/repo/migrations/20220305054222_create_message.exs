defmodule Mercury.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :contents, :string
      add :channel_id, references(:channel)
      add :user_id, references(:user)
    end
  end
end
