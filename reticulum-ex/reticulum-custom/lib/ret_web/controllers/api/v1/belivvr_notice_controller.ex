defmodule RetWeb.Api.V1.BelivvrNoticeController do
  use RetWeb, :controller

  # Limit to 1 TPS
  plug RetWeb.Plugs.RateLimit

  def create(conn, payload) do
    RetWeb.Endpoint.broadcast("belivvr", "all", payload)
    conn |> send_resp(200, "")
  end

  def create_by_scene_id(conn, payload) do
    RetWeb.Endpoint.broadcast("belivvr", conn.params["scene_id"], payload)
    conn |> send_resp(200, "")
  end

  def create_by_hub_id(conn, payload) do
    RetWeb.Endpoint.broadcast("belivvr", conn.params["hub_id"], payload)
    conn |> send_resp(200, "")
  end
end