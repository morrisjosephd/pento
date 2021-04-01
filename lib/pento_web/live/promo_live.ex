defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> assign_changeset()}
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
    send_promo(socket, recipient_params)
  end

  defp send_promo(socket, recipient_params) do
    case Promo.send_promo(socket.assigns.recipient, recipient_params) do
      {:ok, _email} ->
        {:noreply,
         socket
         |> put_flash(:info, "Promo code sent")
         |> push_redirect(to: Routes.product_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  defp assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end
end
