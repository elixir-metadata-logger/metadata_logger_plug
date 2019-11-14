defmodule MetadataLogger.PlugTest do
  use ExUnit.Case
  use Plug.Test

  import ExUnit.CaptureLog

  doctest MetadataLogger.Plug

  defmodule MetadataFormatter do
    def format(_level, _message, _timestamp, metadata) do
      inspect(metadata) <> "\n"
    end
  end

  setup do
    on_exit(fn ->
      :ok =
        Logger.configure_backend(
          :console,
          format: nil,
          device: :user,
          level: nil,
          metadata: :all,
          colors: [enabled: false]
        )
    end)

    Logger.configure_backend(:console,
      format: {MetadataFormatter, :format},
      colors: [enabled: false],
      metadata: :all
    )

    :ok
  end

  test "metadata in logs" do
    captured =
      capture_log(fn ->
        :get |> conn("/ping?foo=bar") |> MetadataLogger.Plug.call([]) |> send_resp(200, "pong")
      end)

    assert captured =~ ~s(http_remote_ip: "127.0.0.1")
    assert captured =~ ~s(http_method: "GET")
    assert captured =~ ~s(http_path: "/ping")
    assert captured =~ ~s(http_duration_ms: )
    assert captured =~ ~s(http_status: 200)
    assert captured =~ ~s(http_response_body_bytes: )

    assert Logger.metadata() == []
  end
end
