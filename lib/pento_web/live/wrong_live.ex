defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView

  @message "Guess a number"
  @winning_message "You win"
  @losing_message "You lose"
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: @message,
       winning_number: winning_number()
     )}
  end

  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
    <%= @message %>
    </h2>
    <h2>
    <%= for n <- 1..10 do %>
    <a href='#' phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
    <% end %>
    </h2>
    <a href='#' phx-click="reset">Reset</a>
    """
  end

  def winning_number() do
    Enum.random(1..10)
  end

  def numbers_match(guess, socket) do
    guess == socket.assigns.winning_number |> to_string()
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    score = socket.assigns.score

    if numbers_match(guess, socket) do
      {:noreply, assign(socket, score: score + 1, message: @winning_message)}
    else
      {:noreply, assign(socket, score: score - 1, message: @losing_message)}
    end
  end

  def handle_event("reset", _data, socket) do
    {:noreply, assign(socket, score: 0, message: @message, winning_number: winning_number())}
  end
end
