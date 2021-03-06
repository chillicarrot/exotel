defmodule Exotel.Call do

  def make_call(data) do
    Exotel.API.post("Calls/connect.json", data)
  end

  def make_call(data, [{_event_fn, _callback} | _] = events) do
    response = make_call(data)
    call_sid = response.body["call"]["sid"]
    Exotel.Track.on_event({:call, call_sid, events})
  end
end
