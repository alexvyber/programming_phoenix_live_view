#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.Pento.Shape do
  use Phoenix.Component
  alias PentoWeb.Pento.Point

  def draw(assigns) do
    ~H"""
      <%= for {x, y} <- @points do %>
      <Point.draw
        x={ x }
        y={ y }
        fill={ @fill }
        name={ @name } />
      <% end %>
    """
  end
end
