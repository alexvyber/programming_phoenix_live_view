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

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    IO.puts("Handaling 'save' event")
    IO.inspect(demographic_params)
    {:noreply, save_demographic(socket, demographic_params)}
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  def render(assigns) do
    ~H"""
    <aside>
    <div class="hero"> <%= @content %></div>

    <.form
      class="column"
      let={f}
      phx_target={@myself}
      for={@changeset}
    phx_submit="save"
    id="demographic-form">

    <%= label f, :gender %>
    <%= select(f, :gender, Ecto.Enum.values(Pento.Survey.Demographic, :gender)) %>
    <%= error_tag f, :gender %>

    <%= label f, :year_of_birth %>
    <%= select f, :year_of_birth, Enum.reverse(1940..2020)%>
    <%= error_tag f, :year_of_birth %>

    <%= hidden_input f, :user_id %>
    <%= submit "Save", phx_disable_with: "Saving..." %>

    </.form>
    </aside>
    """
  end
end
