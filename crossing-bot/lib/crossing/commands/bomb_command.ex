defmodule Crossing.Commands.Bomb do
  alias Crossing.Users

  def invoke(msg) do
    # I'd use a with clause here to make things easier
    # First, you group all your success clauses
    with user <- Users.get_user_by_discord_id(msg.author.id |> Integer.to_string()),
         {:ok, _user} <- Users.delete_user(%Crossing.Users.User{id: user.id}) do
      # And here, you can fire your success logic
      Nostrum.Api.create_message!(msg.channel_id, """
      Your account and data has been thoroughly deleted. Like as in, I don't know you know anymore.
      """)
    else
      ## Then you can pattern match on any error result from the with function
      {:error, reason} ->
        {:error, reason}

      _ ->
        nil
    end
    # >>> Just wanted to comment on this function..
    # Users.get_user_by_discord_id(msg.author.id |> Integer.to_string())
    # this functon currently returns nil, thats ok, but in order to use the
    # pattern matching in with to its full you might want to think about returning
    # {error, message}.
    # The other option is to turn the function into a !(bang) function using  Repo.get_by! which
    # will raise an Ecto Noresults found struct, which you can then match on.
    # its an elixir convention to use the ! at the end of the function name though when you do this
    # e.g. Users.get_user_by_discord_id!()

    case Users.get_user_by_discord_id(msg.author.id |> Integer.to_string()) do
      nil ->
        nil

      user ->
        case Users.delete_user(%Crossing.Users.User{id: user.id}) do
          {:ok, _user} ->
            Nostrum.Api.create_message!(msg.channel_id, """
            Your account and data has been thoroughly deleted. Like as in, I don't know you know anymore.
            """)

          _ ->
            nil
        end
    end
  end
end
