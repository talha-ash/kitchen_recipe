defmodule KitchenRecipeWeb.Components.Recipe.CreateIngredient do
  use KitchenRecipeWeb, :live_component
  alias KitchenRecipe.Recipes.Ingredient
  alias KitchenRecipe.Repo
  alias Support.Uploads

  def mount(socket) do
    socket =
      socket
      |> assign(mode: :button)
      |> allow_upload(:image_url, accept: ~w(.jpg .jpeg .png), max_entries: 1)

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
          <.live_file_input upload={@uploads.image_url} required={true} />
          <%= for entry <- @uploads.image_url.entries do %>
            <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
            <%= for err <- upload_errors(@uploads.image_url, entry) do %>
              <p class="alert alert-danger"><%= error_to_string(err) %></p>
            <% end %>
          <% end %>

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
        phx-click="add-ingredient"
        phx-target={@myself}
      >
        Add Ingredient
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

    image_url =
      Uploads.upload_files(socket, :image_url, "#{ingredient_params["name"]}")
      |> Enum.at(0)
      |> String.replace("priv/static", "")

    ingredient_params = Map.put(ingredient_params, "image_url", image_url)
    ingredient_changeset = Ingredient.changeset(%Ingredient{}, ingredient_params)

    case Repo.insert(ingredient_changeset) do
      {:ok, _ingredient} ->
        socket = socket |> assign(form: nil, mode: :button)
        send(self(), :update_ingredient_list)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("add-ingredient", _params, socket) do
    mode = if(socket.assigns.mode == :button, do: :input, else: :button)

    ingredient_changeset = Ingredient.changeset(%Ingredient{}, %{})
    {:noreply, assign(socket, mode: mode, form: to_form(ingredient_changeset))}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, mode: :button, form: nil)}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(_), do: "Please Select Ingredient Image"
end
