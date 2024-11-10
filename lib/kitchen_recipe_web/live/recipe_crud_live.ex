defmodule KitchenRecipeWeb.RecipeCrudLive do
  use KitchenRecipeWeb, :live_view
  alias KitchenRecipe.Recipes
  alias KitchenRecipe.Recipes

  def mount(_params, _session, socket) do
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
    {:ok, socket}
  end

  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    IO.inspect(recipe_params, label: "Recipe Params In Validate")
    recipe_params = Map.put(recipe_params, "user_id", 1)

    changeset =
      Recipes.Recipe.associated_changeset(recipe_params)
      |> struct!(action: :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    IO.inspect(recipe_params, label: "Recipe Params In Save")
    recipe_params = Map.put(recipe_params, "user_id", 1)

    case Recipes.create_recipe(recipe_params) do
      {:ok, recipe} ->
        IO.inspect(recipe, label: "Recipe Created")

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
    {field_struct, field_name_atom} = get_new_nestedfield(param["field-name"])

    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing = Ecto.Changeset.get_assoc(changeset, field_name_atom)

        IO.inspect(existing, label: "Existing")

        changeset
        |> Ecto.Changeset.put_assoc(field_name_atom, existing ++ [field_struct])
        |> to_form()
      end)

    {:noreply, socket}
  end

  def handle_event("remove-nested", param, socket) do
    {field_struct, field_name_atom} = get_new_nestedfield(param["field-name"])
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

  defp get_new_nestedfield(field) do
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
end
