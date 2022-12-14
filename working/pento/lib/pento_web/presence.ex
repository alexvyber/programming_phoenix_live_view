defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence

  @user_activity_topic "user_activity"

  def track_user(pid, product, token) do
    user = Pento.Accounts.get_user_by_session_token(token)

    case Presence.get_by_key(@user_activity_topic, product.name) do
      [] ->
        Presence.track(
          pid,
          @user_activity_topic,
          product.name,
          %{users: [%{email: user.email}]}
        )

      %{users: active_users_for_product} ->
        Presence.update(pid, @user_activity_topic, product.name, %{
          users: [active_users_for_product | %{email: user.email}]
        })
    end
  end
end
