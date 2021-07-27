defmodule ReadPgWeb.QueryController do
  use ReadPgWeb, :controller

  def query(conn, _params) do

    %{"sql" => sql, "database" => database} = Map.merge(%{"sql" => "", "database" => "drg_prod"}, conn.params)

    cond do
      is_nil(sql) -> json conn, %{data: []}
      sql == "" -> json conn, %{data: []}
      database == "" -> json conn, %{data: []}
      sql == [] -> json conn, %{data: []}
      true ->
        sql = Jason.decode!(sql)
          |> Enum.map(fn x -> Regex.replace(~r/get/, x, "select") end)
          |> Enum.join(" ")

        try do
          IO.inspect sql
          {:ok, pid} = Postgrex.start_link(hostname: "127.0.0.1", username: "postgres", password: "postgres", database: database)
          data = Postgrex.query!(pid, sql, [], [timeout: 1500000000])
          GenServer.stop(pid)

          length = length(data.columns) - 1

          result = Enum.map(data.rows, fn xs ->
              Enum.map(0..length, fn index -> {Enum.at(data.columns, index), Enum.at(xs, index)} end)
              |> Map.new
            end)
          IO.inspect result
          json conn, %{data: result}
        rescue
          _ ->
          json conn, %{data: []}
        end
    end
  end

  def connect_test(conn, _params) do
    time = case ReadPg.ets_get(:app, :start_time) do
        nil -> ""
        time -> time
      end
    json conn, %{data: time}
  end

end
