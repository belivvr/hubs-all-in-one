defmodule RetWeb.BelivvrChannel do

  use RetWeb, :channel

  alias Ret.{Account, Statix}
  alias RetWeb.{Presence}

  def join("belivvr", %{"token" => token}, socket) do
    case Ret.Guardian.resource_from_token(token) do
      {:ok, %Account{} = account, _claims} ->
        socket
        |> Guardian.Phoenix.Socket.put_current_resource(account)
        |> handle_join()

      {:error, reason} ->
        {:error, %{message: "Sign in failed", reason: reason}}
    end
  end

  def join("belivvr", %{}, socket) do
    socket |> handle_join()
  end

  defp handle_join(socket) do
    Statix.increment("ret.belivvr.channels.joins.ok")

    send(self(), {:begin_tracking, socket.assigns.session_id})
    {:ok, %{session_id: socket.assigns.session_id}, socket}
  end
end