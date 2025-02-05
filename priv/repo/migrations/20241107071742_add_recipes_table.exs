defmodule KitchenRecipe.Repo.Migrations.AddRecipesTable do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :title, :string, null: false
      add :description, :text
      add :serve_time, :integer
      add :nutrition_facts, :string
      add :is_published, :boolean, default: false
      add :deleted_at, :utc_datetime
      add(:video_url, :string)
      add(:video_title, :string)
      add :user_id, references(:users, on_delete: :restrict), null: false
      add :recipe_category_id, references(:recipe_categories, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:recipes, [:user_id])
    create index(:recipes, [:recipe_category_id])
  end
end
