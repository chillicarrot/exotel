defmodule Exotel.Whitelist do
  def add_to_whitelist(%{virtual_number: _virtual_number, numbers: _numbers} = data) do
    Exotel.API.post("/CustomerWhitelist.json", data)
  end
end