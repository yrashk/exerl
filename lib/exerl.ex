defmodule ExErl.ParseTransform do
  defmacro __using__(_) do
    quote do
      import ExErl.ParseTransform
      Module.register_attribute __MODULE__, :transformation, 
                                accumulate: true, persist: true

      def parse_transform(forms, opts) do
        forms = :elixir_transform.parse_transform(forms, opts)
        transformations = Keyword.from_enum(lc {:transformation, [v]} inlist __MODULE__.__info__(:attributes), do: v)
        do_transform(forms, transformations)
      end

      def do_transform({:atom, line, atom} = v, transformations) do
        case transformations[atom] do
          nil -> v
          new_atom -> {:atom, line, new_atom}
        end
      end

      def do_transform(tuple, transformations) when is_tuple(tuple) and size(tuple) > 1 do
        name = elem(tuple, 0)
        list_to_tuple([name|(lc i inlist tl(tuple_to_list(tuple)), do: do_transform(i, transformations))])
      end

      def do_transform(list, transformations) when is_list(list) do
        lc x inlist list, do: do_transform(x, transformations)
      end

      def do_transform(other, _transformations), do: other
    end
  end

  defmacro transform(erlang, [to: elixir]) do
    quote do
      @transformation {unquote(erlang), unquote(elixir)}
    end
  end

end
