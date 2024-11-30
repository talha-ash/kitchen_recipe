defmodule KitchenRecipeWeb.ProfileLive do
  alias KitchenRecipeWeb.Components.Recipes
  use KitchenRecipeWeb, :live_view
  import KitchenRecipeWeb.Components.Sidebar, only: [user_detail: 1, other_user_detail: 1]
  alias KitchenRecipe.Accounts
  alias KitchenRecipe.Recipes

  def mount(%{"id" => id}, _session, socket) do
    current_user_id = socket.assigns.current_user.id
    visit_user_id = String.to_integer(id)

    recipe_categories = Recipes.get_user_recipe_categories(visit_user_id)
    first_category = recipe_categories |> List.first()
    recipes = Recipes.get_user_recipes_by_category(first_category.id, visit_user_id)
    is_current_user = if visit_user_id == current_user_id, do: :current_user, else: :other

    socket =
      socket
      |> assign_async(
        :user_info,
        fn -> get_profile_async_data(is_current_user, visit_user_id) end
      )
      |> assign(visit_user_id: visit_user_id)
      |> assign(is_current_user: is_current_user)
      |> assign(recipe_categories: recipe_categories)
      |> assign(recipes: recipes)
      |> assign(selected_category_id: first_category.id)

    {:ok, socket, temporary_assigns: [recipes: nil]}
  end

  def handle_event("select-category", %{"id" => id}, socket) do
    id = String.to_integer(id)
    visit_user_id = socket.assigns.visit_user_id
    recipes = Recipes.get_user_recipes_by_category(id, visit_user_id)
    socket = socket |> assign(recipes: recipes) |> assign(selected_category_id: id)
    {:noreply, socket}
  end

  defp get_profile_async_data(:other, user_id) do
    recipes_likes = Recipes.get_user_recipes_likes_count(user_id)

    %{followers_count: followers_count} = Accounts.get_follow_counts(user_id)

    {:ok,
     %{
       user_info: %{
         recipes_likes: recipes_likes,
         followers_count: followers_count
       }
     }}
  end

  defp get_profile_async_data(:current_user, user_id) do
    recipe_counts = Recipes.get_recipes_by_user_count(user_id)
    recipes_likes = Recipes.get_user_recipes_likes_count(user_id)
    saved_recipes = Recipes.get_user_saved_recipes_count(user_id)

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
       }
     }}
  end

  defp active_category_class(selected_category_id, category_id) do
    if selected_category_id == category_id do
      "border-2 border-black transition transform translate-x-[1px] duration-300"
    else
      ""
    end
  end
end
