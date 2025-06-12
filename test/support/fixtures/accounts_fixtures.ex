defmodule KitchenRecipe.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `KitchenRecipe.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def unique_username, do: "user#{System.unique_integer()}"
  def unique_fullname, do: "user#{System.unique_integer()} user#{System.unique_integer()}"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      username: unique_username(),
      fullname: unique_fullname(),
      avatar_url: "fake_url"
    })
  end

  def valid_user_attributes_without_avatar(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      username: unique_username(),
      fullname: unique_fullname()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> KitchenRecipe.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
