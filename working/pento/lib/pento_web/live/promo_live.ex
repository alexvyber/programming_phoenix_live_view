defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  require Logger

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> assign_changeset()}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    :timer.sleep(1000)
    # ...
  end

  def render(assigns) do
    ~H"""
    <h1>Promo Stuff</h1>


    <.form
    let={f}
    for={@changeset}
    id="promo-form"
     phx-change="validate"
    phx-submit="save">

    <%= label f, :first_name %>
    <%= text_input f, :first_name %>
    <%= error_tag f, :first_name %>
    <%= label f, :email %>
    <%= text_input f,  :email, phx_debounce: "blur"%>
    <%= error_tag f, :email %>
    <%= submit "Send Promo"  , phx_disable_with: "Sending..." %>
    </.form>
    """
  end
end
