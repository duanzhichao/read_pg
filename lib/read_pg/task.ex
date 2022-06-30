defmodule ReadPg.RepoTask do
  alias ReadPg.Repo
  alias ReadPg.GetData

  def start(sql, task_id) do
    sql = GetData.parse_sql(sql)
    ReadPg.ets_put(:task, task_id, :start)
    case Repo.query(sql, [], [timeout: 1500000000000]) do
      {:ok, result} ->
        result = GetData.pgresult_to_map(result)
        result = %{data: result, msg: "查询完成", query: "", is_success: true}
        ReadPg.ets_put(:task, task_id, result)

      {:error, error} ->
        %{:postgres => %{:message => msg}, :query => query} = error
        result = %{data: [], msg: msg, query: query, is_success: false}
        ReadPg.ets_put(:task, task_id, result)
    end
  end

  def task_state(task_id, download) do
    case ReadPg.ets_get(:task, task_id) do
      nil ->
        %{msg: "查询不到任务或任务已过期", is_success: false, data: []}
      :end ->
        %{msg: "已下载,数据已销毁", is_success: false, data: []}
      :start ->
        %{msg: "正在查询", is_success: false, data: []}
      result ->
        if download do
          ReadPg.ets_put(:task, task_id, :end)
          result
        else
          result
          |> Map.put(:data, [])
        end
    end
  end
end
