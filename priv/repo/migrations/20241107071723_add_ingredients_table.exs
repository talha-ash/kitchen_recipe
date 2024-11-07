defmodule KitchenRecipe.Repo.Migrations.AddIngredientsTable do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :string, null: false
      add :description, :text
      add :image_url, :string
      add :is_verified, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:ingredients, [:name])
  end
end
