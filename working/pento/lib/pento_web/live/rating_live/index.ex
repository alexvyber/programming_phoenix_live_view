defmodule PentoWeb.RatingLive.Index do
  use PentoWeb, :live_component

  def ratings_complete?(products) do
    Enum.all?(products, fn product ->
      length(product.ratings) == 1
    end)
  end

  def render(assigns) do
    IO.inspect(assigns.products, label: :products_shit)

    ~H"""
    <h2>Ratings <%= if ratings_complete?(assigns.products) do "Yes" else "No" end %> </h2>

    <%= for {product, index } <- Enum.with_index(assigns.products) do %>
      <%= if rating = List.first(product.ratings) do %>

        <%= live_component @socket,
          PentoWeb.RatingLive.Show,
          rating: rating,
          product: product
        %>

      <% else %>

      <%= live_component @socket,
        PentoWeb.RatingLive.FormComponent,
        user: @current_user,
        product: product,
        product_index: index,
        id: "product-#{product.id}-form"
      %>

      <% end %>

      <% end %>
    """
  end
end
