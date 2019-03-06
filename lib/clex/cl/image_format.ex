defmodule Clex.CL.ImageFormat do
  @moduledoc false

  require Record

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @type t :: record(:cl_image_format, order: Clex.CL.cl_channel_order, type: Clex.CL.cl_channel_type)
  Record.defrecord(:cl_image_format, order: nil, type: nil)

end
