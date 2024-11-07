defmodule KitchenRecipe.Recipes.RecipeComment do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.Recipe
  alias KitchenRecipe.Accounts.User

  schema "recipe_comments" do
    field :content, :string

    belongs_to :user, User
    belongs_to :recipe, Recipe

    timestamps(type: :utc_datetime)
  end

  def changeset(recipe_comment, attrs) do
    recipe_comment
    |> cast(attrs, [:content, :user_id, :recipe_id])
    |> validate_required([:content, :user_id, :recipe_id])
  end
end
