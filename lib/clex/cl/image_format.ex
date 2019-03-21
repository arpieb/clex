defmodule Clex.CL.ImageFormat do
  @moduledoc ~S"""
  This module defines a `Record` type that represents the `cl_image_format` as specified in the Open CL specification:

  ```c
  typedef struct _cl_image_format {
    cl_channel_order image_channel_order;
    cl_channel_type image_channel_data_type;
  } cl_image_format;
  ```

  ## Members

  `:order` \
  Specifies the number of channels and the channel layout i.e. the memory layout in which channels are stored in the image. Valid values are described in the table below.

  Format                 | Description
  :--------------------- | :---------
  `:r`, `:rx`, `:a`      | No notes
  `:intensity`           | This format can only be used if channel data type = `:unorm_int8`, `:unorm_int16`, `:snorm_int8`, `:snorm_int16`, `:half_float`, or `:float`.
  `:luminance`           | This format can only be used if channel data type = `:unorm_int8`, `:unorm_int16`, `:snorm_int8`, `:snorm_int16`, `:half_float`, or `:float`.
  `:rg`, `:rgx`, `:ra`   | No notes
  `:rgb`, `:rgbx`        | This format can only be used if channel data type = `:unorm_short_565`, `:unorm_short_555` or `:unorm_int_101010`.
  `:rgba`                | No notes
  `:argb`, `:bgra`       | This format can only be used if channel data type = `:unorm_int8`, `:snorm_int8`, `:signed_int8` or `:unsigned_int8`.

  `:type` \
  Describes the size of the channel data type. The number of bits per element determined by the `type` and `order` must be a power of two. The list of supported values is described in the table below.

  Image Channel Data Type  | Description
  :----------------------- | :---------
  `:snorm_int8`            | Each channel component is a normalized signed 8-bit integer value.
  `:snorm_int16`           | Each channel component is a normalized signed 16-bit integer value.
  `:unorm_int8`            | Each channel component is a normalized unsigned 8-bit integer value.
  `:unorm_int16`           | Each channel component is a normalized unsigned 16-bit integer value.
  `:unorm_short_565`       | Represents a normalized 5-6-5 3-channel RGB image. The channel order must be `:rgb`.
  `:unorm_short_555`       | Represents a normalized x-5-5-5 4-channel xRGB image. The channel order must be `:rgb`.
  `:unorm_int_101010`      | Represents a normalized x-10-10-10 4-channel xRGB image. The channel order must be `:rgb`.
  `:signed_int8`           | Each channel component is an unnormalized signed 8-bit integer value.
  `:signed_int16`          | Each channel component is an unnormalized signed 16-bit integer value.
  `:signed_int32`          | Each channel component is an unnormalized signed 32-bit integer value.
  `:unsigned_int8`         | Each channel component is an unnormalized unsigned 8-bit integer value.
  `:unsigned_int16`        | Each channel component is an unnormalized unsigned 16-bit integer value.
  `:unsigned_int32`        | Each channel component is an unnormalized unsigned 32-bit integer value.
  `:half_float`            | Each channel component is a 16-bit half-float value.
  `:float`                 | Each channel component is a single precision floating-point value.

  ## Description

  The following example shows how to specify a normalized unsigned 8-bit / channel RGBA image:

  ```
  order = :rgba
  type = :unorm_int8
  ```

  `type` values of `:unorm_short_565`, `:unorm_short_555` and `:unorm_int_101010` are special cases of packed image formats where the channels of each element are packed into a single unsigned short or unsigned int. For these special packed image formats, the channels are normally packed with the first channel in the most significant bits of the bitfield, and successive channels occupying progressively less significant locations. For `:unorm_short_565`, R is in bits 15:11, G is in bits 10:5 and B is in bits 4:0. For `:unorm_short_555`, bit 15 is undefined, R is in bits 14:10, G in bits 9:5 and B in bits 4:0. For `:unorm_int_101010`, bits 31:30 are undefined, R is in bits 29:20, G in bits 19:10 and B in bits 9:0.
  """

  require Record

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @type t :: record(:cl_image_format, order: Clex.CL.cl_channel_order, type: Clex.CL.cl_channel_type)
  Record.defrecord(:cl_image_format, order: nil, type: nil)

end
