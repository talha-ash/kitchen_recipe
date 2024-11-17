defmodule KitchenRecipeWeb.RecipeCrudLive do
  use KitchenRecipeWeb, :live_view
  alias KitchenRecipe.Recipes.{Tag}
  alias KitchenRecipe.Recipes
  alias KitchenRecipe.Recipes
  alias KitchenRecipeWeb.RecipeComponent.CreateTag

  def mount(_params, _session, socket) do
    IO.inspect(socket)

    recipe_changeset =
      Recipes.Recipe.changeset(
        %Recipes.Recipe{
          recipe_images: [%Recipes.RecipeImage{}],
          cooking_steps: [%Recipes.CookingStep{}],
          tags: [%Recipes.Tag{}],
          ingredients: [%Recipes.Ingredient{}]
        },
        %{}
      )

    tags = Recipes.get_tags()
    ingredients = Recipes.get_ingredients()
    recipes = Recipes.get_recipes_by_user!(1)

    socket =
      socket
      |> assign(
        form: to_form(recipe_changeset),
        tags: tags |> Enum.map(&%{label: &1.name, id: &1.id, selected: false}),
        ingredients: ingredients |> Enum.map(&%{label: &1.name, id: &1.id, selected: false}),
        recipes: recipes
      )
      |> allow_upload(:recipe_image, accept: ~w(.jpg .jpeg .png), max_entries: 10)
      |> allow_upload(:recipe_video, accept: ~w(.mp4), max_entries: 1)

    {:ok, socket}
  end

  def handle_info({:updated_tags, opts}, socket) do
    socket = assign(socket, tags: opts)
    {:noreply, socket}
  end

  def handle_info({:updated_ingredients, opts}, socket) do
    socket = assign(socket, ingredients: opts)
    {:noreply, socket}
  end

  def handle_event("edit-recipe", %{"id" => id}, socket) do
    id = String.to_integer(id)
    recipe = Recipes.get_recipe_with_preload(id)

    recipe_changeset =
      Recipes.Recipe.update_changeset(recipe, %{
        "tags" => recipe.tags,
        "ingredients" => recipe.ingredients
      })

    tags =
      Recipes.get_tags()
      |> merge_selection_list(recipe.tags)

    ingredients =
      Recipes.get_ingredients()
      |> merge_selection_list(recipe.ingredients)

    recipes = Recipes.get_recipes_by_user!(1)

    socket =
      socket
      |> assign(
        form: to_form(recipe_changeset),
        tags: tags,
        ingredients: ingredients,
        recipes: recipes
      )

    {:noreply, socket}
  end

  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    recipe_params = Map.put(recipe_params, "user_id", 1)

    tags =
      socket.assigns.tags
      |> Enum.reduce([], fn tag, acc ->
        if tag.selected, do: acc ++ [%{id: tag.id}], else: acc
      end)

    ingredients =
      socket.assigns.ingredients
      |> Enum.reduce([], fn ingredient, acc ->
        if ingredient.selected, do: acc ++ [%{id: ingredient.id}], else: acc
      end)

    recipe_params = Map.put(recipe_params, "ingredients", ingredients)
    recipe_params = Map.put(recipe_params, "tags", tags)

    changeset =
      Recipes.Recipe.validate_changeset(recipe_params)
      |> struct!(action: :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    recipe_params = Map.put(recipe_params, "user_id", 1)

    tags =
      socket.assigns.tags
      |> Enum.reduce([], fn tag, acc ->
        if tag.selected, do: acc ++ [%{id: tag.id}], else: acc
      end)

    ingredients =
      socket.assigns.ingredients
      |> Enum.reduce([], fn ingredient, acc ->
        if ingredient.selected, do: acc ++ [%{id: ingredient.id}], else: acc
      end)

    recipe_params = Map.put(recipe_params, "ingredients", ingredients)
    recipe_params = Map.put(recipe_params, "tags", tags)
    recipe_id = Map.get(recipe_params, "id")

    case Recipes.create_or_update_recipe(recipe_params, recipe_id) do
      {:ok, _recipe} ->
        recipe_changeset =
          Recipes.Recipe.changeset(
            %Recipes.Recipe{
              recipe_images: [%Recipes.RecipeImage{}],
              cooking_steps: [%Recipes.CookingStep{}],
              tags: [%Recipes.Tag{}],
              ingredients: [%Recipes.Ingredient{}]
            },
            %{}
          )

        socket = assign(socket, form: to_form(recipe_changeset))
        {:noreply, socket}

      {:error, changeset} ->
        IO.inspect(changeset, label: "Error Changeset")
        socket = assign(socket, form: to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("add-nested", param, socket) do
    {field_struct, field_name_atom} = get_new_nested_field(param["field-name"])

    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing = Ecto.Changeset.get_assoc(changeset, field_name_atom)

        changeset
        |> Ecto.Changeset.put_assoc(field_name_atom, existing ++ [field_struct])
        |> to_form()
      end)

    {:noreply, socket}
  end

  def handle_event("remove-nested", param, socket) do
    {field_struct, field_name_atom} = get_new_nested_field(param["field-name"])
    index = String.to_integer(param["value"])

    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing =
          Ecto.Changeset.get_assoc(changeset, field_name_atom)
          |> List.delete_at(index)
          |> on_empty_field_list(field_struct)

        changeset
        |> Ecto.Changeset.put_assoc(field_name_atom, existing)
        |> to_form()
      end)

    {:noreply, socket}
  end

  defp get_new_nested_field(field) do
    case field do
      "recipe_images" -> {%Recipes.RecipeImage{}, :recipe_images}
      "cooking_steps" -> {%Recipes.CookingStep{}, :cooking_steps}
      "tags" -> {%Recipes.Tag{}, :tags}
      "ingredients" -> {%Recipes.Ingredient{}, :ingredients}
      _ -> nil
    end
  end

  defp on_empty_field_list(field_list, field_struct) do
    if Enum.empty?(field_list), do: [field_struct], else: field_list
  end

  defp merge_selection_list(list, selected_list) do
    selected_ids = MapSet.new(selected_list, & &1.id)

    Enum.map(
      list,
      fn field ->
        field
        |> Map.put(:selected, MapSet.member?(selected_ids, field.id))
        |> Map.put(:label, field.name)
      end
    )
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
