defmodule KitchenRecipe.Repo.Migrations.AddRecipeCommentsTable do
  use Ecto.Migration

  def change do
    create table(:recipe_comments) do
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_comments, [:user_id])
    create index(:recipe_comments, [:recipe_id])
  end
end
