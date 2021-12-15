defmodule MydepotApiWeb.UserController do
  use MydepotApiWeb, :controller


  alias MydepotApi.Authentication.Guardian
  alias MydepotApi.Accounts
  alias MydepotApi.Accounts.User

  action_fallback MydepotApiWeb.FallbackController

  #controller function for signing up
  def signup(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.signup_user(user_params) do
      conn
      |> put_status(:created)
      |> render("registered.json", user: user)
    end
  end

  #controller function for signing in

  def signin(conn, %{"email" => email,"password" => password}) do

    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, access_token, _claims} =
        Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {15, :minute})
        conn = Guardian.Plug.sign_in(conn, user)
      conn
      |> put_resp_cookie("token", access_token)
      |> put_status(:created)
      |> render("token.json",access_token: access_token)

    {:error, :unauthorized} ->
      body = Jason.encode!(%{error: "unauthorized wrong input"})
      conn
      |> send_resp(401, body)
    end
  end

    #controller function to refresh/ request for a new token

    def refresh(conn, _params) do
      refreshing_token =
      Plug.Conn.fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "token"])

      case Guardian.refresh(refreshing_token) do
        {:ok, _old_stuff, {new_token, new_claims}} ->
          conn
          |> put_status(:created)
          |> put_resp_cookie("token", new_token)
          |> render("token.json",%{access_token: new_token})

        {:error, :unauthorized} ->
          body = Jason.encode!(%{error: "unauthorized"})
          conn
          |> send_resp(401, body)
      end
    end

   #controller function to delete token

    def  delete(conn, _params) do
      conn
        |> delete_resp_cookie("my_token")

        |> put_status(200)
        |> text("Log out successfully")
    end
end
