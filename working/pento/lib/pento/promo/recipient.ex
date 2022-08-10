defmodule Pento.Promo.Recipient do
  @types %{first_name: :string, email: :string}
  defstruct [:first_name, :email]

  alias Pento.Promo.Recipient
  import Ecto.Changeset

  def changeset(%Recipient{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    # |> validate_required(Map.keys(@types))
    |> validate_format(:email, ~r/@/)
  end
end
