defmodule PentoWeb.AdminDashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  # { UserActivityLive, ProductSalesLive}
  alias PentoWeb.SurveyResultsLive
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
    end

    {
      :ok,
      socket
      |> assign(:survey_results_component_id, "survey-results")
      |> assign(:survey_results_component_id, "survey-results")
      |> assign(:user_activity_component_id, "user-activity")
    }
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      PentoWeb.UserActivityLive,
      id: socket.assigns.user_activity_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="row">
    <h1>Admin Dashboard</h1>
    </section>

    <%= live_component @socket,
      PentoWeb.SurveyResultsLive,
      id: @survey_results_component_id
    %>


      <%= live_component @socket,
    PentoWeb.UserActivityLive,
    id: @user_activity_component_id %>
    """
  end
end
