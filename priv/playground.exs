defmodule KitchenRecipe.Playground do
  alias KitchenRecipe.Recipes
  alias KitchenRecipe.Recipes.Recipe
  alias KitchenRecipe.Recipes.RecipeCategory
  alias KitchenRecipe.Recipes.Tag
  alias KitchenRecipe.Recipes.Ingredient
  alias KitchenRecipe.Recipes.RecipeIngredient
  alias KitchenRecipe.Recipes.RecipeTag
  alias KitchenRecipe.Recipes.RecipeLike
  alias KitchenRecipe.Accounts.User
  alias KitchenRecipe.Repo
  alias KitchenRecipe.Accounts.User
  alias KitchenRecipe.Recipes.SavedRecipe
  alias KitchenRecipe.Recipes.RecipeComment

  def unused_alias_sol() do
    list = [
      Recipe,
      RecipeCategory,
      Tag,
      Ingredient,
      RecipeIngredient,
      RecipeTag,
      RecipeLike,
      User,
      SavedRecipe,
      RecipeComment,
      Repo
    ]

    IO.inspect(Enum.empty?(list))
  end

  def playground() do
    recipe = %{
      id: 33,
      title: "New One",
      description: "i am new one",
      serve_time: 12,
      nutrition_facts: ["a", "b", "c"],
      is_published: true,
      deleted_at: DateTime.utc_now() |> DateTime.truncate(:second),
      video_url: "",
      video_title: "",
      user_id: 1,
      recipe_category_id: 1,
      recipe_images: [
        %{
          id: 1,
          image_url: "https://www.w3schools.com/w3css/lights.jpg",
          is_primary: true
        }
      ],
      tags: [
        %{
          "id" => 16,
          "name" => "fruit free",
          "description" => "Vegetarian"
        },
        %{
          "id" => 19,
          "name" => "fruit Fire",
          "description" => "Negitatrian"
        }
      ],
      ingredients: [
        %{
          "id" => 21,
          "name" => "beef",
          "description" => "Geef",
          "image_url" => "https://www.w3schools.com/w3css/img_lights.jpg",
          "is_verified" => true
        },
        %{
          "name" => "Mutton",
          "description" => "Yakhni",
          "image_url" => "https://www.w3schools.com/w3css/img_lights.jpg",
          "is_verified" => true
        }
      ],
      cooking_steps: [
        %{
          step_number: 1,
          instruction: "step 1",
          step_image_url: "https://www.w3schools.com/w3css/img_lights.jpg"
        }
      ]
    }

    # result = Repo.insert(recipe)
    # result = Repo.get(Recipe, 1)
    # result = Repo.preload(result, [:tags])
    result = Recipes.update_recipe(33, recipe)

    IO.inspect(result)
  end
end

KitchenRecipe.Playground.unused_alias_sol()
KitchenRecipe.Playground.playground()
