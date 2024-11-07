defmodule KitchenRecipe.Repo.Migrations.AddRecipeImagesTable do
  use Ecto.Migration

  def change do
    create table(:recipe_images) do
      add :image_url, :string, null: false
      add :is_primary, :boolean, default: false
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_images, [:recipe_id])
  end
end
