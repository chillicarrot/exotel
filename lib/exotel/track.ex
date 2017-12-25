defmodule Exotel.Track do
  use GenServer

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(state) do
    :ets.new(:tracking_call_sids, [:set, :public,  :named_table])
    :ets.new(:tracking_sms_sids, [:set, :public, :named_table])
    track()
    {:ok, state}
  end

  def get_details({:call, call_sid}) do
    Exotel.API.get("Calls/#{call_sid}.json")
  end

  def get_details({:sms, sms_sid}) do
    Exotel.API.get("SMS/Messages/#{sms_sid}.json")
  end

  def track() do
    send(__MODULE__, {:track, :tracking_call_sids, :call})
    send(__MODULE__, {:track, :tracking_sms_sids, :sms})
    Process.send_after(__MODULE__, :track, 10000)
  end

  def on_event({type, call_sid, events}) do
    GenServer.cast(__MODULE__, {:on_event, {type, call_sid, events}})
  end

  def maybe_notify_event(type, {sid, {event_fn, callback}}) do
    response = get_details({type, sid})
    case event_fn.(response.body) do
      true -> callback.(response.body)
      false -> :noop
    end
  end

  def key_stream(table_name) do
    Stream.resource(
      fn -> :ets.first(table_name) end,
      fn :"$end_of_table" -> {:halt, nil}
         previous_key -> {[previous_key], :ets.next(table_name, previous_key)} end,
      fn _ -> :ok end)
  end

  #callbacks

  def handle_info({:track, table, type}, state) do
    table
    |> key_stream
    |> Task.async_stream(fn sid ->
      [{sid, events}] = :ets.lookup(table, sid)
      events
      |> Enum.map(fn s -> {s, maybe_notify_event(type, {sid,s})} end)
      |> Enum.filter(fn {_, x} -> x == :noop end)
      |> Enum.map(fn {s, _} -> s end)
      |> case do
        [] -> :ets.delete(table, sid)
        e -> :ets.insert(table, {sid, e})
      end
    end)
    |> Enum.to_list

    {:noreply, state}
  end

  def handle_info(:track, state) do
    track()
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  def handle_cast({:on_event, {:call, call_sid, events}}, state) do
    :ets.insert(:tracking_call_sids, {call_sid, events})
    {:noreply, state}
  end

  def handle_cast({:on_event, {:sms, sms_sid, events}}, state) do
    :ets.insert(:tracking_sms_sids, {sms_sid, events})
    {:noreply, state}
  end
end