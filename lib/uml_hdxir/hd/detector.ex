defmodule UmlHdxir.HD.Detector do
  @moduledoc false
  
  use GenServer

  def start_link(filename, opts \\ []) do
    GenServer.start_link(__MODULE__, filename, opts)
  end

  def init(filename) do
    {:ok, data} = File.read(filename)
    list = ExJSON.parse(data)
    {:ok, list}
  end


  def get_device_by_user_agent(""), do: nil
  def get_device_by_user_agent(nil), do: nil

  def get_device_by_user_agent(user_agent) do
    result = :poolboy.transaction(:device_detector0, fn(pid) -> GenServer.call(pid, {:match, user_agent}) end, :infinity)
    case result do
      nil -> :poolboy.transaction(:device_detector1, fn(pid) -> GenServer.call(pid, {:match, user_agent}) end, :infinity)
      _   -> result
    end
  end

  def get_platform_by_user_agent(user_agent) do
    :poolboy.transaction(:platform_detector, fn(pid) -> GenServer.call(pid, {:match, user_agent}) end, :infinity)
  end

  def get_browser_by_user_agent(user_agent) do
    :poolboy.transaction(:browser_detector, fn(pid) -> GenServer.call(pid, {:match, user_agent}) end, :infinity)
  end


  def handle_call({:match, ua_string}, _from, list) do
    result = Enum.find_value(list, fn t -> find_match(t, ua_string) end)
    {:reply, result, list}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  defp find_match(tuple, ua_string) do
    list = elem(tuple, 1)
    keys = Keyword.keys(list)
    Enum.find_value(keys, fn key -> match_ua_string(list, key, ua_string) end)
  end

  defp match_ua_string(parent_list, key, ua_string) do
    if String.contains?(ua_string, key) do
      list = elem(List.keyfind(parent_list, key, 0), 1)
      match = Enum.find(list, fn {k, _v} -> String.contains?(ua_string, k) end)
      case match do
       nil     -> nil
       {_k, v} -> v
      end
    end
  end

end
