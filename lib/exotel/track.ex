defmodule Exotel.Track do
  use GenServer

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(state) do
    state = Map.put(state, :tracking_call_sids, [])
    Process.send_after(__MODULE__, :track, 1000)
    {:ok, state}
  end

  def get_details(call_sid) do
    Exotel.API.get("Calls/#{call_sid}.json")
  end

  def on_event({call_sid, event_fn, callback}) do
    GenServer.cast(__MODULE__, {:on_event, {call_sid, event_fn, callback}})
  end

  def maybe_notify_event({call_sid, event_fn, callback}) do
    response = get_details(call_sid)
    case event_fn.(response.body) do
      true -> GenServer.cast(__MODULE__, {:notify_event, call_sid, response.body, callback})
      false -> :noop
    end
  end

  #callbacks

  def handle_info(:track, %{tracking_call_sids: calls} = state) do
    calls
    |> Task.async_stream(fn s -> maybe_notify_event(s) end)
    |> Enum.to_list
    Process.send_after(__MODULE__, :track, 2000) |> IO.inspect
    {:noreply, state}
  end

  def handle_cast({:on_event, {call_sid, event_fn, callback}}, state) do
    {:ok, state} = Map.get_and_update!(state, :tracking_call_sids, fn v ->{:ok, [{call_sid, event_fn, callback}] ++ v} end)
    {:noreply, state}
  end

  def handle_cast({:notify_event, sid, data, callback}, state) do
    callback.(data)
    {:ok, state} = Map.get_and_update!(state, :tracking_call_sids, fn d ->
      f = Enum.find(d, fn {s, _, _} ->
        s == sid
      end)
      {:ok, List.delete(d, f)}
    end)
    {:noreply, state}
  end

end