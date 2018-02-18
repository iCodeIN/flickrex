defmodule Flickrex.Auth.AccessTokenTest do
  use ExUnit.Case, async: true

  import Flickrex.Support.Config

  alias Flickrex.Response

  setup [:flickr_config]

  test "request an access token", %{config: opts} do
    operation = Flickrex.Auth.access_token("TOKEN", "SECRET", "VERIFIER")

    {:ok, response} = Flickrex.request(operation, opts)

    expected_response = %Response{
      body: %{
        fullname: "FULL NAME",
        oauth_token: "TOKEN",
        oauth_token_secret: "SECRET",
        user_nsid: "NSID",
        username: "USERNAME"
      },
      headers: [],
      status_code: 200
    }

    assert response == expected_response
  end
end
