defmodule ReadPg.RepoTask do
  alias ReadPg.Repo
  alias ReadPg.GetData

  def start(sql, task_id) do
    sql = GetData.parse_sql(sql)
    ReadPg.ets_put(:task, task_id, :start)
    case Repo.query(sql, [], [timeout: 1500000000000]) do
      {:ok, result} ->
        result = GetData.pgresult_to_map(result)
        result = %{data: result, msg: "", query: "", is_success: true}
        ReadPg.ets_put(:task, task_id, result)

      {:error, error} ->
        %{:postgres => %{:message => msg}, :query => query} = error
        result = %{data: [], msg: msg, query: query, is_success: false}
        ReadPg.ets_put(:task, task_id, result)
    end
  end

  def task_state(task_id) do
    case ReadPg.ets_get(:task, task_id) do
      nil ->
        %{msg: "查询不到任务", finish: false}
      :start ->
        %{msg: "正在查询", finish: false}
      _ ->
        %{msg: "查询完成", finish: false}
    end
  end
end
