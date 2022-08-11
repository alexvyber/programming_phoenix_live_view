defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()}
  end

  def assign_demographic(%{assigns: %{user: user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: user.id})
  end

  def assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end

  def render(assigns) do
    ~H"""
    <div class="hero"> <%= @content %></div>
    <.form
      class="column"
      let={f}
      for={@changeset}
    phx_submit="save"
    id="demographic-form">

    <%= label f, :gender %>
    <%= select f, :gender, ["female", "male", "other", "prefer not to say"] %>
    <%= error_tag f, :gender %>

    <%= label f, :year_of_birth %>
    <%= select f, :year_of_birth, Enum.reverse(1940..2020)%>
    <%= error_tag f, :year_of_birth %>

    <%= hidden_input f, :user_id %>
    <%= submit "Save", phx_disable_with: "Saving..." %>

    </.form>
    """
  end
end
