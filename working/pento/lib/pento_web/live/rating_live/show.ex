defmodule PentoWeb.RatingLive.Show do
  use PentoWeb, :live_component

  def render(assigns) do
    ~H"""
    <%= @product.name %>
    <%= raw render_rating_stars(@rating.stars) %>
    """
  end

  def render_rating_stars(stars) do
    filled_stars(stars)
    |> Enum.concat(unfilled_stars(stars))
    |> Enum.join(" ")
  end

  def filled_stars(stars) do
    List.duplicate("<span>$</span>", stars)
  end

  def unfilled_stars(stars) do
    List.duplicate("<span>_</span>", 5 - stars)
  end
end
