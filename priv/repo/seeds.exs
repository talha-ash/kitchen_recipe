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

admin_user = %User{
  email: "admin@admin.com",
  username: "admin",
  fullname: "Admin",
  role: :admin,
  hashed_password: Bcrypt.hash_pwd_salt("admin")
}

users = [
  %User{
    email: "nick@gmail.com",
    username: "nick",
    fullname: "Nick Evan",
    role: :client,
    hashed_password: Bcrypt.hash_pwd_salt("password12345")
  },
  %User{
    email: "john@gmail.com",
    username: "john",
    fullname: "John Doe",
    role: :client,
    hashed_password: Bcrypt.hash_pwd_salt("password12345")
  },
  %User{
    email: "johnny@gmail.com",
    username: "johnny",
    fullname: "Johnny Doe",
    role: :client,
    hashed_password: Bcrypt.hash_pwd_salt("password12345")
  },
  %User{
    email: "bill@gmail.com",
    username: "bill",
    fullname: "Bill Smith",
    role: :client,
    hashed_password: Bcrypt.hash_pwd_salt("password12345")
  }
]

{:ok, user} = Repo.insert(admin_user)
Enum.each(users, fn user -> Repo.insert(user) end)

categories = [
  %RecipeCategory{
    name: "Breakfast",
    image_url: "/uploads/chocolates-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Lunch",
    image_url: "/uploads/west-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Dinner",
    image_url: "/uploads/chocolates-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Snacks",
    image_url: "/uploads/west-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Dessert",
    image_url: "/uploads/chocolates-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Side Dish",
    image_url: "/uploads/west-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Beverage",
    image_url: "/uploads/chocolates-category.png",
    user_id: user.id
  },
  %RecipeCategory{
    name: "Vegetarian",
    image_url: "/uploads/west-category.png",
    user_id: user.id
  }
]

Enum.map(categories, fn category ->
  Repo.insert!(category)
end)

ingrediants = [
  %Ingredient{
    name: "Chicken",
    description: "chicken",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Beef",
    description: "beef",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Tofu",
    description: "tofu",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Egg",
    description: "egg",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Rice",
    description: "rice",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Beans",
    description: "beans",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Tomato",
    description: "tomato",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Lettuce",
    description: "lettuce",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Onion",
    description: "onion",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Carrot",
    description: "carrot",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Cucumber",
    description: "cucumber",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Potato",
    description: "potato",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Corn",
    description: "corn",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  },
  %Ingredient{
    name: "Peanut",
    description: "peanut",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true
  }
]

Enum.map(ingrediants, fn ingrediant ->
  Repo.insert!(ingrediant)
end)

tags = [
  %Tag{name: "vegetarian"},
  %Tag{name: "vegan"},
  %Tag{name: "gluten free"},
  %Tag{name: "low carb"},
  %Tag{name: "high carb"},
  %Tag{name: "keto"},
  %Tag{name: "paleo"},
  %Tag{name: "dairy free"},
  %Tag{name: "nut free"},
  %Tag{name: "soy free"},
  %Tag{name: "fish free"},
  %Tag{name: "egg free"},
  %Tag{name: "meat free"},
  %Tag{name: "seafood free"},
  %Tag{name: "shellfish free"},
  %Tag{name: "fruit free"},
  %Tag{name: "sugar free"},
  %Tag{name: "sweet free"},
  %Tag{name: "fat free"},
  %Tag{name: "cholesterol free"}
]

Enum.map(tags, fn tag ->
  Repo.insert!(tag)
end)
