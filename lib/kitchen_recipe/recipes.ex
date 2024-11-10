defmodule KitchenRecipe.Recipes do
  alias KitchenRecipe.Repo
  alias KitchenRecipe.Recipes.Recipe

  def get_recipe!(recipe_id) do
    Repo.get!(Recipe, recipe_id)
  end

  def create_recipe(attrs) do
    # recipe_changeset = %Recipe{} |> Recipe.changeset(attrs)
    recipe_changeset = Recipe.associated_changeset(attrs)

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

  def update_recipe(recipe_id, attrs) do
    # recipe_changeset = %Recipe{} |> Recipe.changeset(attrs)
    recipe =
      get_recipe!(recipe_id)
      |> Repo.preload([:tags, :ingredients, :cooking_steps, :recipe_images])

    recipe_changeset = Recipe.associated_changeset(recipe, attrs)

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
