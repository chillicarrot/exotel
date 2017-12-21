defmodule ExotelTest do
  use ExUnit.Case
  doctest Exotel

  test "greets the world" do
    assert Exotel.hello() == :world
  end
end
