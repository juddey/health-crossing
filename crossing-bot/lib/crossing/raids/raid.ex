defmodule Crossing.Raids.Raid do
  use Ecto.Schema
  import Ecto.Changeset

  schema "raids" do
    field :deleted_at, :utc_datetime
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :player_limit, :integer
    field :completion_percentage, :float
    field :active, :boolean
    belongs_to :raid_bosses, Crossing.Raids.RaidBoss

    timestamps()
  end

  @doc false
  def changeset(raid, attrs) do
    raid
    |> cast(attrs, [
      :player_limit,
      :start_time,
      :end_time,
      :deleted_at,
      :raid_bosses_id,
      :completion_percentage,
      :active
    ])
    |> validate_required([])
  end
end
