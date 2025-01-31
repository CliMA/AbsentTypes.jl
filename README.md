# NullBroadcasts.jl

|||
|---------------------:|:----------------------------------------------|
| **Docs Build**       | [![docs build][docs-bld-img]][docs-bld-url]   |
| **Documentation**    | [![dev][docs-dev-img]][docs-dev-url]          |
| **GHA CI**           | [![gha ci][gha-ci-img]][gha-ci-url]           |
| **Code Coverage**    | [![codecov][codecov-img]][codecov-url]        |

[docs-bld-img]: https://github.com/CliMA/NullBroadcasts.jl/actions/workflows/docs.yml/badge.svg
[docs-bld-url]: https://github.com/CliMA/NullBroadcasts.jl/actions/workflows/docs.yml

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://CliMA.github.io/NullBroadcasts.jl/dev/

[gha-ci-img]: https://github.com/CliMA/NullBroadcasts.jl/actions/workflows/ci.yml/badge.svg
[gha-ci-url]: https://github.com/CliMA/NullBroadcasts.jl/actions/workflows/ci.yml

[codecov-img]: https://codecov.io/gh/CliMA/NullBroadcasts.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/CliMA/NullBroadcasts.jl

This package defines `NullBroadcasted()`, which can be added to, subtracted
from, or multiplied by any value in a broadcast expression without incurring a
runtime performance penalty.

# Example

```julia
using NullBroadcasts: NullBroadcasted
using Test

x = [1]; y = [1]
a = NullBroadcasted()
@. x = x + a + y
@test x[1] == 2 # passes

x = [1]; y = [1]
@. x = x - a + y
@test x[1] == 2 # passes

@. x = x + (x * a) # equivalent to @. x = x

@. x = x * a # not allowed, errors
@. x = a # not allowed, errors
```
