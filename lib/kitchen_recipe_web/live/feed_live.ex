defmodule KitchenRecipeWeb.FeedLive do
  alias KitchenRecipe.Accounts
  alias KitchenRecipe.Recipes
  use KitchenRecipeWeb, :live_view
  import KitchenRecipeWeb.Components.Sidebar
  import KitchenRecipeWeb.Components.Recipe.Components

  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id
    recipes = Recipes.get_recipes_by_user(current_user_id, 0, 10)

    socket =
      socket
      |> assign_async(
        [:user_info, :top_recipes],
        fn -> get_user_detail(current_user_id) end
      )
      |> stream(:recipes, recipes)
      |> assign(offset: 0, limit: 10)

    {:ok, socket}
  end

  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:offset, fn offset -> offset + socket.assigns.limit end)
      |> stream_new_recipes()

    {:noreply, socket}
  end

  defp stream_new_recipes(socket) do
    current_user_id = socket.assigns.current_user.id
    offset = socket.assigns.offset
    limit = socket.assigns.limit
    recipes = Recipes.get_recipes_by_user(current_user_id, offset, limit)

    Enum.reduce(recipes, socket, fn recipe, socket ->
      stream_insert(socket, :recipes, recipe)
    end)
  end

  defp get_user_detail(user_id) do
    recipe_counts = Recipes.get_recipes_by_user_count(user_id)
    recipes_likes = Recipes.get_user_recipes_likes_count(user_id)
    saved_recipes = Recipes.get_user_saved_recipes_count(user_id)
    top_recipes = Recipes.get_top_recipes_by_date()

    %{followers_count: followers_count, following_count: following_count} =
      Accounts.get_follow_counts(user_id)

    {:ok,
     %{
       user_info: %{
         recipes_likes: recipes_likes,
         saved_recipes: saved_recipes,
         recipes_count: recipe_counts,
         followers_count: followers_count,
         following_count: following_count
       },
       top_recipes: top_recipes
     }}
  end
end
