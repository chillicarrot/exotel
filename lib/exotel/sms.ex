defmodule Exotel.Sms do

  def send_sms(data) do
    Exotel.API.post("Sms/send.json", data)
  end

  def send_sms(data, [{_event_fn, _callback} | _] = events) do
    response = send_sms(data)
    sms_sid = response.body["sms_message"]["sid"]
    Exotel.Track.on_event({:sms, sms_sid, events})
  end
end