defmodule KitchenRecipeWeb.Components.PeopleSuggestion do
  use KitchenRecipeWeb, :live_component
  alias KitchenRecipe.Accounts

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    current_user_id = assigns.current_user_id
    top_users = Accounts.get_top_users_by_recipe_followers(current_user_id, 3)
    {:ok, assign(socket, top_users: top_users)}
  end

  def render(assigns) do
    ~H"""
    <section class="suggested-articles-holder">
      <div class="suggestions-header">
        <h4>People you might want to follow</h4>
        <h4 class="green">See all Suggestion</h4>
      </div>
      <div class="main-blogs-holder">
        <div :for={user <- @top_users} class="blog-card-wrapper">
          <div class="blog-card-content">
            <div class="blog-img-wrapper">
              <img src="/assets/images/blog-img-1.png" alt="" />
            </div>
            <div class="blog-details">
              <div class="avatar-img-wrapper">
                <img src={user.avatar_url} alt="" />
              </div>
              <h4><%= user.fullname || user.username %></h4>
              <div class="blog-footer">
                <div class="group-2">
                  <strong><%= user.recipes_count %></strong>
                  <span>recipes</span>
                </div>
                <div class="group-2">
                  <strong><%= user.followers_count %></strong>
                  <span>followers</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
