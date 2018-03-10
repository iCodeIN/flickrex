defmodule Flickrex.Auth do
  @moduledoc """
  Operations on Flickr Auth.

  ## Authentication

  Certain Flickr methods require authorization from a user account. You must
  present an authorization URL to the user, and obtain a verification code that
  can be exchanged for access tokens. You can store and re-use the access tokens
  without having to repeat the authorization step.

  ### Manual Verification

      {:ok, %{body: request}} = Flickrex.Auth.request_token() |> Flickrex.request()

      {:ok, auth_url} =
        request.oauth_token
        |> Flickrex.Auth.authorize_url()
        |> Flickrex.request()

      # Open the URL in your browser, authorize the app, and get the verify token
      oauth_verifier = "..."

      {:ok, %{body: access}} =
        request.oauth_token
        |> Flickrex.Auth.access_token(request.oauth_token_secret, oauth_verifier)
        |> Flickrex.request()

      # You can now call methods that require authorization
      {:ok, resp} = Flickrex.Flickr.Test.login() |> Flickrex.request(access)

  ### Callback Verification

  Specify a callback URL when generating the request token:

      opts = [oauth_callback: "https://example.com/check"]

      {:ok, %{body: request}} =
        opts
        |> Flickrex.Auth.request_token()
        |> Flickrex.request()

      {:ok, auth_url} =
        request.oauth_token
        |> Flickrex.Auth.authorize_url()
        |> Flickrex.request()

  Present the `auth_url` to the user and ask them to complete the authorization
  process. Save the `request.oauth_token` and the `request.oauth_token_secret`.

  After following the `auth_url` and authorizing your app, the user will be
  re-directed to:

  ```sh
  https://example.com/check?oauth_token=FOO&oauth_verifier=BAZ
  ```

  The `oauth_token` in the URL query corresponds to the `request.oauth_token`
  from the previous step, which you will need to recall the
  `oauth_token_secret`.

      {:ok, %{body: access}} =
        oauth_token
        |> Flickrex.Auth.access_token(oauth_token_secret, oauth_verifier)
        |> Flickrex.request()

  Finally, save `access.oauth_token` and `access.oauth_token_secret` for this
  user, which you can re-use.

  ## Re-authenticating

  Look up the access token and secret you have saved for the user, and use them
  to configure a request:

      config = [oauth_token: "...", oauth_token_secret: "..."]
      {:ok, resp} = Flickrex.Flickr.Test.login() |> Flickrex.request(config)

  See [User Authentication](https://www.flickr.com/services/api/auth.oauth.html)
  on Flickr for more information.
  """

  alias Flickrex.Operation

  @doc """
  Requests a temporary token to authenticate the user to your application.

  ## Options

  * `oauth_callback` - For web apps, the URL to redirect the user to after
    completing the authorization sequence. The URL will include query params
    `oauth_token` and `oauth_verifier`. If this option is not set, then
    authentication will default to out-of-band verification.
  """
  @spec request_token(Keyword.t()) :: Operation.Auth.RequestToken.t()
  def request_token(opts \\ []) do
    op = %Operation.Auth.RequestToken{}
    %{op | params: Map.merge(op.params, Map.new(opts))}
  end

  @doc """
  Generates a Flickr authorization URL.

  ## Options

  * `perms` - Ask for "read", "write", or "delete" privileges. Overrides the
    setting defined in your application's authentication flow.
  """
  @spec authorize_url(String.t(), Keyword.t()) :: Operation.Auth.AuthorizeUrl.t()
  def authorize_url(oauth_token, opts \\ []) do
    %Operation.Auth.AuthorizeUrl{
      oauth_token: oauth_token,
      params: Map.new(opts)
    }
  end

  @doc """
  Requests an access token from Flickr.
  """
  @spec access_token(String.t(), String.t(), String.t()) :: Operation.Auth.AccessToken.t()
  def access_token(oauth_token, oauth_token_secret, oauth_verifier) do
    %Operation.Auth.AccessToken{
      oauth_token: oauth_token,
      oauth_token_secret: oauth_token_secret,
      oauth_verifier: oauth_verifier
    }
  end
end
