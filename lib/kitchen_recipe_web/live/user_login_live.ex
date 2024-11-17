defmodule KitchenRecipeWeb.UserLoginLive do
  use KitchenRecipeWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="login-form-wrapper">
      <div class="login-form-content">
        <h2>Welcome Back!</h2>
        <p>Please login to continue.</p>
        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <div class="form-text-box">
            <label for="">Email address</label>
            <.input field={@form[:email]} type="email" required placeholder="user@email.com" />
          </div>
          <div class="forgot-link">
            <.link href={~p"/users/reset_password"}>
              Forgot password?
            </.link>
          </div>
          <div class="form-text-box">
            <label for="">Password</label>
            <.input field={@form[:password]} type="password" required placeholder="******" />
          </div>
          <div class="btn-wrapper flex flex-col gap-2">
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.button phx-disable-with="Login in...">Login</.button>
          </div>
        </.simple_form>
        <div class="sign-up-content">
          <span>New to Scratch?</span>
          <h4>
            <.link href={~p"/users/register"}>
              Create account here
            </.link>
          </h4>
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
