defmodule KitchenRecipeWeb.RecipeLive do
  alias KitchenRecipe.Recipes
  use KitchenRecipeWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    id = String.to_integer(id)
    recipe = Recipes.get_recipe_with_preload(id)

    socket =
      socket
      |> assign(:recipe, recipe)
      |> assign(recipe_primary_image: recipe_primary_image(recipe))
      |> assign(recipe_other_images: recipe_other_images(recipe))

    {:ok, socket, temporary_assigns: [recipe: nil]}
  end

  defp recipe_primary_image(recipe) do
    IO.inspect(recipe, label: "recipe")

    Enum.find(recipe.recipe_images, &(&1.is_primary == true))
    |> Map.get(:image_url)
  end

  defp recipe_other_images(recipe) do
    Enum.filter(recipe.recipe_images, &(&1.is_primary == false))
    |> Enum.map(& &1.image_url)
  end
end
