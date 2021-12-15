defmodule MydepotApiWeb.UserView do
  use MydepotApiWeb, :view
  alias MydepotApiWeb.UserView

  #view for sign up process

  def render("registered.json", %{user: user}) do
   %{ email: user.email,
    password_hash: user.password_hash
  }
  end

  #view executed if  the user signed in succeffully
  def render("token.json", %{access_token: access_token}) do
    %{
      access_token: access_token
    }
  end



end
