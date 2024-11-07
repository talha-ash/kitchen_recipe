defmodule KitchenRecipe.Accounts.UserFollower do
  use Ecto.Schema
  import Ecto.Changeset
  alias KitchenRecipe.Accounts.User

  schema "user_followers" do
    belongs_to :follower, User, foreign_key: :follower_user_id
    belongs_to :followed, User, foreign_key: :followed_user_id

    timestamps(type: :utc_datetime)
  end

  def changeset(user_follower, attrs) do
    user_follower
    |> cast(attrs, [:follower_user_id, :followed_user_id])
    |> validate_required([:follower_user_id, :followed_user_id])
    |> unique_constraint([:follower_user_id, :followed_user_id])
  end
end
