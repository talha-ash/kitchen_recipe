defmodule KitchenRecipeWeb.Components.Recipe.Components do
  use Phoenix.Component
  use KitchenRecipeWeb, :verified_routes
  import KitchenRecipeWeb.CoreComponents

  def create_recipe_bar(assigns) do
    ~H"""
    <div class="create-recipe-bar-wrapper spacing">
      <div class="create-recipe-bar-content">
        <%!-- <strong class="font-styling">286 of your followers are online</strong> --%>
        <div class="create-recipe-button-wrapper">
          <.link href={~p"/recipes/new"}>Create Recipe</.link>
        </div>
      </div>
    </div>
    """
  end

  def recipe_comments(assigns) do
    ~H"""
    <section class="bg-white dark:bg-gray-900 py-8 lg:py-16 max-h-[800px] overflow-y-auto">
      <div class="max-w-2xl mx-auto px-4">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-lg lg:text-2xl font-bold text-gray-900 dark:text-white">
            Comments (<%= length(@comments) %>)
          </h2>
          <div phx-click="toggle-add-comments" class="cursor-pointer" phx-target={@myself}>
            <.icon name="hero-plus" />
          </div>
        </div>
        <.simple_form
          :if={@add_comment}
          id="comment-form"
          for={@comment_form}
          phx-submit="save"
          phx-change="validate"
          phx-target={@myself}
          class="mb-6"
        >
          <div class="py-2 px-4 mb-4 bg-white rounded-lg rounded-t-lg border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
            <label for="comment" class="sr-only">Your comment</label>
            <.input
              field={@comment_form[:content]}
              type="textarea"
              class="px-0 w-full text-sm text-gray-900 border-0 focus:ring-0 focus:outline-none dark:text-white dark:placeholder-gray-400 dark:bg-gray-800"
              placeholder="Write a comment..."
              required
              rows="6"
            />
            <%!-- <textarea
              id="comment"
              rows="6"
              class="px-0 w-full text-sm text-gray-900 border-0 focus:ring-0 focus:outline-none dark:text-white dark:placeholder-gray-400 dark:bg-gray-800"
              placeholder="Write a comment..."
              required
            ></textarea> --%>
          </div>
          <button
            type="submit"
            class="inline-flex items-center py-2.5 px-4 text-xs font-medium text-center text-white bg-primary-700 rounded-lg focus:ring-4 focus:ring-primary-200 dark:focus:ring-primary-900 hover:bg-primary-800"
          >
            Post comment
          </button>
        </.simple_form>
        <article
          :for={comment <- @comments}
          class="p-6 text-base bg-white border-t border-gray-200 dark:border-gray-700 dark:bg-gray-900"
        >
          <footer class="flex justify-between items-center mb-2">
            <div class="flex items-center">
              <p class="inline-flex items-center mr-3 text-sm text-gray-900 dark:text-white font-semibold">
                <.user_avatar user={comment.user} />
                <.user_name user={comment.user} />
              </p>
              <p class="ml-2 text-sm text-gray-600 dark:text-gray-400">
                <time pubdate datetime="2022-06-23" title="June 23rd, 2022">Jun. 23, 2022</time>
              </p>
            </div>
          </footer>
          <p class="text-gray-500 dark:text-gray-400">
            <%= comment.content %>
          </p>
        </article>
      </div>
    </section>
    """
  end
end
