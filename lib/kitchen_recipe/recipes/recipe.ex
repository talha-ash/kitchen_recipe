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
    field :nutrition_facts, :string
    field :is_published, :boolean
    field :deleted_at, :utc_datetime
    field :video_url, :string
    field :video_title, :string

    # virtual fields for query
    field(:likes_count, :string, virtual: true)
    field(:comments_count, :string, virtual: true)
    field(:like_by_current_user, :string, virtual: true)

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

  @recipe_cast_fields ~w(title serve_time description nutrition_facts video_url video_title user_id recipe_category_id)a
  @recipe_required_fields ~w(title serve_time nutrition_facts video_url video_title user_id recipe_category_id)a

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, @recipe_cast_fields)
    |> validate_required(@recipe_required_fields)
    |> cast_assoc(:recipe_images)
  end

  def update_changeset(recipe, attrs) do
    recipe
    |> cast(attrs, @recipe_cast_fields)
    |> validate_required(@recipe_required_fields)
    |> validate_length(:nutrition_facts, min: 1)
    |> Tag.put_assoc_with_recipe(attrs)
    |> Ingredient.put_assoc_with_recipe(attrs)
    |> CookingStep.cast_assoc_with_recipe()
    |> RecipeImage.cast_assoc_with_recipe()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @recipe_cast_fields)
    |> validate_required(@recipe_required_fields)
    |> Tag.put_assoc_with_recipe(attrs)
    |> Ingredient.put_assoc_with_recipe(attrs)
    |> CookingStep.cast_assoc_with_recipe()
    |> RecipeImage.cast_assoc_with_recipe()
  end

  def validate_changeset(recipe, attrs) do
    recipe
    |> cast(attrs, @recipe_cast_fields)
    |> validate_required(@recipe_required_fields)
    |> CookingStep.cast_assoc_with_recipe()
    |> RecipeImage.cast_assoc_with_recipe()
  end

  def validate_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @recipe_cast_fields)
    |> validate_required(@recipe_required_fields)
    |> validate_length(:nutrition_facts, min: 1)
    |> CookingStep.cast_assoc_with_recipe()
    |> RecipeImage.cast_assoc_with_recipe()
  end
end
