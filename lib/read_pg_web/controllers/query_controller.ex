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
          |> Enum.map(fn x -> Regex.replace(~r/edit/, x, "update") end)
          |> Enum.map(fn x -> Regex.replace(~r/add/, x, "create") end)
          |> Enum.join(" ")

        try do
          {:ok, pid} = Postgrex.start_link(hostname: "127.0.0.1", username: "postgres", password: "postgres", database: database)

          data = Postgrex.query!(pid, sql, [], [timeout: 1500000000])
          GenServer.stop(pid)

          result = Enum.map(data.rows, fn xs ->
              Enum.with_index(xs)
              |> Enum.map(fn {v, i} -> {String.to_atom(Enum.at(data.columns, i)), v} end)
              |> Map.new
            end)

          json conn, %{data: result}
        rescue
          error ->
            IO.inspect error
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
