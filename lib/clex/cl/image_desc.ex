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
               buffer: Clex.CL.cl_mem
             )
  Record.defrecord(:cl_image_desc, type: nil,
    width: nil, height: nil, depth: nil,
    array_size: nil, row_pitch: nil, slice_pitch: nil,
    num_mip_levels: nil, num_samples: nil, buffer: nil
  )

end
