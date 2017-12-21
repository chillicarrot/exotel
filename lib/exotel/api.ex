defmodule Exotel.API do
  use Tesla
  plug Tesla.Middleware.BaseUrl, base_url()
  plug __MODULE__
  plug Tesla.Middleware.FormUrlencoded

  def call(env, next, options) do
    body = case env.body do
      nil -> nil
      b when is_list(b) or is_map(b) -> b |> Enum.map(fn {k, v} -> {k |> Atom.to_string() |> String.capitalize, v} end)
    end
    %{env | body: body}
    |> Tesla.run(next)
    |> decode
  end

  def decode(env) do
    body = env.body
    |> Poison.decode!
    |> ProperCase.to_snake_case
    %{env | body: body}
  end

  def base_url do
    Exotel.Util.get_base_url()
  end
end