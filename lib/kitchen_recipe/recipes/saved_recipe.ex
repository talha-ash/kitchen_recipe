defmodule KitchenRecipe.Recipes.SavedRecipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.{Recipe, RecipeCategory}
  alias KitchenRecipe.Accounts.User

  schema "saved_recipes" do
    belongs_to :user, User
    belongs_to :recipe, Recipe
    belongs_to :recipe_category, RecipeCategory
    timestamps(type: :utc_datetime)
  end

  def changeset(saved_recipe, attrs) do
    saved_recipe
    |> cast(attrs, [:user_id, :recipe_id, :recipe_category_id])
    |> validate_required([:user_id, :recipe_id])
    |> unique_constraint([:user_id, :recipe_id])
  end
end
