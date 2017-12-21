defmodule Exotel.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Exotel.Track, %{}}
    ]

    opts = [strategy: :one_for_one, name: Exotel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
