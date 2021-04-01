defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(%Recipient{} = recipient, attrs) do
    changeset = Recipient.changeset(recipient, attrs)

    case changeset.valid? do
      true -> {:ok, "some email"}
      _ -> {:error, changeset}
    end
  end
end
