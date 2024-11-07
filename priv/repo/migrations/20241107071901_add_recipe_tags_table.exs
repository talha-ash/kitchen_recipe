defmodule KitchenRecipe.Repo.Migrations.AddRecipeTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tags, [:name])

    create table(:recipe_tags) do
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_tags, [:recipe_id])
    create index(:recipe_tags, [:tag_id])
    create unique_index(:recipe_tags, [:recipe_id, :tag_id])
  end
end
