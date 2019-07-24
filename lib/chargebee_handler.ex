defmodule ChargeBee.Handler do
  alias ChargeBee.Endpoint
  alias ChargeBee.Utils

  def new(params, url_suffix) when is_map(params) and is_binary(url_suffix) do
    Utils.string_map_to_atom(params)
    |> Endpoint.request(url_suffix, :post)
  end

  def retrieve(url_suffix) when is_binary(url_suffix), do: Endpoint.request([], url_suffix, :get)

  def update(update_params, url_suffix) when is_map(update_params) do
    Utils.string_map_to_atom(update_params)
    |> Endpoint.request(url_suffix, :post)
  end

  def list(url_suffix, params \\ []), do: Endpoint.request(params, url_suffix, :get)

end
