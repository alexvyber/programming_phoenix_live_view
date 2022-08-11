defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string
    has_many :ratings, Pento.Survey.Rating

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.1)
  end

  @doc false
  def unit_price_changeset(product, attrs) do
    initial_unit_price = product.unit_price

    product
    |> cast(attrs, [:unit_price])
    |> validate_required([:unit_price])
    |> validate_number(:unit_price, less_than: initial_unit_price)
  end
end
