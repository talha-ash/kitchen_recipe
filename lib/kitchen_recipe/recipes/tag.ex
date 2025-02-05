defmodule KitchenRecipe.Recipes.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias KitchenRecipe.Repo
  alias KitchenRecipe.Recipes.{Recipe, RecipeTag}

  schema "tags" do
    field :name, :string

    many_to_many(:recipes, Recipe, join_through: RecipeTag)

    timestamps(type: :utc_datetime)
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3, message: "must be at least 3 characters")
    |> unique_constraint(:name)
  end

  def new_assoc_changeset(%__MODULE__{} = tag, attrs) do
    tag
    |> cast(attrs, [:id])
  end

  def put_assoc_with_recipe(changeset, %{"tags" => tags}) do
    db_tags_id = Enum.map(tags, fn tag -> tag.id end)
    db_tags = Repo.all(from(t in __MODULE__, where: t.id in ^db_tags_id))

    changeset
    |> put_assoc(:tags, db_tags, required: true)
    |> validate_length(:tags, min: 1, message: "must have at least one tag")
  end

  def cast_assoc_with_recipe(changeset) do
    changeset
    |> cast_assoc(
      :tags,
      required: true,
      with: &new_assoc_changeset/2
    )
  end
end

# cast assoc will not work until you have preload the data
# if you want to add new tag and associate old tag too with recipe
# you need to preload the recipe first.Becuase recipe is not yet created
# and you can not preload the recipe in cast assoc.So we can only insert
# new tag and associate it with recipe.
#
# But we can use put assoc becuase it didn't required preloading the recipe
# and it will insert new tag and associate it with recipe and if tag have it
# then it simply create association between recipe and tag.
#
# Put Assoc need data from db for already exist data
# that we want to associate with parent changeset
#
#
# On Update When we have many to many assoc
#  and we using  put assoc it only update relation
# it can not update the data in the associated table
# like tags and posts M:M relation
