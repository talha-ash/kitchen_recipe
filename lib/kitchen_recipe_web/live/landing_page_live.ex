defmodule KitchenRecipeWeb.LandingPageLive do
  use KitchenRecipeWeb, :live_view

  def mount(_param, _session, socket) do
    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="min-h-screen bg-gradient-to-br from-green-50 to-green-100 relative">
        <!-- Background Pattern -->
        <div class="absolute inset-0 bg-grid-pattern opacity-5"></div>
        <!-- Navigation -->
        <nav class="relative z-10 container mx-auto px-4 py-6">
          <div class="max-w-7xl mx-auto flex justify-between items-center">
            <a href="" class="flex-shrink-0">
              <img src="./images/scratch-logo.png" alt="Scratch Logo" class="h-10" />
            </a>
          </div>
        </nav>
        <!-- Hero Section -->
        <main class="relative z-10 container mx-auto px-4 pt-20 pb-32">
          <div class="max-w-4xl mx-auto text-center">
            <h1 class="text-4xl sm:text-5xl md:text-6xl font-bold text-gray-900 leading-tight mb-6">
              Join over 50 millions people sharing recipes everyday
            </h1>

            <p class="text-xl md:text-2xl text-gray-600 mb-12 max-w-2xl mx-auto">
              Never run out of ideas again. Try new foods, ingredients, cooking style, and more
            </p>

            <.link
              navigate={~p"/users/log_in"}
              class="inline-flex items-center px-8 py-4 rounded-full
                  bg-green-500 text-white font-medium text-lg
                  transform transition duration-200
                  hover:bg-green-600 hover:scale-105
                  focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
            >
              <span>Join scratch</span>
              <svg class="ml-2 h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path
                  fill-rule="evenodd"
                  d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
                  clip-rule="evenodd"
                />
              </svg>
            </.link>
            <!-- Floating Food Images (Optional) -->
            <div class="hidden md:block absolute -bottom-8 left-12 transform rotate-12">
              <img
                src="./images/Chocolates.png"
                alt=""
                class="w-32 h-32 object-cover rounded-2xl shadow-xl"
              />
            </div>
            <div class="hidden md:block absolute -top-8 right-12 transform -rotate-6">
              <img
                src="./images/Smoked Carrots & Ginger Mammoth.png"
                alt=""
                class="w-24 h-24 object-cover rounded-2xl shadow-xl"
              />
            </div>
          </div>
        </main>
        <!-- Background Shapes -->
        <div class="absolute top-0 right-0 -translate-y-12 translate-x-12 transform">
          <div class="w-64 h-64 rounded-full bg-green-200 opacity-20 blur-3xl"></div>
        </div>
        <div class="absolute bottom-0 left-0 translate-y-12 -translate-x-12 transform">
          <div class="w-64 h-64 rounded-full bg-green-300 opacity-20 blur-3xl"></div>
        </div>
      </div>
      <style>
        .bg-grid-pattern {
         background-image: linear-gradient(to right, rgb(0 0 0 / 0.1) 1px, transparent 1px),
                           linear-gradient(to bottom, rgb(0 0 0 / 0.1) 1px, transparent 1px);
         background-size: 4rem 4rem;
        }
      </style>
    </div>
    """
  end
end
