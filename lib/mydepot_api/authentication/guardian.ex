defmodule MydepotApi.Authentication.Guardian do
  use Guardian, otp_app: :mydepot_api
  alias MydepotApi.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end

  # def authenticate(email, password) do
  #   with {:ok, user} <- Accounts.get_by_email(email) do
  #     case validate_password(password, user.password_hash) do
  #       true ->
  #       IO.puts("signed in")
  #         create_token(user)
  #       false ->
  #         IO.puts("please check input")
  #         {:error, :unauthorized}
  #     end
  #   end
  # end

  # defp validate_password(password, password_hash) do
  #   Pbkdf2.verify_pass(password, password_hash)
  # end

  # defp create_token(user) do
  #   {:ok, token, _claims} = encode_and_sign(user)
  #   {:ok, user, token}
  # end
end
