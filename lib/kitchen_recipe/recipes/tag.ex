defmodule KitchenRecipe.Recipes.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias KitchenRecipe.Repo
  alias KitchenRecipe.Recipes.{Recipe, RecipeTag}

  schema "tags" do
    field :name, :string
    field :description, :string

    many_to_many(:recipes, Recipe, join_through: RecipeTag)

    timestamps(type: :utc_datetime)
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def new_changeset(%__MODULE__{} = tag, attrs, %{recipe_id: recipe_id}) do
    Map.put(tag, :scope_id, recipe_id)
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def new_changeset(%__MODULE__{} = tag, attrs) do
    tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def put_assoc_with_recipe(changeset, %{"tags" => tags}) do
    tags = Map.values(tags)
    {db_tags, new_tags} = Enum.split_with(tags, fn tag -> tag["id"] end)

    new_tags =
      Enum.map(new_tags, fn tag ->
        new_changeset(%__MODULE__{}, tag)
      end)

    db_tags_id = Enum.map(db_tags, fn tag -> tag["id"] end)
    db_tags = Repo.all(from(t in __MODULE__, where: t.id in ^db_tags_id))

    changeset
    |> put_assoc(:tags, db_tags ++ new_tags)
  end

  def cast_assoc_with_recipe(changeset, recipe_id) do
    changeset
    |> cast_assoc(
      :tags,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end

  def cast_assoc_with_recipe(changeset) do
    changeset
    |> cast_assoc(
      :tags,
      required: true,
      with: {__MODULE__, :new_changeset, []}
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
