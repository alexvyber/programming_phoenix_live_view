defmodule PentoWeb.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart_live

  alias Pento.Catalog

  alias Contex.Plot

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_gender_filter()
      |> assign_age_group_filter()
      |> pipe_through_assigns()
    }
  end

  def pipe_through_assigns(socket) do
    socket
    |> assign_products_with_average_ratings()
    |> assign_dataset()
    |> assign_chart()
    |> assign_chart_svg()
  end

  defp assign_products_with_average_ratings(
         %{
           assigns: %{
             age_group_filter: age_group_filter,
             gender_filter: gender_filter
           }
         } = socket
       ) do
    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: gender_filter
      })
    )
  end

  def assign_gender_filter(%{assigns: %{gender_filter: gender_filter}} = socket) do
    assign(socket, :gender_filter, gender_filter)
  end

  def assign_gender_filter(socket) do
    assign(socket, :gender_filter, "all")
  end

  def assign_gender_filter(socket, gender_filter) do
    assign(socket, :gender_filter, gender_filter)
  end

  defp assign_age_group_filter(%{assigns: %{age_group_filter: _age_group_filter}} = socket) do
    socket
  end

  defp assign_age_group_filter(socket) do
    assign(socket, age_group_filter: "all")
  end

  defp assign_age_group_filter(socket, age_group_filter) do
    assign(socket, :age_group_filter, age_group_filter)
  end

  def assign_dataset(
        %{
          assigns: %{
            products_with_average_ratings: products_with_average_ratings
          }
        } = socket
      ) do
    socket
    |> assign(
      :dataset,
      make_bar_chart_dataset(products_with_average_ratings)
    )
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(
      :chart_svg,
      render_bar_chart(
        chart,
        title(),
        subtitle(),
        x_axis(),
        y_axis()
      )
    )
  end

  def handle_event("gender_filter", %{"gender_filter" => gender_filter}, socket) do
    {:noreply,
     socket
     |> assign_gender_filter(gender_filter)
     |> pipe_through_assigns()}
  end

  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> pipe_through_assigns()}
  end

  # defp render_bar_chart(chart) do
  #   Contex.Plot.new(500, 400, chart)
  #   |> Plot.titles(title(), subtitle())
  #   |> Plot.axis_labels(x_axis(), y_axis())
  #   |> Plot.to_svg()
  # end

  defp title do
    "Product Ratings"
  end

  defp subtitle do
    "average star ratings per product"
  end

  defp x_axis do
    "products"
  end

  defp y_axis do
    "stars"
  end

  defp get_products_with_average_ratings(filter) do
    case Catalog.products_with_average_ratings(filter) do
      [] ->
        Catalog.products_with_zero_ratings()

      products ->
        products
    end
  end

  # defp make_bar_chart(dataset) do
  #   Contex.BarChart.new(dataset)
  # end

  # defp make_bar_chart_dataset(data) do
  #   Contex.Dataset.new(data)
  # end

  def rendera(assigns) do
    ~H"""
    <main>

    <form phx-change="age_group_filter" phx-target={ @myself }>
    <label>Filter by age group:</label>
    <select name="age_group_filter" id="age_group_filter">
    <%= for age_group <-
    ["all", "18 and under", "18 to 25", "25 to 35", "35 and up"] do %>
    <option
    value={ age_group }
       selected={ if @age_group_filter == age_group, do: "selected" }
      >
    <%=age_group%>
    </option>
    <% end %>
    </select>
    </form>

    <section class="row">
    <h1>Survey Results</h1>
    </section>

    <%= for { product, rating } <- @products_with_average_ratings do %>
      <p><%= product %> - <%= rating %></p>
    <% end %>


    <div id="survey-results-chart">
    <%= @chart_svg %>
    </div>

    </main>
    """
  end

  def render(assigns) do
    ~H"""
      <section>
    <h1>Survey Results</h1>
    <div id="survey-results-component">
    <div class="container">
    <div>
    <.form
      for={:gender_filter}
      phx-change="gender_filter"
      phx_target={@myself}
      id={@id}>

      <label>Filter by gender:</label>
      <select name="gender_filter" id="gender_filter">
        <%= for gender <- ["all", "female", "male"] do %>
          <option value={ gender } selected = {@gender_filter == gender} >
            <%= gender %>
          </option>
        <% end %>
      </select>
    </.form>
    </div>
    <div>
     <.form
       for={:age_group_filter}
       phx-change="age_group_filter"
       phx_target={@myself}
       id={@id}>

        <label>Filter by age group:</label>
        <select name="age_group_filter" id="age_group_filter">
          <%= for age_group <-
                ["all", "18 and under", "18 to 25", "25 to 35", "35 and up"] do %>
            <option
              value={ age_group }
              selected = {@age_group_filter == age_group} >
                <%=age_group%>
            </option>
          <% end %>
        </select>
      </.form>
    </div>
    </div>
    <div id="survey-results-chart">
    <%= @chart_svg %>
    </div>
    </div>
    </section>

    """
  end
end
