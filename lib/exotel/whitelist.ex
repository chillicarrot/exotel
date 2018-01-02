defmodule Exotel.Whitelist do
  def add_to_whitelist(%{virtual_number: _virtual_number, numbers: numbers} = data) do
    numbers = Enum.join(numbers, ", ")
    data = data |> Map.put(:number, numbers) |> Map.delete(:numbers)
    Exotel.API.post("/CustomerWhitelist.json", data)
  end
end