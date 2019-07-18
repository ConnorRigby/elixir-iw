defmodule Iw do
  def iw do
    Application.app_dir(:iw, ["priv", "usr", "sbin", "iw"])
  end
end
