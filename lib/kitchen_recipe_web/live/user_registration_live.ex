defmodule KitchenRecipeWeb.UserRegistrationLive do
  use KitchenRecipeWeb, :live_view

  alias KitchenRecipe.Accounts
  alias KitchenRecipe.Accounts.User
  alias Support.Uploads

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-xl shadow-lg">
        <!-- Header -->
        <div class="text-center">
          <h2 class="text-3xl font-bold text-gray-900">Start from Scratch</h2>
          <p class="mt-2 text-sm text-gray-600">Create account to continue.</p>
        </div>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
          class="mt-8 space-y-6"
        >
          <!-- Error Message -->
          <.error :if={@check_errors}>
            <div class="flex">
              <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                  clip-rule="evenodd"
                />
              </svg>
              <div class="ml-3">
                <p class="text-sm text-red-700">
                  Oops, something went wrong! Please check the errors below.
                </p>
              </div>
            </div>
          </.error>
          <!-- Form Fields -->
          <div class="space-y-6">
            <!-- Full Name -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Full Name</label>
              <.input
                field={@form[:fullname]}
                type="text"
                required
                placeholder="Nick Evans"
                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm
                      placeholder-gray-400 focus:ring-green-500 focus:border-green-500"
              />
            </div>
            <!-- Username -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Username</label>
              <.input
                field={@form[:username]}
                type="text"
                required
                placeholder="nick_evans"
                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm
                      placeholder-gray-400 focus:ring-green-500 focus:border-green-500"
              />
            </div>
            <!-- Email -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Email address</label>
              <.input
                field={@form[:email]}
                type="email"
                required
                placeholder="user@email.com"
                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm
                      placeholder-gray-400 focus:ring-green-500 focus:border-green-500"
              />
            </div>
            <!-- Password -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Password</label>
              <.input
                field={@form[:password]}
                type="password"
                required
                placeholder="*****"
                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm
                      placeholder-gray-400 focus:ring-green-500 focus:border-green-500"
              />
            </div>
            <!-- Avatar Upload -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Avatar</label>
              <div class="mt-1 flex items-center">
                <.live_file_input
                  upload={@uploads.avatar}
                  required={true}
                  class="relative cursor-pointer bg-white py-2 px-3 border border-gray-300 rounded-md
                        shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50
                        focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                />
              </div>
            </div>
            <!-- Submit Button -->
            <div>
              <.button
                phx-disable-with="Creating account..."
                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md
                      shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700
                      focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
              >
                Sign Up
              </.button>
            </div>
          </div>
        </.simple_form>
        <!-- Login Link -->
        <div class="text-center mt-4">
          <p class="text-sm text-gray-600">
            Already have an account?
            <.link
              navigate={~p"/users/log_in"}
              class="font-medium text-green-600 hover:text-green-500"
            >
              Login Here
            </.link>
          </p>
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
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # {:ok, _} =
        #   Accounts.deliver_user_confirmation_instructions(
        #     user,
        #     &url(~p"/users/confirm/#{&1}")
        #   )

        avatar_path = "#{user.id}/avatar"

        avatar_url =
          Uploads.upload_files(socket, :avatar, avatar_path)
          |> Enum.at(0)
          |> String.replace("priv/static", "")

        Accounts.create_or_update_user_avatar(user.id, avatar_url)
        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
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
