defmodule Flickrex.API.BaseTest do
  use ExUnit.Case

  import Flickrex.API.Base

  test "call" do
    flickrex = Flickrex.new
    response = call(flickrex, "TEST", [param: "PARAM"])
    assert response == %{"method" => "TEST", "param" => "PARAM"}
  end

  test "request" do
    config = [consumer_key: "CK", consumer_secret: "CS", access_token: "AC", access_token_secret: "ATS"]
    flickrex = Flickrex.new(config)
    body = request(flickrex, :method, "URL", param: "PARAM")
    assert body == "method=method&url=URL&ck=CK&cs=CS&at=AC&ats=ATS&param=PARAM"
  end

  test "rest URL" do
    assert rest_url() == "https://api.flickr.com/services/rest"
  end

  test "oauth URL" do
    assert auth_url(:request_token) == "https://api.flickr.com/services/oauth/request_token"
    assert auth_url(:authorize) == "https://api.flickr.com/services/oauth/authorize"
    assert auth_url(:access_token) == "https://api.flickr.com/services/oauth/access_token"
  end

  test "request URL" do
    assert request_url("test") == "https://api.flickr.com/services/test"
  end
end