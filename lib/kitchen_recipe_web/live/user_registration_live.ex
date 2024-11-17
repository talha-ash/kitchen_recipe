defmodule KitchenRecipeWeb.UserRegistrationLive do
  use KitchenRecipeWeb, :live_view

  alias KitchenRecipe.Accounts
  alias KitchenRecipe.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="signup-form-wrapper">
      <div class="signup-form-content">
        <h2>Start from Scratch</h2>
        <p>Create account to continue.</p>
        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>
          <div class="form-text-box">
            <label for="">Full Name</label>
            <.input field={@form[:fullname]} type="text" required placeholder="Nick Evans" />
          </div>
          <div class="form-text-box">
            <label for="">Username</label>
            <.input field={@form[:username]} type="text" required placeholder="nick_evans" />
          </div>
          <div class="form-text-box">
            <label for="">Email address</label>
            <.input field={@form[:email]} type="email" required placeholder="user@email.com" />
          </div>
          <div class="form-text-box">
            <label for="">Password</label>
            <.input field={@form[:password]} type="password" required placeholder="*****" />
          </div>
          <div class="btn-wrapper">
            <.button phx-disable-with="Creating account...">Sign Up</.button>
          </div>
        </.simple_form>
        <div class="sign-up-content">
          <span>Already have an account?</span>
          <h4>
            <.link navigate={~p"/users/log_in"}>
              Login Here
            </.link>
          </h4>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
