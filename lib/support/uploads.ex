defmodule Support.Uploads do
  def upload_files(socket, fields) when is_list(fields) do
    for {field, upload_path} <- fields do
      consume_uploads(socket, field, upload_path)
    end
  end

  def upload_files(socket, field, upload_path) do
    consume_uploads(socket, field, upload_path)
  end

  def put_upload_urls(socket, field, upload_path) do
    {completed, []} = Phoenix.LiveView.uploaded_entries(socket, field)

    for entry <- completed do
      Phoenix.VerifiedRoutes.static_path(
        socket,
        "/uploads/#{upload_path}/#{entry.uuid}.#{ext(entry)}"
      )
    end
  end

  defp consume_uploads(socket, field, upload_path) do
    Phoenix.LiveView.consume_uploaded_entries(socket, field, fn %{path: path}, entry ->
      dest =
        Path.join(
          "priv/static/uploads/#{upload_path}/",
          "#{entry.uuid}.#{ext(entry)}"
        )

      # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
      File.mkdir_p(Path.dirname(dest))
      File.cp(path, dest)
      {:ok, dest}
    end)
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end
end
