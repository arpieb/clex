defmodule Clex.CL.ImageDesc do
  @moduledoc false

  require Record

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @type t :: record(:cl_image_desc,
               type: Clex.CL.cl_mem_object_type,
               width: non_neg_integer,
               height: non_neg_integer,
               depth: non_neg_integer,
               array_size: non_neg_integer,
               row_pitch: non_neg_integer,
               slice_pitch: non_neg_integer,
               num_mip_levels: non_neg_integer,
               num_samples: non_neg_integer,
               buffer: Clex.CL.cl_mem | :undefined
             )
  Record.defrecord(:cl_image_desc, type: nil,
    width: nil, height: nil, depth: 1,
    array_size: 1, row_pitch: 0, slice_pitch: 0,
    num_mip_levels: 0, num_samples: 0, buffer: :undefined
  )

end
