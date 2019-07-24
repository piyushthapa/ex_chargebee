defmodule ChargeBee.Utils do
  def string_map_to_atom(string_key_map) do
    for {key, val} <- string_key_map, into: %{} do
      cond do
        is_atom(key) ->
          value = if is_map(val), do: string_map_to_atom(val), else: val
          {key, value}

        true ->
          value = if is_map(val), do: string_map_to_atom(val), else: val
          {String.to_atom(key), value}
      end
    end
  end

  def to_string_map(map) do
    for {k, v} <- map, into: %{} do
      cond do
        is_binary(k) ->
          value = if is_map(v), do: to_string_map(v), else: v
          {k, value}

        true ->
          value = if is_map(v), do: to_string_map(v), else: v
          {Atom.to_string(k), value}
      end
    end
  end

  def map_to_form_encoded([]), do: []
  def map_to_form_encoded(map, prefix \\ nil) do
    encoded =
    for {k, v} <- to_string_map(map) do
      cond do
        is_map(v) ->
          key = if prefix, do: "#{prefix}[#{k}]", else: k
          map_to_form_encoded(v, key)

        true ->
          key = if prefix, do: "#{prefix}[#{k}]", else: k
          {key, v}
      end
    end

    encoded
    |> List.flatten()

  end

  def random_string(length \\ 16) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
