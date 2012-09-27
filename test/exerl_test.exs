Code.require_file "../test_helper.exs", __FILE__

defmodule SomeModule do
  def f, do: 1
end

defmodule :some_module_transform do
  use ExErl.ParseTransform

  transform :some_module, to: SomeModule
end

defmodule Test do
  @compile {:parse_transform, :some_module_transform}

  def t, do: :some_module.f

end

defmodule ExerlTest do
  use ExUnit.Case

  test "the transformation" do
    assert Test.t == SomeModule.f
  end
end
