defmodule KitchenRecipe.Recipes.RecipeLike do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.{Recipe}
  alias KitchenRecipe.Accounts.User

  schema "recipe_likes" do
    belongs_to :user, User, on_replace: :delete
    belongs_to :recipe, Recipe, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(recipe_like, attrs) do
    recipe_like
    |> cast(attrs, [:user_id, :recipe_id])
    |> validate_required([:user_id, :recipe_id])
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user_id, :recipe_id],
      name: :recipe_likes_recipe_id_user_id_index,
      message: "User already like this recipe"
    )
  end
end
