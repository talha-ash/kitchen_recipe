defmodule KitchenRecipeWeb.FeedLive do
  use KitchenRecipeWeb, :live_view
  import KitchenRecipeWeb.Sidebar
  import KitchenRecipeWeb.Recipe.Components
  alias KitchenRecipe.Accounts
  alias KitchenRecipe.Recipes
  alias KitchenRecipeWeb.RecipeFeed.PeopleSuggestion
  alias KitchenRecipeWeb.Recipes.Recipe

  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id

    second_recipe =
      Recipes.get_recipes(current_user_id, limit: 1, offset: 1) |> Enum.at(0, %{id: 0})

    socket =
      socket
      |> assign_async(
        [:user_info, :top_recipes],
        fn -> get_feed_async_data(current_user_id) end
      )
      |> assign(page: 0, per_page: 20)
      |> assign(people_suggestion_cursor: second_recipe.id)
      |> paginate_recipes(1)

    {:ok, socket}
  end

  def handle_info({:comment_added, recipe_id}, socket) do
    current_user_id = socket.assigns.current_user.id
    recipe = Recipes.get_recipes(current_user_id, where: [id: recipe_id]) |> List.first()

    socket = stream_insert(socket, :recipes, recipe)
    {:noreply, socket}
  end

  def handle_event("like-recipe", %{"id" => id}, socket) do
    current_user_id = socket.assigns.current_user.id
    recipe_id = String.to_integer(id)
    Recipes.like_recipe(recipe_id, current_user_id)
    recipe = Recipes.get_recipes(current_user_id, where: [id: recipe_id]) |> List.first()

    socket = stream_insert(socket, :recipes, recipe)
    {:noreply, socket}
  end

  def handle_event("load-more-bottom", _, socket) do
    IO.inspect(" Call me again and again")
    {:noreply, paginate_recipes(socket, socket.assigns.page + 1)}
  end

  def handle_event("load-more-top", %{"_overran" => true}, socket) do
    {:noreply, paginate_recipes(socket, 1)}
  end

  def handle_event("load-more-top", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate_recipes(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end

  defp paginate_recipes(socket, new_page) when new_page >= 1 do
    %{page: cur_page, per_page: per_page, current_user: current_user} = socket.assigns

    recipes =
      Recipes.get_recipes(current_user.id, offset: (new_page - 1) * per_page, limit: per_page)

    {recipes, at, limit} =
      if new_page > cur_page do
        {recipes, -1, per_page * 3 * -1}
      else
        {Enum.reverse(recipes), 0, per_page * 3}
      end

    case recipes do
      [] ->
        assign(socket, end_of_timeline?: at == -1)
        |> assign(page: new_page)
        |> stream(:recipes, recipes, at: at, limit: limit)

      [_ | _] = recipes ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(page: new_page)
        |> stream(:recipes, recipes, at: at, limit: limit)
    end
  end

  defp get_feed_async_data(user_id) do
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
