defmodule ReadPgWeb.QueryController do
  use ReadPgWeb, :controller
  alias ReadPg.GetData
  alias ReadPg.RepoTask

  def query(conn, _params) do
    %{"sql" => sql, "database" => database} = Map.merge(%{"sql" => "", "database" => "drg_prod"}, conn.params)
    sql = GetData.parse_sql(sql)

    result = cond do
        is_nil(sql) ->
          %{data: [], msg: "无法解析SQL", query: sql, is_success: false}
        database == "drg_prod" ->
          GetData.query(sql)
        true ->
          GetData.query(sql, database)
      end

    json conn, result
  end

  def query_task(conn, _params) do
    %{"sql" => sql, "database" => database} = Map.merge(%{"sql" => "", "database" => "drg_prod"}, conn.params)

    Task.start_link(fn () -> RepoTask.start(sql) end)

    json conn, %{is_success: true, msg: "任务创建成功"}
  end

  def connect_test(conn, _params) do
    time = case ReadPg.ets_get(:app, :start_time) do
        nil -> ""
        time -> time
      end
    json conn, %{data: time}
  end

end
