defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.{Catalog, Accounts, Survey}

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {
      :ok,
      socket
      |> assign_user(token)
      |> assign_demographic()
      |> assign_products()
    }
  end

  defp assign_user(socket, token) do
    IO.puts("Assign User with socket.private:")
    IO.inspect(socket.private, label: :shit_shit)

    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

  def assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:ifno, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp handle_rating_created(
         %{assigns: %{products: products}} = socket,
         updated_product,
         product_index
       ) do
    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      List.replace_at(products, product_index, updated_product)
    )
  end

  def render(assigns) do
    ~H"""
    <%= if @demographic do %>
      <h3>Demographics</h3>
      <ul>
        <li>Year: <%= @demographic.year_of_birth %></li>
        <li>Gender: <%= @demographic.gender %></li>
      </ul>

        <%= live_component @socket,
          PentoWeb.RatingLive.Index,
          products: @products,
          current_user: @current_user
        %>
    <% else %>
    <section class="row">
      <%= live_component @socket, PentoWeb.DemographicLive.FormComponent,
        content: "Hello Dem Component",
        user: @current_user,
        id: "demographic-form#{@current_user.id}"
      %>

    </section>
    <% end %>
    """
  end

  defp list_products(user) do
    Catalog.list_products_with_user_ratings(user)
  end
end
