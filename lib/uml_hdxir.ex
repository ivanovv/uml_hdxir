defmodule UmlHdxir do
  use Application

  alias UmlHdxir.HD.Detector

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(UmlHdxir.Endpoint, []),
      # Start your own worker by calling: UmlHdxir.Worker.start_link(arg1, arg2, arg3)
      # worker(UmlHdxir.Worker, [arg1, arg2, arg3]),
      worker(UmlHdxir.DeviceCache.Cache, [[name: UmlHdxir.DeviceCache.Cache]]),
      :poolboy.child_spec(:device_detector0, poolboy_device0_config, [["user-agent0.json"]]),
      :poolboy.child_spec(:device_detector1, poolboy_device1_config, [["user-agent1.json"]]),
      :poolboy.child_spec(:platform_detector, poolboy_platform_config, [["user-agentplatform.json"]]),
      :poolboy.child_spec(:browser_detector, poolboy_browser_config, [["user-agentbrowser.json"]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UmlHdxir.Supervisor]
    Supervisor.start_link(children, opts)
  end


  defp poolboy_device0_config do
    [{:name, {:local, :device_detector0}},
      {:worker_module, Detector},
      {:size, :erlang.system_info(:schedulers_online)},
      {:max_overflow, 0}]
  end

  defp poolboy_device1_config do
    [{:name, {:local, :device_detector1}},
      {:worker_module, Detector},
      {:size, :erlang.system_info(:schedulers_online)},
      {:max_overflow, 0}]
  end

  defp poolboy_platform_config do
    [{:name, {:local, :platform_detector}},
      {:worker_module, Detector},
      {:size, :erlang.system_info(:schedulers_online)},
      {:max_overflow, 0}]
  end

  defp poolboy_browser_config do
    [{:name, {:local, :browser_detector}},
      {:worker_module, Detector},
      {:size, :erlang.system_info(:schedulers_online)},
      {:max_overflow, 0}]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UmlHdxir.Endpoint.config_change(changed, removed)
    :ok
  end
end
