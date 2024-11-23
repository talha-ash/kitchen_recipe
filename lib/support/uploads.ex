defmodule Support.Uploads do
  def upload_files(socket, field, upload_path) do
    uploaded_files =
      Phoenix.LiveView.consume_uploaded_entries(socket, field, fn %{path: path}, _entry ->
        dest =
          Path.join(
            Application.app_dir(:kitchen_recipe, "priv/static/uploads/#{upload_path}/"),
            Path.basename(path)
          )

        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.mkdir_p(Path.dirname(dest))
        File.cp(path, dest)
        {:ok, "/uploads/#{upload_path}/#{Path.basename(dest)}"}
      end)

    uploaded_files
  end
end
