defmodule ReadPg.RepoTask do
  alias ReadPg.Repo
  alias ReadPg.GetData

  def start(sql) do
    sql = GetData.parse_sql(sql)
    ReadPg.ets_put(:task, :a1, :start)
    case Repo.query(sql, [], [timeout: 1500000000000]) do
      {:ok, result} ->
        result = GetData.pgresult_to_map(result)
        result = %{data: result, msg: "", query: "", is_success: true}
        ReadPg.ets_put(:task, :a1, result)

      {:error, error} ->
        %{:postgres => %{:message => msg}, :query => query} = error
        result = %{data: [], msg: msg, query: query, is_success: false}
        ReadPg.ets_put(:task, :a1, result)
    end
  end

end
