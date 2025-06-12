defmodule KitchenRecipeWeb.UserRegistrationLiveTest do
  use KitchenRecipeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import KitchenRecipe.AccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/register")

      assert html =~ "Create account to continue"
      assert html =~ "Login Here"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register")
        |> follow_redirect(conn, "/feed")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"email" => "with spaces", "password" => "too short"})

      assert result =~ "Create account to continue"
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "should be at least 12 character"
    end
  end

  describe "register user" do
    test "creates account and logs the user in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      fullname = unique_fullname()

      file =
        file_input(lv, "#registration_form", :avatar, [
          %{
            last_modified: ~c"1_624_366_053_000",
            name: "test_avatar.png",
            content: File.read!("./test/support/test_avatar.png"),
            type: "image/png"
          }
        ])

      render_upload(file, "test_avatar.png")

      form =
        form(lv, "#registration_form",
          user: valid_user_attributes_without_avatar(fullname: fullname)
        )

      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/feed"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/feed")
      response = html_response(conn, 200)
      assert response =~ fullname
      # assert response =~ "Settings"
      assert response =~ "Sign out"
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      user = user_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          user: %{"email" => user.email, "password" => "valid_password"}
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      {:ok, _login_live, login_html} =
        lv
        |> element(~s|main a:fl-contains("Login Here")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/users/log_in")

      assert login_html =~ "Please login to continue"
    end
  end
end
