defmodule ChargeBee.Customer do

  alias ChargeBee.Handler

  @url_suffix "/customers"

  def retrieve(customer_id) when is_binary(customer_id), do: Handler.retrieve("#{@url_suffix}/#{customer_id}")
  def retrieve(_), do: {:error, %{reason: "invalid customer_id"}}

  def new(params) when is_map(params), do: Handler.new(params, @url_suffix)
  def new(_), do: {:error, %{reason: "invalid params for new customer"}}

  def update(customer_id, update_params) when is_map(update_params) and is_binary(customer_id), do: Handler.update(update_params, "#{@url_suffix}/#{customer_id}")
  def update(_,_), do: {:error, %{reason: "Invalid customer_id or update params"}}

  def list(params \\ []), do: Handler.list(@url_suffix, params)

end
