defmodule KitchenRecipe.Recipes.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias KitchenRecipe.Repo
  alias KitchenRecipe.Recipes.{Recipe, RecipeIngredient}

  schema "ingredients" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    field :is_verified, :boolean, default: false

    many_to_many :recipes, Recipe,
      join_through: RecipeIngredient,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :description, :image_url, :is_verified])
    |> validate_required([:name, :image_url])
    |> unique_constraint(:name)
  end

  def new_changeset(%__MODULE__{} = ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :description, :image_url, :is_verified])
    |> validate_required([:name, :image_url])
    |> unique_constraint(:name)
  end

  def put_assoc_with_recipe(changeset, %{"ingredients" => ingredients}) do
    db_ingredients_id = Enum.map(ingredients, fn ingredient -> ingredient.id end)
    db_ingredients = Repo.all(from(t in __MODULE__, where: t.id in ^db_ingredients_id))

    changeset
    |> put_assoc(:ingredients, db_ingredients, required: true)
    |> validate_length(:ingredients, min: 1, message: "must have at least one ingredient")
  end

  # def cast_assoc_with_recipe(changeset, recipe_id) do
  #   changeset
  #   |> cast_assoc(
  #     :ingredients,
  #     required: true,
  #     with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
  #   )
  # end

  def cast_assoc_with_recipe(changeset) do
    changeset
    |> cast_assoc(
      :ingredients,
      required: true,
      with: &new_changeset/2
    )
  end
end
