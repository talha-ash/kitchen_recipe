defmodule KitchenRecipeWeb.Components.Header do
  use KitchenRecipeWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <header class="header-wrapper">
      <div class="header-content container">
        <div class="logo-wrapper">
          <img src="./assets/images/scratch-logo.png" alt="scratch-logo" />
        </div>
        <div class="search-bar-wrapper">
          <form action="">
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <g opacity="0.4">
                <circle cx="11" cy="11" r="6" stroke="#363837" />
                <path
                  d="M15.5 15.5L18.6866 18.6866"
                  stroke="#363837"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </g>
            </svg>
            <input
              type="text"
              name="search"
              id=""
              placeholder="Search Recipe, Profile, or Ingredients"
            />
          </form>
        </div>
        <div class="header-icons-wrapper">
          <span>
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <ellipse cx="12" cy="12" rx="6" ry="5" stroke="#363837" />
              <rect
                x="11"
                y="5"
                width="2"
                height="1"
                stroke="#363837"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path d="M7 19H17" stroke="#363837" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
          </span>
          <span>
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M5 7.5L12 12.5"
                stroke="#363837"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                d="M19 7.5L12 12.5"
                stroke="#363837"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M5 7H19V17H5V7Z"
                stroke="#363837"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
          </span>
          <div class="avatar-img-wrapper">
            <img src="/assets/images/main-Avatar.png" alt="" />
          </div>
        </div>
      </div>
    </header>
    """
  end
end
