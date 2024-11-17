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

  def new_changeset(%__MODULE__{} = cooking_step, attrs) do
    cooking_step
    |> cast(attrs, [:step_number, :instruction, :step_image_url])
    |> validate_required([:step_number, :instruction])
    |> unique_constraint([:recipe_id, :step_number],
      error_key: :step_number,
      message: "Step number already exists for this recipe"
    )
  end

  def cast_assoc_with_recipe(changeset) do
    changeset
    |> cast_assoc(
      :cooking_steps,
      required: true,
      with: &new_changeset/2
    )
  end
end
