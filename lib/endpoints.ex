defmodule ChargeBee.Endpoint do
  @options %{ protocol: "https", host_suffix: ".chargebee.com", api_path: "api/v2", timeout: 40_000, version: 'v2.4.7', port: 443}


  def request(params \\ [] , url_suffix ,  method \\ :post) do
    url = get_url(method, url_suffix, params)

    token = :base64.encode("#{api_key()}:")
    body = {:form, ChargeBee.Utils.map_to_form_encoded(params)}

    headers = [
      {"Authorization" ,  "Basic #{token}"},
      {"Accept", "application/json"},
      {"Content-Type" , "application/x-www-form-urlencoded; charset=utf-8"}
    ]

    result =
      case HTTPoison.request(method, url, body , headers, []) do
        {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
          {:ok, parsed_data} =  Jason.decode(body)
          Map.put(parsed_data, "http_status_code", status_code)

        {:error, reason} ->
          reason
      end

    if result["http_status_code"] != 200, do: {:error, result}, else: {:ok, result}
  end

  defp get_url(:post, url_suffix, _params) when is_binary(url_suffix), do: "https://#{site()}.chargebee.com/#{@options.api_path}#{url_suffix}"
  defp get_url(:get, url_suffix, params ) when is_binary(url_suffix), do: "https://#{site()}.chargebee.com/#{@options.api_path}#{url_suffix}?" <> URI.encode_query(params)

  defp api_key, do: Application.fetch_env!(:ex_chargebee, :api_key)

  defp site, do: Application.fetch_env!(:ex_chargebee, :site)

end
