defmodule UmlHdxir.Device do

  @moduledoc false

  alias UmlHdxir.Extra
  alias UmlHdxir.StringClean
  alias UmlHdxir.DeviceCache.Cache

  def get_device_by_user_agent(ua_string) do
    id = ua_string |> StringClean.clean |> UmlHdxir.HD.Detector.get_device_by_user_agent
    reply = read_device_info(id, ua_string)
    {:ok, response} = Poison.encode(reply)
    response
  end

  def read(nil), do: %{}

  def read(filename) do
    Cache.fetch(filename, fn ->
      {:ok, data} = File.read(filename)
      {:ok, map} = Poison.decode(data)
      map
    end)
  end

  defp build_filename(_, nil), do: nil

  defp build_filename(folder, id) do
    "#{folder}/Device_#{id}.json"
  end

  defp read_device_info(nil, _), do: %{ error: true, data: %{status: 0, message: "OK"} }

  defp read_device_info(id, ua_string) do
    filename = build_filename("/tmp/hd40store/", id)
    read(filename) |> Extra.enrich_device_info(ua_string) |> format_response
  end

  defp format_response(json) do
    %{
     error: false,
     data: %{
       status: 0,
       message: "OK",
       hd_specs: json["Device"]["hd_specs"]
     }
    }
  end

end
