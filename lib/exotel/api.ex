defmodule Exotel.API do
  use Tesla
  plug Tesla.Middleware.BaseUrl, base_url()
  plug __MODULE__
  plug Tesla.Middleware.FormUrlencoded

  def call(env, next, _options) do
    body = case env.body do
      nil -> nil
      b when is_list(b) or is_map(b) -> format_body(b)
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

  defp format_body(b) do
    Enum.map(b, fn {k1, v} ->
      k2 = k1 |> Atom.to_string() |> ProperCase.camel_case()
      k3 = "#{k2 |> String.first() |> String.upcase()}#{String.slice(k2, 1..-1)}"
      {k3, v}
    end)
  end
end