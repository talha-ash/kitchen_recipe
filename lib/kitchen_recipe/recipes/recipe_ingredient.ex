defmodule KitchenRecipe.Recipes.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.{Recipe, Ingredient}

  schema "recipe_ingredients" do
    belongs_to :recipe, Recipe, on_replace: :delete
    belongs_to :ingredient, Ingredient, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:recipe_id, :ingredient_id])
    |> validate_required([:recipe_id, :ingredient_id])
  end
end
