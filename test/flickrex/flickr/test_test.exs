defmodule Flickrex.Flickr.TestTest do
  use ExUnit.Case

  @moduletag :flickr_api

  test "test echo/1 in XML" do
    test_format("", %{}, "text/xml; charset=utf-8")
  end

  test "test echo/1 in JSON" do
    test_format("json", %{"_content" => "json"}, "application/json")
  end

  def test_format(req_format, resp_format_content, resp_content_type) do
    {:ok, resp} =
      [test: "test"]
      |> Flickrex.Flickr.Test.echo()
      |> Map.put(:format, req_format)
      |> Flickrex.request()

    assert %{status_code: 200, headers: headers, body: body} = resp

    content_type =
      headers
      |> Map.new()
      |> Map.get("Content-Type")

    assert content_type == resp_content_type

    assert %{
             "format" => ^resp_format_content,
             "method" => %{"_content" => "flickr.test.echo"},
             "nojsoncallback" => %{"_content" => "1"},
             "stat" => "ok",
             "test" => %{"_content" => "test"}
           } = body
  end
end
