defmodule ReadPg do
  @moduledoc """
  ReadPg keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def ets_new() do
    :ets.new(:app, [:named_table, :public])
    :ets.new(:task, [:named_table, :public])
  end

  def ets_put(table, key, value) do
    if(ets_get(table, key))do
      ets_del(table, key)
    end
    :ets.insert(table, {key, value})
  end


  def ets_get(tab, key) do
    val = :ets.lookup(tab, key)
    case val do
      [] -> nil
      _ ->
        [{_, i}] = val
        i
    end
  end

  def ets_del(tab, key) do
    :ets.delete(tab, key)
  end

  def set_time() do
    datetime = :calendar.local_time()
    {year, month, day, hour, minute, second} = gb_time(datetime)
    time = to_string(year) <> to_string(month) <> to_string(day) <> to_string(hour) <> to_string(minute) <> to_string(second)
    IO.inspect time
    ets_put(:app, :start_time, time)
  end

  def gb_time(datetime) do
    {{year, month, day},{hour, minute, second}} = datetime
    {concat(year), concat(month), concat(day), concat(hour), concat(minute), concat(second)}
  end


  def now() do
    Timex.now("Asia/Shanghai")
    |> Timex.Format.DateTime.Formatters.Default.format!("{YYYY}{0M}{0D}{h24}{m}{s}")
  end

  defp concat(t) do
    if(t < 10)do "0#{t}" else t end
  end

end
