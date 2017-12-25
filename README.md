# Exotel

Elixir client for Exotel API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exotel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exotel, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exotel](https://hexdocs.pm/exotel).

## Usage

```
Exotel.Call.make_call(%{from: "000xxxxxx", url: "http://my.exotel.com/exoml/start/XXXX", caller_id: "000yyyyy", status_callback: "https://sample-callback-url"})


Exotel.Sms.send_sms(%{from: "000xxxxxx", body: "Test message from API", to: "000yyyyy", status_callback: "https://sample-callback-url"})

```