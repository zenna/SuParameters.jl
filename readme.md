# SuParameters

Like normal parameters, but __super__.

What makes SuParameters super?

- Fields can be used before they are defined.  This allows you to define fields relative to another field, for which lack information about now but anticipate getting that information later

- Updating fields automatically updates fields that depend on it

- `SuParam`eters can take random variables as arguments.  Technically, a `SuParam` __is__ a random variable.  It defines a distribution over `Params` objects

- Consequently, `SuParam`s can be conditioend.

# Example

```julia
using SuParameters
using Test
using Omega

x = SuParams()
x.a = 4
@test rand(x.a) == 4

x = SuParams()
x.a = 4;
x.b = x.a;
@test rand(x.b) == 4

x = SuParams()
x.b = x.a + 34
@test ismissing(rand(x.a))
x.a = 4
@test rand(x.b) == 38

x = SuParams()
x.b = x.a + 34
x.a = 4
x.a = 400
@test rand(x.b) == 400 + 34

x = SuParams()
x.b = normal(0, 1)
x.a = x.b + 5
@test rand(x.a) isa AbstractFloat
x.b = poisson(2)
@test rand(x.a) isa Integer
```

# Usage

### Construction

Create a SuParams in any one of the following ways

- Using the keyword constructor

```julia
x = SuParams(a = 3, b = 4)
``` 

- Through assinging values to fields

```julia
x = SuParams()
x.a = 3
x.b = 4
```

### Access

Fiels of a `SuParam` are accessed with `.` (dot)"

```julia
x = SuParams(a = 3, b = 4)
x.a
``` 

The result of dot access is a random variable.
To get a concrete value out, use `rand`

```julia
x = SuParams(a = 3, b = 4)
rand(x.a)
``` 

`~` can be used instead of `rand`.

```julia
x = SuParams(a = 3, b = 4)
~x
~x.a
``` 

If a field has not been assigned, it will return `missing`

```julia
julia> x = SuParams()
Dict{Symbol,Any} with 0 entries

julia> ~x.a
missing
```

If a field is a `RandVar` (a random variable), a SuParam.

```julia
x = SuParams(a = normal(0, 1))
~x
~x.a
``` 

### Conditioning

Use `cond!` to add conditions to a `SuParams`

```julia
using SuParameters. Omega
using Test
x = SuParams()
x.bmi = x.weight * x.height
x.weight = normal(100, 1)
x.height = normal(300, 10)
~x
Dict{Symbol,Float64} with 3 entries:
  :weight => 100.465
  :bmi    => 29908.0
  :height => 297.696

cond!(x, x.bmi ==ₛ 25000)
~x.bmi
```