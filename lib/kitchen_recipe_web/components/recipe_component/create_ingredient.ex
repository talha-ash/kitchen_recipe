defmodule KitchenRecipeWeb.RecipeComponent.CreateIngredient do
  use KitchenRecipeWeb, :live_component
  alias KitchenRecipe.Recipes.Ingredient
  alias KitchenRecipe.Repo

  def mount(socket) do
    socket = assign(socket, mode: :button)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="relative">
      <div :if={@mode == :input} class="flex gap-2 items-center">
        <.simple_form
          id="ingredient-form"
          for={@form}
          phx-submit="save"
          phx-change="validate"
          phx-target={@myself}
        >
          <.input
            field={@form[:name]}
            placeholder="Name"
            type="text"
            class="border rounded px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            class="px-3 py-1.5 text-sm text-white bg-blue-500 rounded hover:bg-blue-600"
            type="submit"
          >
            Save
          </button>
          <button
            type="button"
            class="px-3 py-1.5 text-sm text-gray-600 hover:text-gray-800"
            phx-click="cancel"
            phx-target={@myself}
          >
            Cancel
          </button>
        </.simple_form>
      </div>
      <button
        :if={@mode == :button}
        class="px-3 py-1.5 text-sm text-white bg-blue-500 rounded hover:bg-blue-600"
        phx-click="add-item"
        phx-target={@myself}
      >
        Add Item
      </button>
    </div>
    """
  end

  def handle_event("validate", %{"ingredient" => ingredient_params}, socket) do
    ingredient_params = Map.put(ingredient_params, "user_id", 1)
    ingredient_changeset = Ingredient.changeset(%Ingredient{}, ingredient_params)
    {:noreply, assign(socket, form: to_form(ingredient_changeset))}
  end

  def handle_event("save", %{"ingredient" => ingredient_params}, socket) do
    ingredient_params = Map.put(ingredient_params, "user_id", 1)

    ingredient_changeset = Ingredient.changeset(%Ingredient{}, ingredient_params)

    case Repo.insert(ingredient_changeset) do
      {:ok, _ingredient} ->
        socket = socket |> assign(form: nil, mode: :button)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("add-item", _params, socket) do
    mode = if(socket.assigns.mode == :button, do: :input, else: :button)

    ingredient_changeset = Ingredient.changeset(%Ingredient{}, %{})
    {:noreply, assign(socket, mode: mode, form: to_form(ingredient_changeset))}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, mode: :button, form: nil)}
  end
end
