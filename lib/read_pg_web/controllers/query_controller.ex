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
    %{"sql" => sql, "database" => _database, "task_id" => task_id} = Map.merge(%{"sql" => "", "database" => "drg_prod", "task_id" => nil}, conn.params)
    if task_id == nil do
      json conn, %{is_success: false, msg: "任务创建失败", task_id: task_id}
    else
      Task.start_link(fn () -> RepoTask.start(sql, task_id) end)
      json conn, %{is_success: true, msg: "任务创建成功", task_id: task_id}
    end
  end

  def query_task_state(conn, _params) do
    %{"task_id" => task_id} = Map.merge(%{"task_id" => nil}, conn.params)
    result = RepoTask.task_state(task_id)
    json conn, result
  end

  def connect_test(conn, _params) do
    time = case ReadPg.ets_get(:app, :start_time) do
        nil -> ""
        time -> time
      end
    json conn, %{data: time}
  end

end
