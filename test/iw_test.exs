defmodule IwTest do
  use ExUnit.Case
  doctest Iw

  test "greets the world" do
    assert Iw.hello() == :world
  end
end
