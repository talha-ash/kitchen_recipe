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

  def new_changeset(%__MODULE__{} = recipe_image, attrs, %{recipe_id: recipe_id}) do
    Map.put(recipe_image, :scope_id, recipe_id)
    |> cast(attrs, [:image_url])
    |> validate_required([:image_url])
  end

  def new_changeset(%__MODULE__{} = recipe_image, attrs) do
    recipe_image
    |> cast(attrs, [:image_url])
    |> validate_required([:image_url])
  end

  def cast_assoc_with_recipe(changeset, recipe_id) do
    changeset
    |> cast_assoc(:recipe_images,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end

  def cast_assoc_with_recipe(changeset) do
    changeset
    |> cast_assoc(:recipe_images,
      required: true,
      with: {__MODULE__, :new_changeset, []}
    )
  end
end
