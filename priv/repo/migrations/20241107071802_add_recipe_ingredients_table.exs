defmodule KitchenRecipe.Repo.Migrations.AddRecipeIngredientsTable do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients) do
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false
      add :ingredient_id, references(:ingredients, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_ingredients, [:recipe_id])
    create index(:recipe_ingredients, [:ingredient_id])
    create unique_index(:recipe_ingredients, [:recipe_id, :ingredient_id])
  end
end
