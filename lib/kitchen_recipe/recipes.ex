defmodule KitchenRecipe.Recipes do
  import Ecto.Query

  alias KitchenRecipe.Repo

  alias KitchenRecipe.Recipes.{
    Recipe,
    RecipeComment,
    RecipeLike,
    Tag,
    Ingredient,
    SavedRecipe,
    RecipeCategory,
    RecipeImage,
    RecipeIngredient
  }

  def get_recipe!(recipe_id) do
    Repo.get!(Recipe, recipe_id)
  end

  def get_recipe_with_preload(recipe_id) do
    Repo.get!(Recipe, recipe_id)
    |> Repo.preload([:tags, :ingredients, :cooking_steps, :recipe_images])
  end

  # Todo clean it
  def get_recipes_by_user(user_id, opts \\ []) do
    query = from(r in Recipe, preload: [:recipe_images, :user], where: r.user_id == ^user_id)

    Enum.reduce(opts, query, fn {key, value}, acc ->
      case key do
        :limit -> acc |> limit(^value)
        :offset -> acc |> offset(^value)
        _ -> acc
      end
    end)
    |> Repo.all()
  end

  # Todo clean it
  def get_recipes(user_id, opts \\ []) do
    query =
      from(
        r in Recipe,
        preload: [:recipe_images, :user],
        left_join: rl in RecipeLike,
        on: r.id == rl.recipe_id,
        left_join: c in RecipeComment,
        on: r.id == c.recipe_id,
        group_by: r.id,
        select_merge: %{
          likes_count: count(fragment("distinct ?", rl.id)),
          comments_count: count(fragment("distinct ?", c.id)),
          like_by_current_user:
            count(fragment("case when ? = ? then 1 end", rl.user_id, ^user_id))
        }
      )

    Enum.reduce(opts, query, fn {key, value}, acc ->
      case key do
        :limit ->
          acc |> limit(^value)

        :offset ->
          acc |> offset(^value)

        :where ->
          acc |> where(^value)

        _ ->
          acc
      end
    end)
    |> Repo.all()
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

  def like_recipe(recipe_id, user_id) do
    case user_liked_recipe?(recipe_id, user_id) do
      nil ->
        %RecipeLike{}
        |> RecipeLike.changeset(%{recipe_id: recipe_id, user_id: user_id})
        |> Repo.insert()

      recipe_like ->
        Repo.delete(recipe_like)
    end
  end

  def get_recipe_likes(recipe_id) do
    Repo.all(from(r in RecipeLike, where: r.recipe_id == ^recipe_id, select: count()))
    |> Enum.at(0)
  end

  def get_recipe_comments(recipe_id) do
    Repo.all(
      from RecipeComment,
        preload: [:user],
        where: [recipe_id: ^recipe_id],
        order_by: [desc: :inserted_at]
    )
  end

  def get_user_recipes_by_category(category_id, user_id) do
    query =
      from(r in Recipe,
        where:
          r.user_id == ^user_id and
            r.recipe_category_id == ^category_id,
        left_join: ing in RecipeIngredient,
        on: ing.recipe_id == r.id,
        left_join: ri in RecipeImage,
        on: ri.recipe_id == r.id and ri.is_primary == true,
        group_by: [r.id, ri.id],
        select: %{
          id: r.id,
          title: r.title,
          user_id: r.user_id,
          serve_time: r.serve_time,
          image_url: ri.image_url,
          ingredient_count: count(ing.id)
        }
      )

    Repo.all(query)
  end

  def get_recipe_categories() do
    Repo.all(RecipeCategory)
  end

  def get_user_recipe_categories(user_id) do
    query =
      from rc in RecipeCategory,
        join: r in Recipe,
        on: rc.id == r.recipe_category_id and r.user_id == ^user_id,
        select: %{id: rc.id, name: rc.name, image_url: rc.image_url}

    Repo.all(query)
  end

  defp user_liked_recipe?(recipe_id, user_id) do
    Repo.get_by(RecipeLike, recipe_id: recipe_id, user_id: user_id)
  end
end
