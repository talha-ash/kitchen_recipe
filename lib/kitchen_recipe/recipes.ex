defmodule KitchenRecipe.Recipes do
  import Ecto.Query, only: [from: 2]

  alias KitchenRecipe.Repo
  alias KitchenRecipe.Recipes.{Recipe, RecipeLike, Tag, Ingredient, SavedRecipe}

  def get_recipe!(recipe_id) do
    Repo.get!(Recipe, recipe_id)
  end

  def get_recipe_with_preload(recipe_id) do
    Repo.get!(Recipe, recipe_id)
    |> Repo.preload([:tags, :ingredients, :cooking_steps, :recipe_images])
  end

  def get_recipes_by_user(user_id) do
    Repo.all(from(r in Recipe, where: r.user_id == ^user_id))
  end

  # Todo clean it
  def get_recipes_by_user(user_id, offset, limit) do
    Repo.all(
      from(r in Recipe,
        preload: [:recipe_images, :user],
        where: r.user_id == ^user_id,
        limit: ^limit,
        offset: ^offset
      )
    )
  end

  def get_user_saved_recipes_count(user_id) do
    Repo.one(from(r in SavedRecipe, where: r.user_id == ^user_id, select: count()))
  end

  def get_recipes_by_user_count(user_id) do
    Repo.one(from(r in Recipe, where: r.user_id == ^user_id, select: count()))
  end

  def get_user_recipes_likes_count(user_id) do
    Repo.one(from(r in RecipeLike, where: r.user_id == ^user_id, select: count()))
  end

  def get_top_recipes_by_date(date \\ Date.utc_today(), limit \\ 5) do
    Repo.all(
      from(r in Recipe,
        join: rl in RecipeLike,
        on: rl.recipe_id == r.id,
        group_by: [r.id],
        order_by: [desc: count(rl.id)],
        # where: fragment("?::date = ?::date", r.updated_at, type(^date, :naive_datetime)),
        where: fragment("DATE(?)", r.updated_at) == ^date,
        limit: ^limit,
        select: %{id: r.id, title: r.title, user_id: r.user_id, likes_count: count(rl.id)}
      )
    )
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
