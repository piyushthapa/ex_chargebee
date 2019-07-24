defmodule ChargeBee.Plan do
  alias ChargeBee.Endpoint
  alias ChargeBee.Utils

  @url_suffix "/plans"

  def list(params \\ %{}), do: Endpoint.request(params, @url_suffix, :get)

  def create(params) when is_map(params) do
    Utils.string_map_to_atom(params)
    |> Endpoint.request(@url_suffix, :post)
  end

  def create(_), do: {:error, %{reason: "invalid plan parameters"}}

  def retrieve(plan_id) when is_binary(plan_id), do: Endpoint.request([], "#{@url_suffix}/#{plan_id}", :get)
  def retrieve(_), do: {:error, %{reason: "invalid plan_id"}}

  def update(plan_id, new_plan) when is_binary(plan_id) and is_map(new_plan) do
    Utils.string_map_to_atom(new_plan)
    |> Endpoint.request("#{@url_suffix}/#{plan_id}", :post)
  end
  def update(plan_id,_) when is_binary(plan_id), do: {:error, %{reason: "invalid plan parameters"}}
  def update(_, _), do: {:error, %{reason: "invalid plan_id"}}

  def delete(plan_id) when is_binary(plan_id), do: Endpoint.request([], "#{@url_suffix}/#{plan_id}/delete", :post)
  def delete(_), do: {:error, %{reason: "invalid plan_id"}}

  def unarchive(plan_id) when is_binary(plan_id), do: Endpoint.request([], "#{@url_suffix}/#{plan_id}/unarchive", :post)
  def unarchive(_), do: {:error, %{reason: "invalid plan_id"}}
end
