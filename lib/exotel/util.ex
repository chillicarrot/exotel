defmodule Exotel.Util do
  def add_credentials(state) do
    base_url = get_base_url()
    Map.put(state, :base_url, base_url)
  end

  def get_base_url() do
    config = Application.get_all_env(:exotel) |> Enum.into(%{})
    api_version = Map.get(config, :api_version, "v1")
    case {Map.get(config, :sid), Map.get(config, :token)} do
      {a, b} when is_nil(a) or is_nil(b) -> raise "Require credentials for Exotel API calls."
      {sid, token} -> "https://#{sid}:#{token}@api.exotel.com/#{api_version}/Accounts/#{sid}/"
    end
  end
end