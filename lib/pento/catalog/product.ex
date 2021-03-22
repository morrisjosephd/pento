defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_number(:unit_price, greater_than: 0.0)
    |> unique_constraint(:sku)
  end

  def markdown_product_changeset(product, amount) do
    product
    |> change()
    |> require_price_marked_down(amount)
  end

  defp require_price_marked_down(changeset, amount) do
    {:data, current_price} = fetch_field(changeset, :unit_price)
    new_price = current_price - amount

    if new_price < current_price do
      changeset
      |> change(unit_price: new_price)
    else
      changeset
      |> add_error(:unit_price, "Marked down price must be less than unit price")
    end
  end
end
