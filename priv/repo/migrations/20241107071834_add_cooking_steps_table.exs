defmodule KitchenRecipe.Repo.Migrations.AddCookingStepsTable do
  use Ecto.Migration

  def change do
    create table(:cooking_steps) do
      add :step_number, :integer, null: false
      add :instruction, :text, null: false
      add :step_image_url, :string
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:cooking_steps, [:recipe_id])
    create unique_index(:cooking_steps, [:recipe_id, :step_number])
  end
end
