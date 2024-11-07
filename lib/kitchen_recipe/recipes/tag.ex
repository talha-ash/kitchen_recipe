defmodule KitchenRecipe.Recipes.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.{Recipe, RecipeTag}

  schema "tags" do
    field :name, :string
    field :description, :string

    many_to_many :recipes, Recipe, join_through: RecipeTag

    timestamps(type: :utc_datetime)
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
