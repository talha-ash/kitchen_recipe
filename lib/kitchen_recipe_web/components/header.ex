defmodule KitchenRecipeWeb.Components.Header do
  use KitchenRecipeWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <header class="bg-white shadow-sm fixed w-full top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
          <!-- Logo -->
          <.link href={~p"/"} class="flex-shrink-0">
            <img src="/images/scratch-logo.png" alt="scratch-logo" class="h-8" />
          </.link>
          <!-- Search Bar -->
          <form
            phx-submit="search-submit"
            class={[
              "max-w-xl w-full mx-8",
              not @recipe_search_page && "cursor-pointer"
            ]}
            phx-click={not @recipe_search_page && JS.navigate(~p"/recipe-search")}
          >
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <svg class="h-5 w-5 text-gray-400" viewBox="0 0 24 24" fill="none">
                  <circle cx="11" cy="11" r="6" stroke="currentColor" />
                  <path
                    d="M15.5 15.5L18.6866 18.6866"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  />
                </svg>
              </div>
              <input
                type="text"
                name="search"
                value={@search_query}
                autofocus={@recipe_search_page}
                placeholder="Search Recipe or Profile"
                class="block w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg
                     text-sm placeholder-gray-400 focus:outline-none focus:ring-2
                     focus:ring-green-500 focus:border-transparent"
              />
            </div>
          </form>
          <!-- User Menu -->
          <div class="flex items-center space-x-4">
            <!-- Notifications (Optional) -->
            <button class="p-2 text-gray-400 hover:text-gray-500 rounded-full hover:bg-gray-100">
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                />
              </svg>
            </button>
            <!-- Profile Dropdown -->
            <div class="relative">
              <button
                phx-click={JS.toggle(to: "#header-profile-dropdown", in: "fade-in", out: "fade-out")}
                class="flex items-center space-x-2 focus:outline-none"
              >
                <img
                  src={@current_user.avatar_url}
                  alt=""
                  class="h-8 w-8 rounded-full object-cover border border-gray-200"
                />
                <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                    clip-rule="evenodd"
                  />
                </svg>
              </button>
              <!-- Dropdown Menu -->
              <div
                id="header-profile-dropdown"
                class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 hidden"
              >
                <div class="border-t border-gray-100"></div>
                <.link
                  href={~p"/users/log_out"}
                  method="delete"
                  class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100"
                >
                  Sign out
                </.link>
              </div>
            </div>
          </div>
        </div>
      </header>
      <!-- Add padding for fixed header -->
      <div class="pt-16"></div>
    </div>
    """
  end
end
