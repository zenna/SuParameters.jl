module SuParameters

export SuParams, Params

include("param.jl")
using .Param
include("suparam.jl")
using .SuParam

end
