module SuParameters

export SuParams, Params, cond!

include("param.jl")
using .Param
include("suparam.jl")
using .SuParam

end
