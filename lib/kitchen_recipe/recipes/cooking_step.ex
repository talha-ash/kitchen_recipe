defmodule KitchenRecipe.Recipes.CookingStep do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Recipes.Recipe

  schema "cooking_steps" do
    field :step_number, :integer
    field :instruction, :string
    field :step_image_url, :string

    belongs_to :recipe, Recipe

    timestamps(type: :utc_datetime)
  end

  def changeset(cooking_step, attrs) do
    cooking_step
    |> cast(attrs, [:step_number, :instruction, :step_image_url, :recipe_id])
    |> validate_required([:step_number, :instruction, :recipe_id])
    |> unique_constraint([:recipe_id, :step_number])
  end
end
