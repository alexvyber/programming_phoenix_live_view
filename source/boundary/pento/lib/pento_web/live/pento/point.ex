#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.Pento.Point do
  use Phoenix.Component

  @width 10

def draw(assigns) do
  ~H"""
    <use xlink:href="#point"
      x={ convert(@x) }
      y={ convert(@y) }
      fill={ @fill }
      phx-click="pick"
      phx-value-name={ @name }
      phx-target="#game" />
  """
end

  defp convert(i) do
    (i-1) * @width + 2 * @width
  end
end
