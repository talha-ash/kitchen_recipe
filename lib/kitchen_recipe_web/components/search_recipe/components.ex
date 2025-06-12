defmodule KitchenRecipeWeb.SearchRecipe.Components do
  use Phoenix.Component
  use KitchenRecipeWeb, :verified_routes
  import KitchenRecipeWeb.CoreComponents

  def recipe_list(assigns) do
    ~H"""
    <div class="space-y-6">
      <h4 class="text-lg font-medium text-gray-900">Recipes</h4>
      <h4 :if={@recipes == []} class="text-sm font-medium text-gray-600">
        No Recipe Found
      </h4>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for recipe <- @recipes do %>
          <div class="bg-white rounded-lg shadow overflow-hidden">
            <img src={recipe.image_url} alt="" class="w-full h-48 object-cover" />
            <div class="p-4">
              <.link href={~p"/recipes/#{recipe.id}"}>
                <h4 class="text-base font-medium text-gray-900 truncate cursor-pointer">
                  <%= recipe.title %>
                </h4>
              </.link>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def profile_list(assigns) do
    ~H"""
    <div class="space-y-6">
      <h4 class="text-lg font-medium text-gray-900">Profiles</h4>
      <h4 :if={@users == []} class="text-sm font-medium text-gray-600">No Profile Found</h4>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for user <- @users do %>
          <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="h-32 bg-gray-200">
              <img src={user.recipe_image} alt="" class="w-full h-full object-cover" />
            </div>
            <div class="p-4 relative">
              <div class="absolute -top-8 left-4">
                <img
                  src={user.avatar_url}
                  alt=""
                  class="w-16 h-16 rounded-full border-4 border-white"
                />
              </div>
              <div class="pt-8">
                <.link href={~p"/profile/#{user.id}"}>
                  <h4 class="text-base font-medium text-gray-900 cursor-pointer">
                    <.user_name user={user} />
                  </h4>
                </.link>
                <div class="mt-4 flex justify-between text-sm text-gray-500">
                  <div class="text-center">
                    <div class="font-medium text-gray-900"><%= user.recipes_count %></div>
                    <div>recipes</div>
                  </div>
                  <div class="text-center">
                    <div class="font-medium text-gray-900"><%= user.followers_count %></div>
                    <div>followers</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def search_filter(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow p-6 space-y-6">
      <!-- Filter Header -->
      <div class="flex justify-between items-center">
        <h4 class="text-lg font-medium text-gray-900">Search Filters</h4>
        <svg class="w-6 h-6 text-green-500" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <!-- Your SVG path -->
        </svg>
      </div>
      <!-- Ingredients Filter -->
      <div id="search-ingredients-filter" phx-update="ignore" class="space-y-2">
        <div class="flex justify-between items-center">
          <h5 class="text-sm font-medium text-gray-700">Ingredients</h5>
          <span class="text-sm text-gray-600 range-value"><%= @ingredient_count %></span>
        </div>
        <input
          id="ingredient-slider"
          type="range"
          name="ingredient-count"
          min="0"
          max="20"
          phx-hook="slider"
          value={@ingredient_count}
          class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-green-500"
        />
      </div>
      <!-- Serve Time Filter -->
      <div id="search-servetime-filter" phx-update="ignore" class="space-y-2">
        <div class="flex justify-between items-center">
          <h5 class="text-sm font-medium text-gray-700">Serving Time</h5>
          <span class="text-sm text-gray-600 range-value">0-<%= @serve_time %> mins</span>
        </div>
        <input
          id="servetime-slider"
          name="serve-time"
          type="range"
          min="0"
          max="36"
          phx-hook="slider"
          value={@serve_time}
          class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-green-500"
        />
      </div>
      <!-- Search For Section -->
      <div class="space-y-4">
        <h4 class="text-lg font-medium text-gray-900">Search for</h4>
        <div class="flex gap-4">
          <button
            phx-click="change-search-context"
            phx-value-search-context="recipe"
            class={[
              "px-4 py-2 rounded-full text-sm font-medium",
              @search_context == "recipe" && "bg-green-500 text-white",
              @search_context != "recipe" && "bg-gray-100 text-gray-700 hover:bg-gray-200"
            ]}
          >
            <%= @recipes_length %> recipes
          </button>
          <button
            phx-click="change-search-context"
            phx-value-search-context="profile"
            class={[
              "px-4 py-2 rounded-full text-sm font-medium",
              @search_context == "profile" && "bg-green-500 text-white",
              @search_context != "profile" && "bg-gray-100 text-gray-700 hover:bg-gray-200"
            ]}
          >
            <%= @users_length %> profiles
          </button>
        </div>
      </div>
      <!-- Apply Button -->
      <button
        phx-click="apply-filter"
        class="w-full py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors font-medium"
      >
        Apply Filter
      </button>
    </div>
    """
  end
end
