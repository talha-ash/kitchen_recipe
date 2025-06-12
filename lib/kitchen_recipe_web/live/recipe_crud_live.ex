defmodule KitchenRecipeWeb.RecipeCrudLive do
  use KitchenRecipeWeb, :live_view
  import Support.Uploads, only: [upload_files: 2, put_upload_urls: 3]
  alias KitchenRecipe.Recipes
  alias KitchenRecipe.Recipes
  alias KitchenRecipeWeb.Recipe.{CreateTag, CreateIngredient}

  def mount(params, _session, socket) do
    live_action = socket.assigns.live_action

    case live_action do
      :new ->
        socket = prepare_page_data(:new, socket)
        {:ok, socket}

      :edit ->
        id = Map.get(params, "id") |> Integer.parse()
        socket = prepare_page_data(:edit, id, socket)
        {:ok, socket}
    end
  end

  def handle_info({:updated_tags, opts}, socket) do
    socket = assign(socket, tags: opts)
    {:noreply, socket}
  end

  def handle_info(:update_tag_list, socket) do
    tags = Recipes.get_tags() |> Enum.map(&%{label: &1.name, id: &1.id, selected: false})
    socket = assign(socket, tags: tags)
    {:noreply, socket}
  end

  def handle_info(:update_ingredient_list, socket) do
    ingredients =
      Recipes.get_ingredients() |> Enum.map(&%{label: &1.name, id: &1.id, selected: false})

    socket = assign(socket, ingredients: ingredients)
    {:noreply, socket}
  end

  def handle_info({:updated_ingredients, opts}, socket) do
    socket = assign(socket, ingredients: opts)
    {:noreply, socket}
  end

  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    current_user = socket.assigns.current_user

    tags = selected_ids_map(socket.assigns.tags)

    ingredients = selected_ids_map(socket.assigns.ingredients)

    recipe_params =
      recipe_params
      |> Map.put("ingredients", ingredients)
      |> Map.put("user_id", current_user.id)
      |> Map.put("tags", tags)

    changeset =
      Recipes.Recipe.validate_changeset(recipe_params)
      |> struct!(action: :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    recipe_params = set_recipe_params(socket, recipe_params)

    save_recipe(socket, recipe_params)
  end

  def handle_event("cancel-upload", %{"ref" => ref, "field-name" => "recipe_images"}, socket) do
    {:noreply, cancel_upload(socket, :recipe_images, ref)}
  end

  def handle_event(
        "cancel-upload",
        %{"ref" => ref, "field-name" => "recipe_primary_image"},
        socket
      ) do
    {:noreply, cancel_upload(socket, :recipe_primary_image, ref)}
  end

  def handle_event("cancel-upload", %{"ref" => ref, "field-name" => "recipe_video"}, socket) do
    {:noreply, cancel_upload(socket, :recipe_video, ref)}
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

  def handle_event("remove-recipe-image", %{"id" => id}, socket) do
    id = String.to_integer(id)
    saved_images = Enum.map(socket.assigns.saved_images, &toggle_image(&1, id))

    {:noreply, assign(socket, saved_images: saved_images)}
  end

  def handle_event("add-recipe-image", %{"id" => id}, socket) do
    id = String.to_integer(id)
    saved_images = Enum.map(socket.assigns.saved_images, &toggle_image(&1, id))
    {:noreply, assign(socket, saved_images: saved_images)}
  end

  defp save_recipe(socket, recipe_params) do
    live_action = socket.assigns.live_action
    current_user = socket.assigns.current_user
    recipe_id = Map.get(recipe_params, "id")

    case Recipes.create_or_update_recipe(recipe_params, recipe_id) do
      {:ok, recipe} ->
        flash_message = if live_action == :new, do: "Recipe Created", else: "Recipe Updated"
        navigate_to = if live_action == :new, do: ~p"/feed", else: ~p"/recipes/#{recipe.id}"

        video_path = "#{current_user.id}/recipes/videos"
        images_path = "#{current_user.id}/recipes/images"

        upload_files(socket,
          recipe_video: video_path,
          recipe_primary_image: images_path,
          recipe_images: images_path
        )

        socket =
          socket
          |> assign(form: nil)
          |> put_flash(:info, flash_message)
          |> push_navigate(to: navigate_to)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp set_recipe_params(socket, recipe_params) do
    current_user = socket.assigns.current_user
    saved_images = socket.assigns.saved_images
    saved_video_url = socket.assigns.saved_video_url

    video_path = "#{current_user.id}/recipes/videos"
    images_path = "#{current_user.id}/recipes/images"

    video_url = put_upload_urls(socket, :recipe_video, video_path) |> Enum.at(0)
    primary_image_url = put_upload_urls(socket, :recipe_primary_image, images_path) |> Enum.at(0)
    images_urls = put_upload_urls(socket, :recipe_images, images_path)
    all_recipe_images = recipe_images_from_upload(primary_image_url, images_urls, saved_images)

    recipe_params
    |> Map.put("ingredients", selected_ids_map(socket.assigns.ingredients))
    |> Map.put("tags", selected_ids_map(socket.assigns.tags))
    |> Map.put("video_url", video_url || saved_video_url)
    |> Map.put("recipe_images", all_recipe_images)
    |> Map.put("user_id", current_user.id)
  end

  defp toggle_image(%{id: id} = image, target_id) when id == target_id do
    %{image | del: !image.del}
  end

  defp toggle_image(image, _id), do: image

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

  defp recipe_images_from_upload(nil, other_images, saved_images) do
    old_images = Enum.filter(saved_images, &(not &1.del))

    Enum.map(other_images, fn image -> %{image_url: image, is_primary: false} end)
    |> (fn images -> images ++ old_images end).()
  end

  defp recipe_images_from_upload(primary_image, other_images, saved_images) do
    old_images = Enum.filter(saved_images, &(not &1.del))

    Enum.map(other_images, fn image -> %{image_url: image, is_primary: false} end)
    |> (fn images -> [%{image_url: primary_image, is_primary: true}] ++ images ++ old_images end).()
  end

  defp prepare_page_data(:new, socket) do
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

    socket
    |> add_allow_uploads()
    |> assign(
      form: to_form(recipe_changeset),
      tags: tags |> Enum.map(&%{label: &1.name, id: &1.id, selected: false}),
      ingredients: ingredients |> Enum.map(&%{label: &1.name, id: &1.id, selected: false}),
      saved_images: [],
      saved_video_url: nil
    )
  end

  defp prepare_page_data(:edit, :error, socket) do
    socket
    |> put_flash(:error, "Recipe Not Found")
    |> push_navigate(to: "/", replace: true)
  end

  defp prepare_page_data(:edit, {id, _}, socket) do
    recipe = Recipes.get_recipe_with_preload(id)
    user_id = socket.assigns.current_user.id

    case recipe do
      nil ->
        socket
        |> put_flash(:error, "Recipe Not Found")
        |> push_navigate(to: "/", replace: true)

      _ ->
        if user_id != recipe.user_id do
          socket
          |> put_flash(:error, "Not Allowed")
          |> push_navigate(to: "/", replace: true)
        else
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

          socket
          |> add_allow_uploads()
          |> assign(
            form: to_form(recipe_changeset),
            tags: tags,
            ingredients: ingredients,
            saved_video_url: recipe.video_url,
            saved_video_title: recipe.video_title,
            saved_images:
              recipe.recipe_images
              |> Enum.map(
                &%{id: &1.id, image_url: &1.image_url, is_primary: &1.is_primary, del: false}
              )
          )
        end
    end
  end

  defp add_allow_uploads(socket) do
    socket
    |> allow_upload(:recipe_images, accept: ~w(.jpg .jpeg .png), max_entries: 10)
    |> allow_upload(:recipe_primary_image, accept: ~w(.jpg .jpeg .png), max_entries: 1)
    |> allow_upload(:recipe_video, accept: ~w(.mp4), max_entries: 1)
  end

  defp selected_ids_map(list) do
    Enum.reduce(list, [], fn item, acc ->
      if item.selected, do: acc ++ [%{id: item.id}], else: acc
    end)
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
