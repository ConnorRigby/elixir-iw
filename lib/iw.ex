defmodule Iw do
  def iw do
    Application.app_dir(:iw, ["priv", "usr", "sbin", "iw"])
  end

  def ap_scan(ifname) do
    case System.cmd(iw(), ["dev", ifname, "scan", "ap-force"]) do
      {output, 0} -> parse_scan(output)
      _ -> []
    end
  end

  def parse_scan(output) do
    [_ | rest] =
      Regex.split(~r/BSS ([0-9a-f]{2}[:-]){5}([0-9a-f]{2})\(.*\)/, output, include_captures: true)

    rest
    |> Enum.chunk_every(2)
    |> Map.new(fn [bssid, output] ->
      bssid = bssid(bssid)
      {bssid, ap(bssid, output)}
    end)
  end

  def ap(bssid, output) do
    ssid = ssid(output)
    frequency = frequency(output)
    signal_dbm = signal_dbm(output)
    flags = flags(output)
    if Code.ensure_loaded?(VintageNet.WiFi.AccessPoint) do
      apply(VintageNet.WiFi.AccessPoint, :new, [bssid, ssid, frequency, signal_dbm, flags])
    else
      %{
        bssid: bssid,
        ssid: ssid,
        frequency: frequency,
        signal_dbm: signal_dbm,
        flags: flags
      }
    end
  end

  def bssid(output) do
    case Regex.run(~r/BSS ([0-9a-f]{2}[:-]){5}([0-9a-f]{2})/, output) do
      ["BSS " <> bssid | _] -> bssid
      _ -> nil
    end
  end

  def ssid(output) do
    case Regex.run(~r/SSID: (.*)/, output) do
      [_, "" | _] -> nil
      [_, ssid | _] -> ssid
      _ -> nil
    end
  end

  def signal_dbm(output) do
    case Regex.run(~r/signal: ([-+]?([0-9]*\.[0-9]+|[0-9]+))/, output) do
      [_, signal | _] ->
        {dbm, _} = Integer.parse(signal)
        dbm

      _ ->
        nil
    end
  end

  def flags(output) do
    case Regex.run(~r/Authentication suites: (.*)/, output) do
      [_, "PSK"] -> [:wpa2_psk_ccmp, :ess]
      [_, "IEEE 802.1X"] -> [:wpa2_eap_ccmp, :ess]
      _ -> []
    end
  end

  def frequency(output) do
    case Regex.run(~r/freq: (.*)/, output) do
      [_, freq | _] -> String.to_integer(freq)
      _ -> nil
    end
  end
end
