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
~x.bmi