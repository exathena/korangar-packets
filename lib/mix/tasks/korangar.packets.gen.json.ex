defmodule Mix.Tasks.Korangar.Packets.Gen.Json do
  @moduledoc """
  Simplifies ragnarok-packets rustdoc JSON.
  """
  use Mix.Task

  @shortdoc "Generate packet code from ragnarok-packets"

  @rustdoc_json_path Path.join(~w[target doc ragnarok_packets.json])
  @output_path Path.join(~w[priv packets.json])

  @impl Mix.Task
  def run(_) do
    rustdoc_json =
      File.cwd!()
      |> Path.join(@rustdoc_json_path)
      |> File.read!()
      |> Jason.decode!()

    output =
      rustdoc_json
      |> convert_to_simple_json()
      |> Jason.encode_to_iodata!(pretty: true)

    File.cwd!()
    |> Path.join(@output_path)
    |> File.write!(output)

    Mix.shell().info("Written simplified JSON to #{@output_path}")
  end

  @map_server "MapServerPacket"
  @char_server "CharacterServerPacket"
  @login_server "LoginServerPacket"
  @common "CommonPacket"
  @ragnarok "RagnarokPacket"
  @server "ServerPacket"
  @client "ClientPacket"

  defp convert_to_simple_json(%{"crate_version" => version, "index" => index}) do
    items = extract_items(index)
    implementations = with_kind(items, :impl)
    keyless_structs = with_kind(items, :keyless_struct)

    packets =
      for packet <- preload(with_kind(items, :packet), fields: items, metadata: [impls: items]) do
        impls = Enum.map(packet.metadata.impls, & &1.name)

        server =
          cond do
            @map_server in impls -> :map
            @char_server in impls -> :character
            @login_server in impls -> :login
            @common in impls -> :shared
            @ragnarok in impls -> :shared
            :else -> :unknown
          end

        origin =
          cond do
            @server in impls -> :server
            @client in impls -> :client
          end

        Map.delete(%{packet | server: server, origin: origin}, :metadata)
      end

    structs =
      items
      |> with_kind(:struct)
      |> preload(fields: items)

    inline_structs =
      items
      |> with_kind(:inline_struct)
      |> preload(args: items)

    variants =
      items
      |> with_kind(:variant)
      |> preload(value: [struct: items], value: [tuple: items])

    enums =
      items
      |> with_kind(:enum)
      |> preload(values: variants)

    %{
      version: version,
      structs: clear_list(structs ++ inline_structs ++ keyless_structs),
      packets: clear_list(packets),
      variants: clear_list(variants),
      implementations: clear_list(implementations),
      enums: clear_list(enums)
    }
  end

  defp clear_list(items) do
    items
    |> List.flatten()
    |> Enum.uniq()
  end

  defp build_preload_path({key, value}, acc) do
    cond do
      Keyword.keyword?(value) ->
        Enum.reduce(value, acc, &build_preload_path/2)

      is_list(value) ->
        {[key | acc], value}
    end
  end

  defp build_preload_path(value, acc) do
    cond do
      Keyword.keyword?(value) ->
        Enum.reduce(value, acc, &build_preload_path/2)

      is_list(value) ->
        {acc, value}
    end
  end

  defp preload(items, preload_kw) do
    preloads =
      for {key, value} <- preload_kw do
        build_preload_path(value, [key])
      end

    for item <- items do
      for {keys, source} <- preloads, reduce: item do
        acc -> load_ids(acc, Enum.reverse(keys), source)
      end
    end
  end

  defp load_ids(%{} = item, [_key] = path, source) do
    if ids = get_in(item, path) do
      put_in(item, path, get_all(source, ids))
    else
      item
    end
  end

  defp load_ids(%{} = item, [key | path], source) do
    if nested = get_in(item, [key]) do
      put_in(item, [key], load_ids(nested, path, source))
    else
      item
    end
  end

  defp load_ids(value, [_ | _], _), do: value

  defp get_all(index, ids) do
    for id <- ids,
        item = Enum.find(index, &(&1.id == id)) do
      item
    end
  end

  defp with_kind(index, kind), do: Enum.filter(index, &(&1.kind == kind))

  defp extract_items(index) do
    for {_id, value} <- index, item = extract_item(value) do
      item
    end
  end

  defp extract_item(%{
         "attrs" => [_ | _] = attrs,
         "id" => id,
         "inner" => %{"struct" => data},
         "name" => name
       }) do
    extra_data =
      case data do
        %{"kind" => %{"plain" => %{"fields" => ids}}} ->
          %{fields: ids}

        %{"kind" => %{"tuple" => [nil]}} ->
          %{kind: :keyless_struct}

        %{"kind" => %{"tuple" => ids}} ->
          %{kind: :inline_struct, args: ids}
      end

    if header = extract_header(attrs) do
      %{
        id: id,
        header: header,
        name: name,
        kind: :packet,
        server: nil,
        origin: nil,
        metadata: %{
          impls: data["impls"]
        }
      }
    else
      %{
        id: id,
        name: name,
        kind: :struct
      }
    end
    |> Map.merge(extra_data)
  end

  defp extract_item(%{"id" => id, "inner" => %{"enum" => data}, "name" => name}) do
    %{
      id: id,
      name: name,
      kind: :enum,
      values: data["variants"]
    }
  end

  defp extract_item(%{"id" => id, "inner" => %{"struct_field" => data}, "name" => name}) do
    %{
      id: id,
      name: name,
      kind: :struct_field,
      type: extract_type(data)
    }
  end

  defp extract_item(%{"id" => id, "inner" => %{"impl" => %{"trait" => %{} = trait}}}) do
    %{
      id: id,
      name: trait["path"],
      kind: :impl
    }
  end

  defp extract_item(%{"id" => id, "inner" => %{"variant" => data}, "name" => name}) do
    %{
      id: id,
      name: name,
      kind: :variant,
      value: extract_variant_value(name, data)
    }
  end

  defp extract_item(%{"id" => id, "inner" => %{"assoc_type" => data}, "name" => name}) do
    %{
      id: id,
      name: name,
      kind: :assoc_type,
      for: get_in(data["type"]["resolved_path"]["path"]),
      args:
        get_in(
          data,
          [
            "type",
            "resolved_path",
            "args",
            "angle_bracketed",
            "args",
            Access.all(),
            "type",
            "resolved_path"
          ]
        )
    }
  end

  defp extract_item(_otherwise), do: nil

  defp extract_type(%{"primitive" => name}) do
    %{kind: :primitive, name: name}
  end

  defp extract_type(%{"resolved_path" => %{"args" => nil, "id" => id, "path" => name}}) do
    %{id: id, kind: :struct, name: name}
  end

  defp extract_type(%{"resolved_path" => %{"args" => type, "id" => id, "path" => name}}) do
    %{id: id, inner: extract_type(type), name: name}
  end

  defp extract_type(%{"angle_bracketed" => %{"args" => [%{"type" => type}]}}) do
    extract_type(type)
  end

  defp extract_type(%{"array" => %{"len" => length, "type" => type}}) do
    %{inner: extract_type(type), length: length}
  end

  defp extract_type(%{"generic" => name}) do
    %{kind: :generic, name: name}
  end

  defp extract_header([_ | _] = attrs) do
    Enum.find_value(attrs, &extract_header/1)
  end

  @header_regex ~r/header\s*\(\s*([0x0-9a-fA-F]+)\s*\)/

  defp extract_header(%{"other" => other}) do
    case Regex.run(@header_regex, other) do
      [_, hex] -> hex
      _ -> nil
    end
  end

  defp extract_header(_), do: nil

  defp extract_variant_value(name, %{"kind" => "plain"}) do
    Macro.underscore(name)
  end

  defp extract_variant_value(_, %{"kind" => %{"tuple" => fields}}) do
    %{tuple: fields}
  end

  defp extract_variant_value(_, %{"kind" => %{"struct" => %{"fields" => fields}}}) do
    %{struct: fields}
  end
end
