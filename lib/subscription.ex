defmodule ChargeBee.Subscription do
  alias ChargeBee.Endpoint
  alias ChargeBee.Utils
  @url_suffix "/subscriptions"

  def list(params \\ %{}), do: Endpoint.request(params, @url_suffix, :get)

  def create(params) when is_map(params) do
    Utils.string_map_to_atom(params)
    |> Endpoint.request(@url_suffix, :post)
  end
  def create(_), do: {:error, %{reason: "Invalid Parameter"}}

  def retrieve(customer_id) when is_binary(customer_id), do: Endpoint.request([], "#{@url_suffix}/#{customer_id}", :get)
  def retrieve(_), do: {:error, %{reason: "Invalid Parameter"}}





end
