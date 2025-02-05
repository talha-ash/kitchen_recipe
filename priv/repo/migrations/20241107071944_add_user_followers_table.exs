defmodule KitchenRecipe.Repo.Migrations.AddUserFollowersTable do
  use Ecto.Migration

  def change do
    create table(:user_followers) do
      add :follower_user_id, references(:users, on_delete: :delete_all), null: false
      add :followed_user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_followers, [:follower_user_id])
    create index(:user_followers, [:followed_user_id])
    create unique_index(:user_followers, [:follower_user_id, :followed_user_id])
  end
end
