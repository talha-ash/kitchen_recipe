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

  def new_changeset(%__MODULE__{} = recipe_image, attrs) do
    recipe_image
    |> cast(attrs, [:image_url, :is_primary])
    |> validate_required([:image_url])
  end

  def cast_assoc_with_recipe(changeset) do
    changeset
    |> cast_assoc(:recipe_images, required: true, with: &new_changeset/2)
    |> validate_primary_image
  end

  defp validate_primary_image(changeset) do
    primary_image_length =
      get_field(changeset, :recipe_images)
      |> Enum.count(fn recipe_image -> recipe_image.is_primary end)

    case primary_image_length do
      0 -> add_error(changeset, :recipe_images, "Recipe must have a primary image")
      1 -> changeset
      _ -> add_error(changeset, :recipe_images, "Recipe must have a single primary image")
    end
  end
end
