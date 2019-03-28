# Clex

The **Clex** Elixir package wraps the excellent Erlang NIF provided by [tonyrog/cl](https://github.com/tonyrog/cl) who has been a great resource during the development of **Clex**.  The modules provide a versioned interface into the OpenCL drivers available on most systems for cross-device (primarily CPU and GPU) development and execution of high-performance software kernels.

## What is OpenCL?

**OpenCL** (Open Computing Language) is an open royalty-free standard for general purpose parallel programming across CPUs, GPUs and other processors, giving software developers portable and efficient access to the power of these heterogeneous processing platforms.

OpenCL supports a wide range of applications, ranging from embedded and consumer software to HPC solutions, through a low-level, high-performance, portable abstraction. By creating an efficient, close-to-the-metal programming interface, OpenCL will form the foundation layer of a parallel computing ecosystem of platform-independent tools, middleware and applications.

OpenCL consists of an API for coordinating parallel computation across heterogeneous processors; and a cross-platform programming language with a well-specified computation environment. The OpenCL standard:

- Supports both data- and task-based parallel programming models
- Utilizes a subset of ISO C99 with extensions for parallelism
- Defines consistent numerical requirements based on IEEE 754
- Defines a configuration profile for handheld and embedded devices
- Efficiently interoperates with OpenGL, OpenGL ES, and other graphics APIs

The specification is divided into a core specification that any OpenCL compliant implementation must support; a handheld/embedded profile which relaxes the OpenCL compliance requirements for handheld and embedded devices; and a set of optional extensions that are likely to move into the core specification in later revisions of the OpenCL specification. 

## OpenCL versions

The **Clex** package currently supports all 1.x versions of the OpenCL specs:

- [OpenCL 1.0](https://www.khronos.org/registry/OpenCL/sdk/1.0/docs/man/xhtml) via `Clex.CL10`
- [OpenCL 1.1](https://www.khronos.org/registry/OpenCL/sdk/1.1/docs/man/xhtml) via `Clex.CL11`
- [OpenCL 1.2](https://www.khronos.org/registry/OpenCL/sdk/1.2/docs/man/xhtml) via `Clex.CL12`
  
Not all functions are implemented due to constraints within the BEAM and/or lack of support in the underlying NIF.  The following OpenCL functions do not have analogues in **Clex**:

- `clCreateUserEvent`
- `clEnqueueNativeKernel`
- `clGetEventProfilingInfo`
- `clSetEventCallback`
- `clSetMemObjectDestructorCallback`
- `clSetUserEventStatus`

## Why write an Elixir wrapper?

Some of the Erlang calls in the NIF are not idiomatic Elixir, and this wrapper attempts to provide that more idiomatic interface as well as [ExDoc](https://hex.pm/packages/ex_doc) support for the versioned modules and functions.  There are also plans to bundle OpenCL implementations of standard kernel libraries (we're eyeballing [clMathLibraries](https://github.com/clMathLibraries) for starters). 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `clex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:clex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/clex](https://hexdocs.pm/clex).

## License

This software is released as-is under the [Apache License, Version 2.0, January 2004](http://www.apache.org/licenses/LICENSE-2.0).  The plaintext version of this license is included in this repository in the file `LICENSE.md`.

## Copyright notices

This software and its documentation utilizes APIs and content based on the following fair-use copyrighted material.

### The Khronos Group Inc.
Copyright © 2007-2011 The Khronos Group Inc. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and/or associated documentation files (the "Materials"), to deal in the Materials without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Materials, and to permit persons to whom the Materials are furnished to do so, subject to the condition that this copyright notice and permission notice shall be included in all copies or substantial portions of the Materials.  
