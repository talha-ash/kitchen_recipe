defmodule KitchenRecipe.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias KitchenRecipe.Recipes.{
    RecipeIngredient,
    Ingredient,
    RecipeCategory,
    Tag,
    RecipeTag,
    RecipeLike
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

    has_many :recipe_likes, RecipeLike

    many_to_many :ingredients, Ingredient,
      join_through: RecipeIngredient,
      on_replace: :delete

    many_to_many :tags, Tag, join_through: RecipeTag

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :image_url, :is_verified])
    |> validate_required([:name, :image_url])
    |> unique_constraint(:name)
  end
end
