#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.SurveyLive.Component do
  use Phoenix.Component

  def hero(assigns) do
    ~H"""
    <h2>
      content: <%= @content %>
    </h2>
    <h3>
      slot: <%= render_slot(@inner_block) %>
    </h3>
    """
  end
end
