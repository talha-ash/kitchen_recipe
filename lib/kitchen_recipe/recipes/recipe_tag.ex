defmodule KitchenRecipe.Recipes.RecipeTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.{Recipe, Tag}

  schema "recipe_tags" do
    belongs_to :recipe, Recipe
    belongs_to :tag, Tag

    timestamps(type: :utc_datetime)
  end

  def changeset(recipe_tag, attrs) do
    recipe_tag
    |> cast(attrs, [:recipe_id, :tag_id])
    |> validate_required([:recipe_id, :tag_id])
    |> unique_constraint([:recipe_id, :tag_id])
  end
end
