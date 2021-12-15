defmodule MydepotApi.Authentication.Pipeline do

  @claims %{typ: "access"}
  use Guardian.Plug.Pipeline,
  otp_app: :mydepot_api,
  module: MydepotApi.Authentication.Guardian,
  error_handler: MydepotApi.Authentication.ErrorHandler

plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
plug(Guardian.Plug.EnsureAuthenticated)
plug(Guardian.Plug.LoadResource, ensure: true)
end
