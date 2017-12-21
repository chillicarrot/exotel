defmodule Exotel.Call do

  def make_call(data) do
    Exotel.API.post("Calls/connect.json", data)
  end

  def make_call(data, {event_fn, callback}) do
    response = make_call(data)
    call_sid = response.body["call"]["sid"]
    Exotel.Track.on_event({call_sid, event_fn, callback})
  end
end
