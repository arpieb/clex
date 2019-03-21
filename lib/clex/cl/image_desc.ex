defmodule Clex.CL.ImageDesc do
  @moduledoc ~S"""
  This module defines a `Record` type that represents the `cl_image_desc` as specified in the Open CL specification:

  ```c
  typedef struct _cl_image_desc {
    cl_mem_object_type image_type;
    size_t image_width;
    size_t image_height;
    size_t image_depth;
    size_t image_array_size;
    size_t image_row_pitch;
    size_t image_slice_pitch;
    cl_uint num_mip_levels;
    cl_uint num_samples;
    cl_mem buffer;
  } cl_image_desc;
  ```

  ## Members

  `:type` \
  Describes the image type and must be either `:image1d`, `:image1d_buffer`, `:image1d_array`, `:image2d`, `:image2d_array`, or `:image3d`.

  `:width` \
  The width of the image in pixels. For a 2D image and image array, the image width must be ≤ `:image2d_max_width`. For a 3D image, the image width must be ≤ `:image3d_max_width`. For a 1D image buffer, the image width must be ≤ `:image_max_buffer_size`. For a 1D image and 1D image array, the image width must be ≤ `:image2d_max_width`.

  `:height` \
  The height of the image in pixels. This is only used if the image is a 2D, 3D or 2D image array. For a 2D image or image array, the image height must be ≤ `:image2d_max_height`. For a 3D image, the image height must be ≤ `:image3d_max_height`.

  `:depth` \
  The depth of the image in pixels. This is only used if the image is a 3D image and must be a value ≥ 1 and ≤ `:image3d_max_depth`.

  `:array_size` \
  The number of images in the image array. This is only used if the image is a 1D or 2D image array. The values for `:array_size`, if specified, must be a value ≥ 1 and ≤ `:image_max_array_size`. Note that reading and writing 2D image arrays from a kernel with `:array_size` = 1 may be lower performance than 2D images.

  `:row_pitch` \
  The scan-line pitch in bytes. This must be 0 if host_ptr is NULL and can be either 0 or ≥ `:width` * size of element in bytes if host_ptr is not NULL. If host_ptr is not NULL and `:row_pitch` = 0, `:row_pitch` is calculated as `:width` * size of element in bytes. If `:row_pitch` is not 0, it must be a multiple of the image element size in bytes.

  `:slice_pitch` \
  The size in bytes of each 2D slice in the 3D image or the size in bytes of each image in a 1D or 2D image array. This must be 0 if host_ptr is NULL. If host_ptr is not NULL, `:slice_pitch` can be either 0 or ≥ `:row_pitch` * `:height` for a 2D image array or 3D image and can be either 0 or ≥ `:row_pitch` for a 1D image array. If host_ptr is not NULL and `:slice_pitch` = 0, `:slice_pitch` is calculated as `:row_pitch` * `:height` for a 2D image array or 3D image and `:row_pitch` for a 1D image array. If `:slice_pitch` is not 0, it must be a multiple of the `:row_pitch`.

  `:num_mip_levels`, `:num_samples` \
  Must be 0.

  `:buffer` \
  Refers to a valid buffer memory object if `:type` is `:image1d_buffer`. Otherwise it must be NULL. For a 1D image buffer object, the image pixels are taken from the buffer object's data store. When the contents of a buffer object's data store are modified, those changes are reflected in the contents of the 1D image buffer object and vice-versa at corresponding sychronization points. The `:width` * size of element in bytes must be ≤ size of buffer object data store.
  """

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
