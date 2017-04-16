defmodule Flickrex.API.Base do
  @moduledoc """
  Provides base access to Flickr API.
  """

  alias Flickrex.Client
  alias Flickrex.Client.Access
  alias Flickrex.Client.Request
  alias Flickrex.Client.Consumer

  @api_end_point "https://api.flickr.com/services"
  @oauther Application.get_env(:flickrex, :oauther) || Flickrex.OAuth.Client

  @doc """
  Calls Flickr API with an API method and optional arguments

  Example:

    response = Flickrex.API.Base.call(flickrex, :get, "flickr.photos.getRecent", per_page: 5)
  """
  @spec call(Client.t, :get | :post, binary, Keyword.t) :: {:ok | :error, binary}
  def call(%Client{} = client, http_method, api_method, args \\ []) do
    params = Keyword.merge([method: api_method, format: "json", nojsoncallback: 1], args)
    request(client.consumer, client.access, http_method, rest_url(), params)
  end

  @doc false
  @spec request(Consumer.t, Access.t | Request.t, :get | :post, binary, Keyword.t) :: {:ok | :error, binary}
  def request(consumer, token, method, url, params) do
    result = @oauther.request(method, url, params, consumer.key, consumer.secret,
      token.token, token.secret)
    case result do
      {:ok, {{_, 200, _}, _header, body}} ->
        {:ok, IO.iodata_to_binary(body)}
      {:ok, {{_, _code, status}, _header, body}} ->
        {:error, "#{status}: #{body}"}
      {:error, _reason} ->
        raise Flickrex.ConnectionError
    end
  end

  @doc false
  @spec rest_url :: binary
  def rest_url do
    request_url("rest")
  end

  @doc false
  @spec auth_url(atom | binary) :: binary
  def auth_url(path) do
    request_url("oauth/#{path}")
  end

  @doc false
  @spec request_url(atom | binary) :: binary
  def request_url(path) do
    "#{@api_end_point}/#{path}"
  end
end
