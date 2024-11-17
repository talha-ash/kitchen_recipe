defmodule KitchenRecipeWeb.LandingPageLive do
  use KitchenRecipeWeb, :live_view

  def mount(_param, _session, socket) do
    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-img-wrapper">
      <nav class="logo-wrapper container">
        <a href=""><img src="./assets/images/scratch-logo.png" alt="" /></a>
      </nav>
      <main class="main-text-wrapper">
        <div class="text-content container">
          <h1>Join over 50 millions people
            sharing recipes everyday</h1>
          <p>Never run out of ideas again. Try new foods, ingredients, cooking style, and more</p>
          <div class="btn-wrapper">
            <.link navigate={~p"/users/log_in"} class="button-primary">
              join scratch
            </.link>
          </div>
        </div>
      </main>
    </div>
    """
  end
end
