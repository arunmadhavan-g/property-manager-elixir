defmodule TransactionManager do

  def transact(operation, input) do
    {:ok, conn}= Redix.start_link()
    return_val = :erlang.apply(operation, [conn]++input)
    Redix.stop(conn)
    return_val
  end

end
