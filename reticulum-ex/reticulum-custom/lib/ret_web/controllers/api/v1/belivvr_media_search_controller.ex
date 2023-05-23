defmodule RetWeb.Api.V1.BelivvrMediaSearchController do
  use RetWeb, :controller
  use Retry

  def index(conn, %{"source" => "rooms"} = params) do
    {:commit, results} =
      %Ret.BelivvrMediaHubSearchQuery{
        source: "rooms",
        cursor: params["cursor"] || "0",
        page_size: params["page_size"] || "10",
        scene_sid: params["scene_sid"],
        hub_sids: params["hub_sids"]
      }
      |> Ret.BelivvrMediaSearch.search()

    conn |> render("index.json", results: results)
  end

  def index(conn, %{"source" => "scenes", "user" => user} = params) do
    account = conn |> Guardian.Plug.current_resource()
    allow_remixing = Map.get(params, "allow_remixing", nil)

    if account && account.account_id == String.to_integer(user) do
      {:commit, results} =
        %Ret.BelivvrMediaHubSearchQuery{
          source: "scenes",
          cursor: params["cursor"] || "1",
          page_size: params["page_size"] || "10",
          account_id: account.account_id,
          allow_remixing: allow_remixing
        }
        |> Ret.BelivvrMediaSearch.search()

      conn |> render("index.json", results: results)
    else
      conn |> send_resp(401, "You can only search scenes by user for your own account.")
    end
  end

end