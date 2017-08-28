export Eye

"""
`Eye([domainType=Float64::Type,] dim_in::Tuple)`

`Eye([domainType=Float64::Type,] dims...)`

Create the identity operator.

```julia
julia> op = Eye(Float64,(4,))
I  ℝ^4 -> ℝ^4

julia> op = Eye(2,3,4)
I  ℝ^(2, 3, 4) -> ℝ^(2, 3, 4)

julia> op*ones(2,3,4) == ones(2,3,4)
true

```

"""

immutable Eye{T, N} <: LinearOperator
	dim::NTuple{N, Integer}
end

# Constructors
###standard constructor Operator{N}(DomainType::Type, DomainDim::NTuple{N,Int})
Eye{N}(DomainType::Type, DomainDim::NTuple{N,Int}) = Eye{DomainType,N}(DomainDim)  
###

Eye(t::Type, dims::Vararg{Integer}) = Eye(t,dims)
Eye{N}(dims::NTuple{N, Integer}) = Eye(Float64,dims)
Eye(dims::Vararg{Integer}) = Eye(Float64,dims)

# Mappings

A_mul_B!{T, N}(y::AbstractArray{T, N}, L::Eye{T, N}, b::AbstractArray{T, N}) = y .= b
Ac_mul_B!{T, N}(y::AbstractArray{T, N}, L::Eye{T, N}, b::AbstractArray{T, N}) = A_mul_B!(y, L, b)

# Properties
diag(L::Eye) = 1.
diag_AcA(L::Eye) = 1.
diag_AAc(L::Eye) = 1.

domainType{T, N}(L::Eye{T, N}) = T
codomainType{T, N}(L::Eye{T, N}) = T

size(L::Eye) = (L.dim, L.dim)

fun_name(L::Eye) = "I"

is_eye(L::Eye) = true
is_diagonal(L::Eye) = true
is_AcA_diagonal(L::Eye) = true
is_AAc_diagonal(L::Eye) = true
is_orthogonal(L::Eye) = true
is_invertible(L::Eye) = true
is_full_row_rank(L::Eye) = true
is_full_column_rank(L::Eye) = true
