defmodule KitchenRecipeWeb.Components.Sidebar do
  use Phoenix.Component

  def user_detail(assigns) do
    ~H"""
    <div class="Profile-Stats-wrapper spacing">
      <div class="profile-stats-content">
        <div class="top-area">
          <div class="avatar-img-wrapper">
            <img src="/assets/images/main-Avatar.png" alt="" />
          </div>
          <div class="avatar-content">
            <h4><%= @current_user.fullname || @current_user.username %></h4>
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
