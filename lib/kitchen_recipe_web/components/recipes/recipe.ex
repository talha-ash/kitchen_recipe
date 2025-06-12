defmodule KitchenRecipeWeb.Recipes.Recipe do
  use KitchenRecipeWeb, :live_component
  import KitchenRecipeWeb.Recipe.Components, only: [recipe_comments: 1]
  alias KitchenRecipe.{Recipes, Repo}
  alias KitchenRecipe.Recipes.RecipeComment

  def mount(socket) do
    socket =
      assign(
        socket,
        show_comments: false,
        add_comment: false,
        comment_form: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <article class="blog-1">
      <div class="article-img-1">
        <img class="h-[240px] object-cover" src={@recipe.recipe_images} alt="" />
        <div class="article-header">
          <div class="entry-meta">
            <div class="author-img-wrapper">
              <.user_avatar user={@recipe.user} />
            </div>
            <div class="entry-content">
              <.link href={~p"/profile/#{@recipe.user.id}"}>
                <strong class="author-name cursor-pointer">
                  <.user_name user={@recipe.user} />
                </strong>
              </.link>
              <%!-- <span class="entry-date">2h ago</span> --%>
            </div>
          </div>
        </div>
      </div>
      <div class="article-content mt-14">
        <div class="content-header">
          <.link href={~p"/recipes/#{@recipe.id}"}>
            <h3 class="article-heading cursor-pointer"><%= @recipe.title %></h3>
          </.link>
          <span
            phx-click="like-recipe"
            phx-throttle="1000"
            phx-value-id={@recipe.id}
            class={[
              "transition-all",
              @recipe.like_by_current_user == 1 && "recipe-heart-bounce-in",
              @recipe.like_by_current_user == 0 && "recipe-heart-bounce-out"
            ]}
          >
            <svg
              width="25"
              height="24"
              viewBox="0 0 25 24"
              fill={if @recipe.like_by_current_user > 0, do: "red", else: "none"}
              xmlns="http://www.w3.org/2000/svg"
            >
              <g opacity="0.5">
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M12.543 19C12.543 19 5.99653 12.9471 4.8618 10.5011C3.72707 8.05507 5.79565 5 8.18113 5C10.5666 5 12.543 7.34142 12.543 7.34142C12.543 7.34142 14.7263 5 16.8347 5C18.943 5 21.4915 7.56199 20.1856 10.5011C18.8798 13.4402 12.543 19 12.543 19Z"
                  stroke="#363837"
                  stroke-linecap="square"
                />
              </g>
            </svg>
          </span>
        </div>
        <p class="article-description"><%= @recipe.description %></p>
        <div class="article-footer">
          <div class="article-rating">
            <button class="font-styling">
              <%= @recipe.likes_count %> Likes
            </button>
            <div class="dot"></div>
            <button phx-click="toggle-comments" phx-target={@myself} class="font-styling">
              <%= @recipe.comments_count %> Comments
            </button>
          </div>
        </div>
      </div>

      <.recipe_comments
        :if={@show_comments}
        comments={@comments}
        add_comment={@add_comment}
        comment_form={@comment_form}
        myself={@myself}
      />
      <%= render_slot(@inner_block) %>
    </article>
    """
  end

  def handle_event("toggle-comments", _params, socket) do
    show_comment = !socket.assigns.show_comments

    comments =
      if show_comment, do: Recipes.get_recipe_comments(socket.assigns.recipe.id), else: []

    {:noreply, assign(socket, show_comments: show_comment, comments: comments)}
  end

  def handle_event("toggle-add-comments", _params, socket) do
    add_comment = !socket.assigns.add_comment

    comment_changeset =
      if add_comment do
        to_form(RecipeComment.changeset(%RecipeComment{}, %{}))
      else
        nil
      end

    {:noreply, assign(socket, add_comment: add_comment, comment_form: comment_changeset)}
  end

  def handle_event("validate", %{"recipe_comment" => recipe_comment}, socket) do
    comment_changeset = RecipeComment.changeset(%RecipeComment{}, recipe_comment)
    {:noreply, assign(socket, form: to_form(comment_changeset))}
  end

  def handle_event("save", %{"recipe_comment" => recipe_comment}, socket) do
    current_user_id = socket.assigns.current_user.id
    recipe_id = socket.assigns.recipe.id

    recipe_comment =
      recipe_comment
      |> Map.put("user_id", current_user_id)
      |> Map.put("recipe_id", recipe_id)

    comment_changeset = RecipeComment.changeset(%RecipeComment{}, recipe_comment)

    case Repo.insert(comment_changeset) do
      {:ok, _comment} ->
        comments = Recipes.get_recipe_comments(recipe_id)
        send(self(), {:comment_added, recipe_id})
        {:noreply, assign(socket, add_comment: false, comment_form: nil, comments: comments)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
