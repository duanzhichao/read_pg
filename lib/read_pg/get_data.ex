defmodule ReadPg.GetData do
  alias ReadPg.Repo

  def query(sql) do
    case Repo.query(sql, [], [timeout: 1500000000000]) do
      {:ok, result} ->
        result = pgresult_to_map(result)
        %{data: result, msg: "", query: "", is_success: true}

      {:error, error} ->
        %{:postgres => %{:message => msg}, :query => query} = error
        %{data: [], msg: msg, query: query, is_success: false}
    end
  end

  def query(sql, database) do
     # cond do
    #   is_nil(sql) -> json conn, %{data: []}
    #   sql == "" -> json conn, %{data: []}
    #   database == "" -> json conn, %{data: []}
    #   sql == [] -> json conn, %{data: []}
    #   true ->
    #     sql = Jason.decode!(sql)
    #       |> Enum.map(fn x -> Regex.replace(~r/get/, x, "select") end)
    #       |> Enum.map(fn x -> Regex.replace(~r/edit/, x, "update") end)
    #       |> Enum.map(fn x -> Regex.replace(~r/add/, x, "create") end)
    #       |> Enum.join(" ")

    #     try do
    #       {:ok, pid} = Postgrex.start_link(hostname: "127.0.0.1", username: "postgres", password: "postgres", database: database)

    #       data = Postgrex.query!(pid, sql, [], [timeout: 1500000000])
    #       GenServer.stop(pid)

    #       result = Enum.map(data.rows, fn xs ->
    #           Enum.with_index(xs)
    #           |> Enum.map(fn {v, i} -> {String.to_atom(Enum.at(data.columns, i)), v} end)
    #           |> Map.new
    #         end)

    #       json conn, %{data: result}
    #     rescue
    #       error ->
    #         IO.inspect error
    #         json conn, %{data: []}
    #     end
    # end
  end

  def parse_sql(sql) do
    cond do
      is_nil(sql) -> nil
      sql == "" -> nil
      sql == [] -> nil
      true ->
        Jason.decode!(sql)
        |> Enum.map(fn x -> Regex.replace(~r/get/, x, "select") end)
        |> Enum.map(fn x -> Regex.replace(~r/edit/, x, "update") end)
        |> Enum.map(fn x -> Regex.replace(~r/add/, x, "create") end)
        |> Enum.join(" ")
    end
  end

  def pgresult_to_map(result) do
    %{:rows => rows, :columns => columns} = result
    Enum.map(rows, fn xs ->
      Enum.with_index(xs)
      |> Enum.map(fn {v, i} -> {String.to_atom(Enum.at(columns, i)), v} end)
      |> Map.new
    end)
  end
end
