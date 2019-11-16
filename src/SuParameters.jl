module SuParameters

export SuParams, Params, cond!, saveparams, linearstring, loadparams

include("param.jl")
using .Param
include("suparam.jl")
using .SuParam

end
