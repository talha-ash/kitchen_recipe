defmodule KitchenRecipe.Repo.Migrations.AddRecipeLikesTable do
  use Ecto.Migration

  def change do
    create table(:recipe_likes) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_likes, [:user_id])
    create index(:recipe_likes, [:recipe_id])
    create unique_index(:recipe_likes, [:user_id, :recipe_id])
  end
end
