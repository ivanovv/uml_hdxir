defmodule UmlHdxir.Device do

  @moduledoc false

  alias UmlHdxir.Extra
  alias UmlHdxir.StringClean
  alias UmlHdxir.DeviceCache.Cache
  alias UmlHdxir.HD.Detector

  def get_device_by_user_agent(ua_string) do
    id = ua_string |> StringClean.clean |> Detector.get_device_by_user_agent
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

  defp build_filename(nil), do: nil

  defp build_filename(id) do
    hd_folder = Application.get_env(:uml_hdxir, :hd_folder)
    "#{hd_folder}Device_#{id}.json"
  end

  defp read_device_info(nil, _), do: %{error: true, data: %{status: 0, message: "OK"}}

  defp read_device_info(id, ua_string) do
    id
    |> build_filename()
    |> read()
    |> Extra.enrich_device_info(ua_string)
    |> format_response()
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
