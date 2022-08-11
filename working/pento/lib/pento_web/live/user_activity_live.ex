defmodule PentoWeb.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence
  @user_activity_topic "user_activity"

  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign_user_activity()}
  end

  defp assign_user_activity(socket) do
    presence_map = Presence.list(@user_activity_topic)

    user_activity =
      presence_map
      |> Enum.map(fn {product_name, _data} ->
        users =
          get_in(presence_map, [product_name, :metas])
          |> List.first()
          |> get_in([:users])

        {product_name, users}
      end)

    assign(socket, :user_activity, user_activity)
  end

  def render(assigns) do
    ~H"""
    <div class="user-activity-component">
    <h2>User Activity</h2>
    <p>Active users currently viewing games</p>
    <div>
    <%= for {product_name, users} <- @user_activity do %>
    <h3><%= product_name %></h3>
    <ul>
    <%= for user <- users do %>
    <li><%= user.email %> </li>
    <% end %>
    </ul>
    <% end %>
    </div>
    </div>
    """
  end
end
