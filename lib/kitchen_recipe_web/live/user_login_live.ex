defmodule KitchenRecipeWeb.UserLoginLive do
  use KitchenRecipeWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-xl shadow-lg">
        <!-- Header -->
        <div class="text-center">
          <h2 class="text-3xl font-bold text-gray-900">Welcome Back!</h2>
          <p class="mt-2 text-sm text-gray-600">Please login to continue.</p>
        </div>
        <!-- Form -->
        <.simple_form
          for={@form}
          id="login_form"
          action={~p"/users/log_in"}
          phx-update="ignore"
          class="mt-8 space-y-6"
        >
          <!-- Email -->
          <div>
            <label class="block text-sm font-medium text-gray-700">
              Email address
            </label>
            <.input
              field={@form[:email]}
              type="email"
              required
              placeholder="user@email.com"
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md
                    shadow-sm placeholder-gray-400
                    focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
            />
          </div>
          <!-- Password -->
          <div class="space-y-1">
            <div class="flex items-center justify-between">
              <label class="block text-sm font-medium text-gray-700">
                Password
              </label>
              <.link
                href={~p"/users/reset_password"}
                class="text-sm font-medium text-green-600 hover:text-green-500"
              >
                Forgot password?
              </.link>
            </div>
            <.input
              field={@form[:password]}
              type="password"
              required
              placeholder="******"
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md
                    shadow-sm placeholder-gray-400
                    focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
            />
          </div>
          <!-- Remember Me & Submit -->
          <div class="space-y-4">
            <div class="flex items-center">
              <.input
                field={@form[:remember_me]}
                type="checkbox"
                class="h-4 w-4 text-green-600 focus:ring-green-500
                      border-gray-300 rounded"
              />
              <label class="ml-2 block text-sm text-gray-900">
                Keep me logged in
              </label>
            </div>

            <.button
              phx-disable-with="Signing in..."
              class="w-full flex justify-center py-2 px-4 border border-transparent
                    rounded-md shadow-sm text-sm font-medium text-white
                    bg-green-600 hover:bg-green-700
                    focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
            >
              Sign in
            </.button>
          </div>
        </.simple_form>
        <!-- Sign Up Link -->
        <div class="text-center mt-6">
          <p class="text-sm text-gray-600">
            New to Scratch?
            <.link href={~p"/users/register"} class="font-medium text-green-600 hover:text-green-500">
              Create account here
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
