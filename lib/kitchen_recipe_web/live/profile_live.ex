defmodule KitchenRecipeWeb.ProfileLive do
  use KitchenRecipeWeb, :live_view
  import KitchenRecipeWeb.Components.Sidebar, only: [user_detail: 1, other_user_detail: 1]
  alias KitchenRecipeWeb.Components.Recipe.CreateRecipeCategory
  alias KitchenRecipe.Accounts
  alias KitchenRecipe.Recipes

  def mount(%{"id" => id}, _session, socket) do
    current_user_id = socket.assigns.current_user.id
    other_user_id = String.to_integer(id)
    recipe_categories = Recipes.get_user_recipe_categories(other_user_id)
    first_category = recipe_categories |> List.first()
    recipes = Recipes.get_user_recipes_by_category(first_category.id, other_user_id)

    user_type = get_user_type(current_user_id, other_user_id)

    other_user =
      if other_user_id != current_user_id, do: Accounts.get_user!(other_user_id), else: nil

    socket =
      socket
      |> assign_async(
        :user_info,
        fn -> get_profile_async_data(user_type, current_user_id, other_user_id) end
      )
      |> assign(other_user: other_user)
      |> assign(user_type: user_type)
      |> assign(recipe_categories: recipe_categories)
      |> assign(recipes: recipes)
      |> assign(selected_category_id: first_category.id)
      |> allow_upload(:category_image, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket, temporary_assigns: [recipes: nil]}
  end

  def handle_event("select-category", %{"id" => id}, socket) do
    id = String.to_integer(id)
    visit_user_id = socket.assigns.visit_user_id
    recipes = Recipes.get_user_recipes_by_category(id, visit_user_id)
    socket = socket |> assign(recipes: recipes) |> assign(selected_category_id: id)
    {:noreply, socket}
  end

  def handle_event("follow-user", _params, socket) do
    other_user = socket.assigns.other_user
    current_user = socket.assigns.current_user

    user_type = get_user_type(current_user.id, other_user.id)
    Accounts.follow_user(current_user.id, other_user.id)

    socket =
      socket
      |> assign_async(
        :user_info,
        fn -> get_profile_async_data(user_type, current_user.id, other_user.id) end
      )

    {:noreply, socket}
  end

  def handle_event("unfollow-user", _params, socket) do
    other_user = socket.assigns.other_user
    current_user = socket.assigns.current_user

    user_type = get_user_type(current_user.id, other_user.id)
    Accounts.unfollow_user(current_user.id, other_user.id)

    socket =
      socket
      |> assign_async(
        :user_info,
        fn -> get_profile_async_data(user_type, current_user.id, other_user.id) end
      )

    {:noreply, socket}
  end

  defp get_user_type(current_user_id, other_user_id) do
    if other_user_id == current_user_id, do: :current_user, else: :other
  end

  defp get_profile_async_data(:other, current_user, other_id) do
    recipes_likes = Recipes.get_user_recipes_likes_count(other_id)

    %{followers_count: followers_count} = Accounts.get_follow_counts(other_id)
    is_following = Accounts.user_following?(current_user, other_id)

    {:ok,
     %{
       user_info: %{
         recipes_likes: recipes_likes,
         followers_count: followers_count,
         is_following: is_following
       }
     }}
  end

  defp get_profile_async_data(:current_user, user_id, _) do
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

  # defp error_to_string(:too_large), do: "Too large"
  # defp error_to_string(:too_many_files), do: "You have selected too many files"
  # defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  # defp error_to_string(_), do: "Please Select Category Image"
end
