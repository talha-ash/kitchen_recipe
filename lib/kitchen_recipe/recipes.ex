defmodule KitchenRecipe.Recipes do
  import Ecto.Query, only: [from: 2]
  alias KitchenRecipe.Recipes.Ingredient
  alias KitchenRecipe.Recipes.Tag
  alias KitchenRecipe.Repo
  alias KitchenRecipe.Recipes.Recipe

  def get_recipe!(recipe_id) do
    Repo.get!(Recipe, recipe_id)
  end

  def get_recipe_with_preload(recipe_id) do
    Repo.get!(Recipe, recipe_id)
    |> Repo.preload([:tags, :ingredients, :cooking_steps, :recipe_images])
  end

  def get_recipes_by_user!(user_id) do
    Repo.all(from(r in Recipe, where: r.user_id == ^user_id))
  end

  def get_tags() do
    Repo.all(Tag)
  end

  def get_ingredients() do
    Repo.all(Ingredient)
  end

  def create_or_update_recipe(attrs, "") do
    recipe_changeset = Recipe.create_changeset(attrs)

    Repo.transaction(fn ->
      case Repo.insert(recipe_changeset) do
        {:ok, recipe} -> recipe
        # Rollback with changeset
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
    |> case do
      {:ok, recipe} -> {:ok, recipe}
      # Get the rolled back changeset
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_or_update_recipe(attrs, recipe_id) do
    recipe =
      get_recipe!(recipe_id)
      |> Repo.preload([:tags, :ingredients, :cooking_steps, :recipe_images])

    recipe_changeset = Recipe.update_changeset(recipe, attrs)

    Repo.transaction(fn ->
      case Repo.update(recipe_changeset) do
        {:ok, recipe} -> recipe
        # Rollback with changeset
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
    |> case do
      {:ok, recipe} -> {:ok, recipe}
      # Get the rolled back changeset
      {:error, changeset} -> {:error, changeset}
    end
  end
end
