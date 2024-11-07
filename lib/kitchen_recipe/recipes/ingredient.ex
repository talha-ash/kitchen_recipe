defmodule KitchenRecipe.Recipes.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.{Recipe, RecipeIngredient}

  schema "ingredients" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    field :is_verified, :boolean, default: false

    many_to_many :recipes, KitchenRecipe.Recipes.Recipe,
      join_through: RecipeIngredient,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :description, :image_url, :is_verified])
    |> validate_required([:name, :image_url])
    |> unique_constraint(:name)
  end
end
