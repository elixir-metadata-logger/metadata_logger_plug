defmodule PlugMetadataLogger do
  @moduledoc """
  Plug Middleware to log request and response into in metadata.

  It puts a map into metadata, so logger formatter *MUST* handle it.
  Otherwise it will raise `Protocol.UndefinedError`
  """
  require Logger

  @behaviour Plug

  alias Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    req_metadata = [
      http_method: conn.method,
      http_path: conn.request_path,
      http_remote_ip: to_string(:inet.ntoa(conn.remote_ip))
    ]

    Logger.debug("started", req_metadata)

    start = System.monotonic_time()

    Conn.register_before_send(conn, fn conn ->
      stop = System.monotonic_time()
      duration_ms = System.convert_time_unit(stop - start, :native, :millisecond)

      resp_metadata = [
        http_duration_ms: duration_ms,
        http_response_body_bytes: IO.iodata_length(conn.resp_body),
        http_status: conn.status
      ]

      Logger.debug("completed", resp_metadata)

      Logger.info("completed", req_metadata ++ resp_metadata)
      conn
    end)
  end
end
