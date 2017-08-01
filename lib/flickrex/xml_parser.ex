defmodule Flickrex.XmlParser do
  @moduledoc false

  def parse(response) when is_binary(response) do
    response |> :parsexml.parse() |> parse()
  end

  def parse({"rsp", [{"stat", "fail"}], error}) do
    {:error, error}
  end

  def parse({"rsp", [{"stat", "ok"}], response}) do
    {:ok, response}
  end
end
