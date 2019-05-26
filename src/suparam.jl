module SuParam
using Omega: RandVar, apl, ciid, Ω, ID, uid, constant
import Omega
import ..Param: Params

export SuParams

"SuParams are random variables over parameters"
struct SuParams{I, T} <: RandVar
  id::ID
  d::Dict{I, T}
  function SuParams(x::Dict{I, T}) where {I, T}
    new{I, T}(uid(), x)
  end
end

# Constructors
SuParams(; kwargs...) = isempty(kwargs) ? SuParams(Dict{Symbol, Any}()) : SuParams(kwargs...)
SuParams(x::NamedTuple) = SuParams(Dict(k => v for (k, v) in pairs(x)))
SuParams(ps::Pair...) = SuParams(Dict(ps))
SuParams(p::Params) = SuParams(p.d)

@inline aplifrv(x::RandVar, ω) = apl(x, ω)
@inline aplifrv(x, ω) = x

# Fields
function Base.getproperty(φ::SuParams, k::Symbol)
  if k == :d
    getfield(φ, :d)
  elseif k == :id
    getfield(φ, :id)
  else
    ciid(ω -> k in keys(getfield(φ, :d)) ? aplifrv(getfield(φ, :d)[k], ω) : constant(missing)(ω))
  end
end

function Base.setproperty!(φ::SuParams, name::Symbol, x)
  if name  == :d
    error("Cannot assign d as a property of params.  Use another name!")
  else
    φ.d[name] = x
  end
end

# Rand
dag(v, ω) = v
dag(v::Params, ω) = v(ω)

resolve(v, ω) = v
resolve(v::RandVar, ω) = dag(apl(v, ω), ω) # If the result of randvar application is a params, recurse
resolve(v::Params, ω) = v(ω)

function Omega.ppapl(rp::SuParams, ω::Ω)
  Params(Dict(k => resolve(v, ω) for (k, v) in rp.d))
end


# To sample from Params, first convert to SuParams
Base.rand(φ::Params, n::Integer) = rand(SuParams(φ), n)
Base.rand(φ::Params) = rand(SuParams(φ))

Base.show(io, sp::SuParams) = show(io, sp.d)
Base.show(io, mime, sp::SuParams) = show(io, mine, sp.d)
Base.display(sp::SuParams) = display(sp.d)
end
