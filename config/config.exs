# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

key = Path.join(System.user_home!(), ".ssh/id_rsa.pub")
unless File.exists?(key), do: Mix.raise("No SSH Keys found. Please generate an ssh key")

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(key)
  ]

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

config :nerves_init_gadget,
  ifname: "eth0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: "kiosk",
  node_host: :mdns_domain,
  ssh_console_port: 22

config :webengine_kiosk,
  uid: "kiosk",
  gid: "kiosk",
  data_dir: "/root/kiosk",
  homepage: "http://localhost:80"

config :sketchpad, SketchpadWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "BCqHloAfzORpn/TX90PB9GULWVRZpjwegD4U8T1on/RUmEYTjkVGLC2YKFhkhLiS",
  server: true,
  render_errors: [view: SketchpadWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sketchpad.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false,
  check_origin: false
  # pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],

config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason

# config :sketchpad, SketchpadWeb.Endpoint,
#   http: [port: 4000],
#   debug_errors: true,
#   code_reloader: true,
#   check_origin: false,
#   watchers: [node: ["node_modules/webpack/bin/webpack.js", "--mode", "development", "--watch-stdin", "--colors",
#                     cd: Path.expand("../assets", __DIR__)]]

# # Watch static and templates for browser reloading.
# config :sketchpad, SketchpadWeb.Endpoint,
#   live_reload: [
#     patterns: [
#       ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
#       ~r{priv/gettext/.*(po)$},
#       ~r{web/views/.*(ex)$},
#       ~r{web/templates/.*(eex)$}
#     ]
#   ]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
