defmodule KVServer do
  require Logger

  def accept(port) do
    {:ok, server_socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port: #{port}")
    accept_on server_socket
  end

  def accept_on(server_socket) do
    {:ok, client_socket} = :gen_tcp.accept(server_socket)
    serve client_socket
    accept_on server_socket
  end

  def serve(client_socket) do
    client_socket
    |> read_line
    |> write_line(client_socket)

    serve client_socket
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
