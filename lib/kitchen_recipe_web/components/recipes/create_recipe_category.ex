defmodule KitchenRecipeWeb.Recipe.CreateRecipeCategory do
  use KitchenRecipeWeb, :live_component
  alias KitchenRecipe.Recipes.RecipeCategory
  alias KitchenRecipe.Repo

  def mount(socket) do
    recipe_category_changeset = RecipeCategory.changeset(%RecipeCategory{}, %{})

    socket =
      socket
      |> assign(form: to_form(recipe_category_changeset))
      |> allow_upload(:image_url, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="relative" id={@id} data-form-success={hide_modal("add-category")}>
      <h1 class="text-2xl font-bold">Add New Category</h1>
      <div class="flex gap-2 items-center">
        <.simple_form
          id="recipe-category-form"
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
            phx-click={hide_modal("add-category")}
            phx-target={@myself}
          >
            Cancel
          </button>
        </.simple_form>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"recipe_category" => recipe_category_params}, socket) do
    current_user_id = socket.assigns.current_user_id
    recipe_category_params = Map.put(recipe_category_params, "user_id", current_user_id)

    recipe_category_changeset =
      RecipeCategory.changeset(%RecipeCategory{}, recipe_category_params)

    {:noreply, assign(socket, form: to_form(recipe_category_changeset))}
  end

  def handle_event("save", %{"recipe_category" => recipe_category_params}, socket) do
    current_user_id = socket.assigns.current_user_id
    recipe_category_params = Map.put(recipe_category_params, "user_id", current_user_id)

    image_url = upload_image(socket, recipe_category_params["name"])
    recipe_category_params = Map.put(recipe_category_params, "image_url", image_url)

    recipe_category_changeset =
      RecipeCategory.changeset(%RecipeCategory{}, recipe_category_params)

    case Repo.insert(recipe_category_changeset) do
      {:ok, _recipe_category} ->
        socket =
          push_event(socket, "js-exec", %{to: "#add-category-form", attr: "data-form-success"})

        socket = socket |> assign(form: nil)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, mode: :button, form: nil)}
  end

  def upload_image(socket, ingredient_name) do
    uploaded_files =
      consume_uploaded_entries(socket, :image_url, fn %{path: path}, _entry ->
        dest =
          Path.join(
            Application.app_dir(:kitchen_recipe, "priv/static/uploads"),
            Path.basename(path)
          )

        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{ingredient_name}/#{Path.basename(dest)}"}
      end)

    Enum.at(uploaded_files, 0)
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(_), do: "Please Select Ingredient Image"
end
