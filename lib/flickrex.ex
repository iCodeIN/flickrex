defmodule Flickrex do
  @moduledoc """
  Flickr client library for Elixir.
  """

  alias Flickrex.API
  alias Flickrex.Config
  alias Flickrex.Parser
  alias Flickrex.RequestToken

  @type response :: Parser.response

  @doc """
  Creates a Flickrex client using the application config
  """
  @spec new :: Config.t
  def new do
    new(Application.get_env(:flickrex, :oauth))
  end

  @doc """
  Creates a Flickrex client using the provided config

  The accepted parameters are:

    * `:consumer_token` - Flickr API key
    * `:consumer_secret` - Flicrkr API shared secret
    * `:access_token` - Per-user access token
    * `:access_token_secret` - Per-user access token secret
  """
  @spec new(Keyword.t) :: Config.t
  defdelegate new(params), to: Flickrex.Config

  @doc ~S"""
  Updates the config of a Flickrex client

  ## Examples:

    tokens = [access_token: "...", access_token_secret: "..."]
    flickrex = Flickrex.new |> Flickrex.config(tokens)
  """
  @spec config(Config.t, Keyword.t) :: Config.t
  defdelegate config(config, params), to: Flickrex.Config, as: :merge

  @doc """
  Gets a temporary token to authenticate the user to your application

  ## Options

  * `oauth_callback` - For web apps, the URL to redirect the user back to after
    authentication.
  """
  @spec get_request_token(Config.t, Keyword.t) :: RequestToken.t
  defdelegate get_request_token(config, params \\ []), to: API.Auth

  @doc """
  Generates a Flickr authorization page URL for a user

  ## Examples:

    token = Flickrex.get_request_token(flickrex)
    auth_url = Flickrex.get_authorize_url(token)
  """
  @spec get_authorize_url(RequestToken.t, Keyword.t) :: binary
  defdelegate get_authorize_url(request_token, params \\ []), to: API.Auth

  @doc """
  Fetches an access token from Flickr and updates the config

  The function takes an existing Flickrex config, a request token, and a verify
  token generated by the Flickr authorization page.

  ## Examples:

    flickrex = Flickrex.fetch_access_token(flickrex, token, verify)
  """
  @spec fetch_access_token(Config.t, RequestToken.t, binary) :: Config.t
  defdelegate fetch_access_token(config, request_token, verify), to: API.Auth

  @doc """
  Makes a GET request to the Flickr REST endpoint

  ## Examples:

    response = Flickrex.get(flickrex, "flickr.photos.getRecent", per_page: 5)
  """
  @spec get(Config.t, binary, Keyword.t) :: response
  def get(config, method, args \\ []) do
    config |> API.Base.call(:get, method, args) |> Parser.parse
  end
end
