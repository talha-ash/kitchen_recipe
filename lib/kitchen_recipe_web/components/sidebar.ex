defmodule KitchenRecipeWeb.Components.Sidebar do
  use Phoenix.Component
  use KitchenRecipeWeb, :verified_routes

  def user_detail(assigns) do
    ~H"""
    <div class="Profile-Stats-wrapper spacing">
      <div class="profile-stats-content">
        <div class="top-area">
          <div class="avatar-img-wrapper">
            <img src={@current_user.avatar_url} alt="" />
          </div>
          <div class="avatar-content">
            <.link href={~p"/profile/#{@current_user.id}"}>
              <h4 class="cursor-pointer"><%= @current_user.fullname || @current_user.username %></h4>
            </.link>
            <%!-- <span class="font-styling">Potato Master</span> --%>
            <div class="followers-wrapper font-styling ">
              <.async_result :let={user_info} assign={@user_info}>
                <:loading>Loading User Info...</:loading>
                <:failed :let={_failure}>there was an error loading the organization</:failed>
                <div><%= user_info.followers_count %> followers</div>
                <div class="dot"></div>
                <div><%= user_info.recipes_likes %> likes</div>
              </.async_result>
            </div>
          </div>
        </div>
        <div class="bottom-area">
          <div class="group">
            <strong :if={user_info_ok(@user_info)}>
              <%= @user_info.result.recipes_count %>
            </strong>
            <span>Recipes</span>
          </div>
          <div class="group">
            <strong :if={user_info_ok(@user_info)}>
              <%= @user_info.result.saved_recipes %>
            </strong>
            <span>Saved</span>
          </div>
          <div class="group">
            <strong :if={user_info_ok(@user_info)}>
              <%= @user_info.result.following_count %>
            </strong>
            <span>Following</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def other_user_detail(assigns) do
    ~H"""
    <div class="Profile-Stats-wrapper spacing">
      <div class="profile-stats-content">
        <div class="top-area">
          <div class="avatar-img-wrapper">
            <img src={@other_user.avatar_url} alt="" />
          </div>
          <div class="avatar-content">
            <.link href={~p"/profile/#{@other_user.id}"}>
              <h4 class="cursor-pointer"><%= @other_user.fullname || @other_user.username %></h4>
            </.link>
            <%!-- <span class="font-styling">Potato Master</span> --%>
            <div class="followers-wrapper font-styling ">
              <.async_result :let={user_info} assign={@user_info}>
                <:loading>Loading User Info...</:loading>
                <:failed :let={_failure}>there was an error loading the organization</:failed>
                <div><%= user_info.followers_count %> followers</div>
                <div class="dot"></div>
                <div><%= user_info.recipes_likes %> likes</div>
              </.async_result>
            </div>
          </div>
        </div>
        <div class="bottom-area">
          <.async_result :let={user_info} assign={@user_info}>
            <%= if user_info.is_following do %>
              <button
                phx-click="unfollow-user"
                phx-throttle="400"
                class="!bg-gray-400 text-gray-500 phx-click-loading:opacity-50 phx-click-loading:cursor-wait"
              >
                Following
              </button>
            <% else %>
              <button
                phx-click="follow-user"
                phx-throttle="400"
                class="phx-click-loading:opacity-50 phx-click-loading:cursor-wait"
              >
                Follow
              </button>
            <% end %>
          </.async_result>
        </div>
      </div>
    </div>
    """
  end

  def top_recipes(assigns) do
    ~H"""
    <div class="stats-top-list-wrapper spacing">
      <div class="stats-top-list-content">
        <h4>Top 5 Recipe today</h4>
        <.async_result :let={top_recipes} assign={@top_recipes}>
          <:loading>Loading Recipes...</:loading>
          <ul class="font-styling listing">
            <li :for={recipe <- top_recipes}>
              <a href=""><%= recipe.title %></a>
            </li>
          </ul>
        </.async_result>
      </div>
    </div>
    """
  end

  defp user_info_ok(user_info) do
    if user_info.ok? && user_info.result, do: true, else: false
  end
end
