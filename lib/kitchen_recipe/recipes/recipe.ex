defmodule KitchenRecipe.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query
  alias KitchenRecipe.Recipes.CookingStep

  alias KitchenRecipe.Recipes.{
    RecipeIngredient,
    Ingredient,
    RecipeCategory,
    Tag,
    RecipeTag,
    RecipeLike,
    RecipeImage,
    CookingStep
  }

  alias KitchenRecipe.Accounts.User

  schema "recipes" do
    field :title, :string
    field :description, :string
    field :serve_time, :integer
    field :nutrition_facts, {:array, :string}
    field :is_published, :boolean
    field :deleted_at, :utc_datetime
    field :video_url, :string
    field :video_title, :string

    belongs_to :user, User
    belongs_to :recipe_category, RecipeCategory

    has_many :recipe_likes, RecipeLike, on_replace: :delete
    has_many :recipe_images, RecipeImage, on_replace: :delete
    has_many :cooking_steps, CookingStep, on_replace: :delete

    # has_many :recipe_tags, RecipeTag
    # has_many :tags, through: [:recipe_tags, :tag]

    many_to_many :ingredients, Ingredient,
      join_through: RecipeIngredient,
      on_replace: :delete

    many_to_many :tags, Tag, join_through: RecipeTag, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :serve_time, :nutrition_facts, :user_id, :recipe_category_id])
    |> validate_required([:title, :serve_time, :nutrition_facts, :user_id, :recipe_category_id])
    |> cast_assoc(:recipe_images)
  end

  def associated_changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :serve_time, :nutrition_facts, :user_id, :recipe_category_id])
    |> Tag.put_assoc_with_recipe(attrs)
    |> Ingredient.put_assoc_with_recipe(attrs)
    |> CookingStep.cast_assoc_with_recipe()
    |> RecipeImage.cast_assoc_with_recipe()
  end

  def associated_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:title, :serve_time, :nutrition_facts, :user_id, :recipe_category_id])
    |> Tag.put_assoc_with_recipe(attrs)
    |> Ingredient.put_assoc_with_recipe(attrs)
    |> CookingStep.cast_assoc_with_recipe()
    |> RecipeImage.cast_assoc_with_recipe()
  end
end
