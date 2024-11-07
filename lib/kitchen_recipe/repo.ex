defmodule KitchenRecipe.Repo do
  use Ecto.Repo,
    otp_app: :kitchen_recipe,
    adapter: Ecto.Adapters.Postgres
end
