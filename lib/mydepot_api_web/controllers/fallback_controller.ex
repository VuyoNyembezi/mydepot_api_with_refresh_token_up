defmodule MydepotApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use MydepotApiWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(MydepotApiWeb.ErrorView)
    |> render(:"404")
  end
  # this clause handles error returned if trying to access private route with out token
    def call(conn, {:error, :unauthorized}) do
      conn
      |> put_status(:unauthorized)
      |> put_view(MydepotApiWeb.ErrorView)
      |> render(:"401")
    end

  #this clause handles error returned by Ecto's insert/update/delete
    #
    def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(MydepotApiWeb.ChangesetView)
      |> render("error.json", changeset: changeset)
    end


end
