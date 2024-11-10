# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     KitchenRecipe.Repo.insert!(%KitchenRecipe.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias KitchenRecipe.Repo
alias KitchenRecipe.Accounts.User
alias KitchenRecipe.Recipes.{RecipeCategory, Ingredient, Tag}

user = %User{
  email: "admin@admin.com",
  username: "admin",
  fullname: "Admin",
  role: :admin,
  hashed_password: Bcrypt.hash_pwd_salt("admin")
}

{:ok, user} = Repo.insert(user)

categories = [
  %RecipeCategory{name: "Breakfast", description: "Breakfast", user_id: user.id},
  %RecipeCategory{name: "Lunch", description: "Lunch", user_id: user.id},
  %RecipeCategory{name: "Dinner", description: "Dinner", user_id: user.id},
  %RecipeCategory{name: "Snacks", description: "Snacks", user_id: user.id},
  %RecipeCategory{name: "Dessert", description: "Dessert", user_id: user.id},
  %RecipeCategory{name: "Side Dish", description: "Side Dish", user_id: user.id},
  %RecipeCategory{name: "Beverage", description: "Beverage", user_id: user.id},
  %RecipeCategory{name: "Vegetarian", description: "Vegetarian", user_id: user.id}
]

Enum.map(categories, fn category ->
  Repo.insert!(category)
end)

ingrediants = [
  %Ingredient{
    name: "Chicken",
    description: "chicken",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Beef",
    description: "beef",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Pork",
    description: "pork",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Tofu",
    description: "tofu",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Egg",
    description: "egg",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Rice",
    description: "rice",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Beans",
    description: "beans",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Tomato",
    description: "tomato",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Lettuce",
    description: "lettuce",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Onion",
    description: "onion",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Carrot",
    description: "carrot",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Cucumber",
    description: "cucumber",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Potato",
    description: "potato",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Corn",
    description: "corn",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  },
  %Ingredient{
    name: "Peanut",
    description: "peanut",
    image_url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/chicken-690272_960_720.jpg",
    is_verified: true
  }
]

Enum.map(ingrediants, fn ingrediant ->
  Repo.insert!(ingrediant)
end)

tags = [
  %Tag{name: "vegetarian", description: "Vegetarian"},
  %Tag{name: "vegan", description: "Vegan"},
  %Tag{name: "gluten free", description: "Gluten Free"},
  %Tag{name: "low carb", description: "Low Carb"},
  %Tag{name: "high carb", description: "High Carb"},
  %Tag{name: "keto", description: "Keto"},
  %Tag{name: "paleo", description: "Paleo"},
  %Tag{name: "dairy free", description: "Dairy Free"},
  %Tag{name: "nut free", description: "Nut Free"},
  %Tag{name: "soy free", description: "Soy Free"},
  %Tag{name: "fish free", description: "Fish Free"},
  %Tag{name: "egg free", description: "Egg Free"},
  %Tag{name: "meat free", description: "Meat Free"},
  %Tag{name: "seafood free", description: "Seafood Free"},
  %Tag{name: "shellfish free", description: "Shellfish Free"},
  %Tag{name: "fruit free", description: "Fruit Free"},
  %Tag{name: "sugar free", description: "Sugar Free"},
  %Tag{name: "sweet free", description: "Sweet Free"},
  %Tag{name: "fat free", description: "Fat Free"},
  %Tag{name: "cholesterol free", description: "Cholesterol Free"}
]

Enum.map(tags, fn tag ->
  Repo.insert!(tag)
end)
