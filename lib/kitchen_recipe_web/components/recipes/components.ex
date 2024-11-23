defmodule KitchenRecipeWeb.Components.Recipe.Components do
  use Phoenix.Component
  use KitchenRecipeWeb, :verified_routes

  def create_recipe_bar(assigns) do
    ~H"""
    <div class="create-recipe-bar-wrapper spacing">
      <div class="create-recipe-bar-content">
        <strong class="font-styling">286 of your followers are online</strong>
        <div class="create-recipe-button-wrapper">
          <.link href={~p"/recipe/new"}>Create Recipe</.link>
        </div>
      </div>
    </div>
    """
  end
end
