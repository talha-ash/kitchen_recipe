defmodule KitchenRecipeWeb.FeedLive do
  use KitchenRecipeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
