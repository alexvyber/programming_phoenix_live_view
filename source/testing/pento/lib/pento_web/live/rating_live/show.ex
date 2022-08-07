#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.RatingLive.Show do
  use Phoenix.Component
  use Phoenix.HTML

  def stars(assigns) do
    stars =
      filled_stars(assigns.rating.stars)
      |> Enum.concat(unfilled_stars(assigns.rating.stars))
      |> Enum.join(" ")

    ~H"""
    <div>
      <h4>
        <%= @product.name %>:<br/>
        <%= raw stars %>
      </h4>
    </div>
    """
  end

  def filled_stars(stars) do
    List.duplicate("&#x2605;", stars)
  end

  def unfilled_stars(stars) do
    List.duplicate("&#x2606;", 5 - stars)
  end

end
