defmodule KitchenRecipe.Recipes.RecipeImage do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.Recipe

  schema "recipe_images" do
    field :image_url, :string
    field :is_primary, :boolean, default: false
    belongs_to :recipe, Recipe

    timestamps(type: :utc_datetime)
  end

  def changeset(recipe_image, attrs) do
    recipe_image
    |> cast(attrs, [:image_url, :is_primary])
    |> validate_required([:image_url])
  end
end
