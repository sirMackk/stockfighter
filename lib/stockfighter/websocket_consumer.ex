defmodule Stockfighter.WebsocketConsumer do
  require Logger

  def run(url, callback) do
    {domain, path} = parse_url(url)
    socket = Socket.Web.connect!(domain, path: path, secure: true)
    spawn_link(Stockfighter.WebsocketConsumer, :listen, [url, socket, self])

    process(callback)
  end

  def process(callback) do
    receive do
      {:ok, data} ->
        spawn(fn -> callback.(data) end)
      {:ping} ->
        Logger.info("Pong")
      {:error, _, url} ->
        run(url, callback)
    end
    process(callback)
  end

  defp recv(socket) do
    try do
      Socket.Web.recv!(socket)
    rescue
      e in RuntimeError -> {:error, e}
    end
  end

  def listen(url, socket, pid) do
    case recv(socket) do
      {:text, data} ->
        send(pid, {:ok, data})
      {:ping, _} ->
        Logger.info("Ping!")
        Socket.Web.send!(socket, {:pong, ""})
        send(pid, {:ping})
      {:error, e} ->
        Logger.warn("Websocket died because: #{inspect(e)}. Attempting to restart")
        send(pid, {:error, e, url})
        exit(:died)
    end
    listen(url, socket, pid)
  end

  defp parse_url(url) do
    [domain | rest] = String.split(url, "/")
    {domain, "/" <> Enum.join(rest, "/")}
  end
end
