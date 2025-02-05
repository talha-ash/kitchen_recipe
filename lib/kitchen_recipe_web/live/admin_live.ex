defmodule KitchenRecipeWeb.AdminLive do
  use KitchenRecipeWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:upload_images, accept: ~w(.jpg .jpeg .png), max_entries: 2)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1>Upload Images In Upload Foder</h1>

      <form id="upload-form" phx-submit="save" phx-change="validate">
        <div class="flex flex-col gap-4 my-4">
          <.live_file_input upload={@uploads.upload_images} required={true} />
        </div>
        <button
          class="px-3 py-1.5 text-sm text-white bg-blue-500 rounded hover:bg-blue-600"
          type="submit"
        >
          Save
        </button>
        <%!-- <button
          type="button"
          class="px-3 py-1.5 text-sm text-gray-600 hover:text-gray-800"
          phx-click="cancel"
        >
          Cancel
        </button> --%>
      </form>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    IO.inspect("Validate", label: "Entry")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :upload_images, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :upload_images, fn %{path: path}, entry ->
        IO.inspect(entry, label: "Entry")

        dest =
          Path.join(
            "priv/static/uploads/",
            entry.client_name
          )

        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.mkdir_p(Path.dirname(dest))
        File.cp(path, dest)

        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(_), do: "Please Select Image"
end
