defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.{Catalog, Accounts, Survey}

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {
      :ok,
      socket
      |> assign_user(token)
    }
  end

  defp assign_user(socket, token) do
    IO.puts("Assign User with socket.private:")
    IO.inspect(socket.private, label: :shit_shit)

    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

  def render(assigns) do
    ~H"""
    <section class="row">
      <%= live_component @socket, PentoWeb.DemographicLive.FormComponent,
        content: "Hello Dem Component",
        user: @current_user
      %>
    </section>
    """
  end
end
