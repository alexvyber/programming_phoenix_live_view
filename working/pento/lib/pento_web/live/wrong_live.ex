defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number!",
        time: time(),
        user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"],
        answer: answer()
      )
    }
  end

  def handle_params(_params, _uri, socket) do
    {:noreply,
     assign(socket,
       score: 0,
       message: "New game started! Guess a number!",
       time: time(),
       answer: answer()
     )}
  end

  @impl true
  def handle_event("guess", %{"number" => guess} = data, socket) do
    {message, score} =
      cond do
        String.to_integer(guess) == socket.assigns.answer ->
          {"You guessed right! The number is #{guess}", socket.assigns.score + 100}

        true ->
          {"Your guess: #{guess}. Wrong! Try again! #{guess == socket.assigns.answer}",
           socket.assigns.score - 1}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time()
      )
    }
  end

  defp time, do: DateTime.utc_now() |> to_string()
  defp answer, do: 1..10 |> Enum.random()

  def render(assigns) do
    ~H"""
    <h1>Score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <h5>It's <%= time() %></h5>
    <h5>Another time <%= @time %></h5>

    <main style="padding: 20px 0">
      <%= for n <- 1..10 do %>
        <a style=" background: blue; padding: 10px 20px; color: white" href="#" phx-click="guess" phx-value-number={n} phx-value-shit={ "shit_#{n}" }> <%= n %></a>
        <% end %>
      </main>
      <%= live_patch "New Game", to: Routes.live_path(@socket, PentoWeb.WrongLive ) %>

      <aside style="margin-top: 60px;">
        <h3><%= @user.email %></h3>
        <h3><%= @session_id %></h3>
      </aside>
    """
  end
end
