# exerl

Elixir macro to alias Elixir module names in Erlang:

```elixir
defmodule :some_module_transform do
  use ExErl.ParseTransform

  transform SomeModule, to: :some_module
end
```

This will generate an Erlang module called `some_module_transform` which
can be used to compile Erlang programs like this:

```erlang
-compile({parse_transform, some_module_transform}).

# ...

myfun() ->
  some_module:somefun().
```

some_module_transform will rewrite some_module to SomeModule.

Be informed, though, that this is a fairly dangerous technique at the moment as it
will rewrite pretty much every occurence of `some_module` atom in your Erlang module,
which may sometimes lead to some undesirable effects.

