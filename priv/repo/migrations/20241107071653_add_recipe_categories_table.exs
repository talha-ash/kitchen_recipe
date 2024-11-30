defmodule KitchenRecipe.Repo.Migrations.AddRecipeCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:recipe_categories) do
      add :name, :string, null: false
      add :image_url, :string, null: false
      add :description, :text
      add :user_id, references(:users, on_delete: :nilify_all), null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:recipe_categories, [:name])
  end
end
