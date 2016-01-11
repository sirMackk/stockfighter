defmodule Stockfighter.WebsocketConsumer do
  require Logger

  def run(url, callback) do
    {domain, path} = parse_url(url)
    socket = Socket.Web.connect!(domain, path: path, secure: true)
    pid = spawn(Stockfighter.WebsocketConsumer, :listen, [url, socket, callback])

    send(pid, {:listen, self})
    process(pid, callback)
  end

  def process(pid, callback) do
    receive do
      {:ok, data} ->
        callback.(data)
      {:ping} ->
        Logger.info("Pong")
    end
    send(pid, {:listen, self})
    process(pid, callback)
  end

  defp recv(socket) do
    try do
      Socket.Web.recv!(socket)
    rescue
      e in RuntimeError -> {:error, e}
    end
  end

  def listen(url, socket, callback) do
    receive do
      {:listen, pid} ->
        case recv(socket) do
          {:text, data} ->
            send(pid, {:ok, data})
          {:ping, _} ->
            Logger.info("Ping!")
            Socket.Web.send!(socket, {:pong, ""})
            send(pid, {:ping})
          {:error, e} ->
            Logger.warn("Websocket died because: #{e}. Attempting to restart")
            run(url, callback)
            exit(:died)
        end
      {:shutdown} ->
        Socket.Web.close(socket)
        exit(:died)
    end
    listen(url, socket, callback)
  end

  defp parse_url(url) do
    [domain | rest] = String.split(url, "/")
    {domain, "/" <> Enum.join(rest, "/")}
  end
end
