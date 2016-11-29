defmodule UmlHdxir.Extra do
  @moduledoc false

  alias UmlHdxir.Device
  alias UmlHdxir.StringClean
  alias UmlHdxir.HD.Detector

  def enrich_device_info(json, ua_string) do
    if json["Device"]["hd_ops"]["stop_on_detect"] != "1" do
      ua_string = StringClean.extra_clean(ua_string)
      platform_id = Detector.get_platform_by_user_agent(ua_string)
      platform_json =  platform_id |> build_filename() |> Device.read()
      json = add_platform_info(json, platform_json)

      browser_id = Detector.get_browser_by_user_agent(ua_string)
      browser_json = browser_id |> build_filename() |> Device.read()
      add_browser_info(json, browser_json)
    else
      json
    end
  end

  defp build_filename(nil), do: nil

  defp build_filename(id) do
    hd_folder = Application.get_env(:uml_hdxir, :hd_folder)
    "#{hd_folder}Extra_#{id}.json"
  end

  defp add_platform_info(device, specs) do
    if specs["hd_specs"]["general_platform"] != "" do
      device = put_in(device["Device"]["hd_specs"]["general_platform"], specs["Extra"]["hd_specs"]["general_platform"])
      put_in(device["Device"]["hd_specs"]["general_platform_version"], specs["Extra"]["hd_specs"]["general_platform_version"])
    else
      device
    end
  end

  defp add_browser_info(device, specs) do
    if specs["hd_specs"]["general_browser"] != "" do
      device = put_in(device["Device"]["hd_specs"]["general_browser"], specs["Extra"]["hd_specs"]["general_browser"])
      put_in(device["Device"]["hd_specs"]["general_browser_version"], specs["Extra"]["hd_specs"]["general_browser_version"])
    else
      device
    end
  end
end
