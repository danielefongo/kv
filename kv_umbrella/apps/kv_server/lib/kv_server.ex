defmodule KVServer do
  require Logger

  def accept(port) do
    {:ok, server_socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port: #{port}")
    accept_on server_socket
  end

  def accept_on(server_socket) do
    {:ok, client_socket} = :gen_tcp.accept(server_socket)
    serve_function = fn -> serve client_socket end
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, serve_function)
    :ok = :gen_tcp.controlling_process(client_socket, pid)
    accept_on server_socket
  end

  def serve(client_socket) do
    message =
    with {:ok, data} <- read_line(client_socket),
      {:ok, command} <- KVServer.Command.parse(data),
      do: KVServer.Command.run(command, KV.Registry)

    write_line(client_socket, message)
    serve client_socket
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "UKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # The connection was closed, exit politely
    exit(:shutdown)
  end

  defp write_line(socket, {:error, :not_found}) do
    :gen_tcp.send(socket, "NOT FOUND\r\n")
  end

  defp write_line(socket, {:error, error}) do
    # Unknown error; write to the client and exit
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
