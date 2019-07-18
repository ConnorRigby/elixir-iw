# Iw
Simple mix project to cross compile iw on Nerves based devices.

```elixir
def deps do
  [
    {:iw, "~> 0.2.0", targets: @all_targets}
  ]
end
```

## Usage

```elixir
iex> Iw.ap_scan("wlan0")
%{
    "f6:f2:6d:ce:45:44" => %VintageNet.WiFi.AccessPoint{
    band: :wifi_5_ghz,
    bssid: "f6:f2:6d:ce:45:44",
    channel: 149,
    flags: [:wpa2_psk_ccmp, :ess],
    frequency: 5745,
    signal_dbm: -53,
    signal_percent: 94,
    ssid: "FarmBotHQ-hub"
  },
  "f6:f2:6d:ce:4f:18" => %VintageNet.WiFi.AccessPoint{
    band: :wifi_2_4_ghz,
    bssid: "f6:f2:6d:ce:4f:18",
    channel: 6,
    flags: [:wpa2_psk_ccmp, :ess],
    frequency: 2437,
    signal_dbm: -47,
    signal_percent: 82,
    ssid: "FarmBotHQ-hub"
  }
}
```