defmodule UmlHdxir.DetectController do
  use UmlHdxir.Web, :controller

  alias UmlHdxir.Device
  alias UmlHdxir.DeviceCache.Cache

  def index(conn, %{"ua" => user_agent}) do
#    device = Cache.fetch(user_agent, fn ->
#      Device.get_device_by_user_agent(user_agent)
#    end)
    device = Device.get_device_by_user_agent(user_agent)
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> text(device)
  end
  
end
