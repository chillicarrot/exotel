defmodule Exotel.Util do
  def add_credentials(state) do
    base_url = get_base_url()
    Map.put(state, :base_url, base_url)
  end

  def get_base_url() do
    config = Application.get_all_env(:exotel) |> Enum.into(%{})
    api_version = Map.get(config, :api_version, "v1")
    "https://#{Map.get(config, :auth_key)}:#{Map.get(config, :auth_token)}@api.exotel.com/#{api_version}/Accounts/#{Map.get(config, :sid)}/"
  end
end
