# SuParameters

Like normal parameters, but __super__.

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

### Conditioning

Use `cond!` to add conditions to a `SuParams`

```
using SuParameters. Omega
using Test
x = SuParams()
x.x = normal(x.y, 1)
x.bmi = x.weight * x.height
x.weight = normal(100, 1)
x.height = normal(300, 10)
~x
Dict{Symbol,Float64} with 3 entries:
  :weight => 100.465
  :bmi    => 29908.0
  :height => 297.696

cond!(x, x.bmi ==ₛ 25000)
~x.bmiå
```