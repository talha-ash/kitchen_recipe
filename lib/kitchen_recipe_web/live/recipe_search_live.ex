defmodule KitchenRecipeWeb.RecipeSearchLive do
  use KitchenRecipeWeb, :live_view
  alias KitchenRecipe.{Accounts, Recipes}
  import KitchenRecipeWeb.SearchRecipe.Components
  @search_context_recipe "recipe"
  @search_context_profile "profile"
  @search_context_none ""

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        recipe_search_page: true,
        search_context: @search_context_none,
        ingredient_count: 0,
        serve_time: 0,
        search_query: ""
      )
      |> get_search_data()

    {:ok, socket}
  end

  def handle_event("search-submit", %{"search" => search_query}, socket) do
    socket =
      assign(socket, search_query: search_query)
      |> get_search_data()

    {:noreply, socket}
  end

  def handle_event("apply-filter", _param, socket) do
    {:noreply, get_search_data(socket)}
  end

  def handle_event(
        "range-input-change",
        %{"name" => "ingredient-count", "value" => value},
        socket
      ) do
    {:noreply, assign(socket, ingredient_count: value)}
  end

  def handle_event("range-input-change", %{"name" => "serve-time", "value" => value}, socket) do
    {:noreply, assign(socket, serve_time: value)}
  end

  def handle_event("change-search-context", %{"search-context" => search_context}, socket) do
    selected_search_context = socket.assigns.search_context

    cond do
      search_context == selected_search_context ->
        {:noreply, assign(socket, search_context: @search_context_none)}

      search_context == @search_context_recipe ->
        {:noreply, assign(socket, search_context: @search_context_recipe)}

      search_context == @search_context_profile ->
        {:noreply, assign(socket, search_context: @search_context_profile)}
    end
  end

  defp get_search_data(socket) do
    users = Accounts.get_user_by_search(socket.assigns.search_query)

    recipes =
      Recipes.get_recipe_by_search(
        socket.assigns.search_query,
        socket.assigns.ingredient_count,
        socket.assigns.serve_time
      )

    socket |> assign(users: users, recipes: recipes)
  end
end
