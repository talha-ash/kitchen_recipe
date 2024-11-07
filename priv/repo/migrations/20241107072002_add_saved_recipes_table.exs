defmodule KitchenRecipe.Repo.Migrations.AddSavedRecipesTable do
  use Ecto.Migration

  def change do
    create table(:saved_recipes) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :recipe_id, references(:recipes, on_delete: :restrict), null: false

      add :recipe_category_id, references("recipe_categories", on_delete: :nilify_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:saved_recipes, [:user_id])
    create index(:saved_recipes, [:recipe_id])
    create index(:saved_recipes, [:recipe_category_id])
    create unique_index(:saved_recipes, [:user_id, :recipe_id])

    # Prevent users from saving their own recipes
    # TodoPoint - add a constraint to prevent users from
    # saving their own recipes
  end
end
