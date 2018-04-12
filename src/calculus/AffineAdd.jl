export AffineAdd

"""
`AffineAdd(A::AbstractOperator, d, [sign = true])`

Affine addition to `AbstractOperator` with an array or scalar `d`. 

Use `sign = false` to perform subtraction.

```julia
julia> A = AffineAdd(Sin(3),[1.;2.;3.])
sin+d  ℝ^3 -> ℝ^3

julia> A*[3.;4.;5.] == sin.([3.;4.;5.]).+[1.;2.;3.]
true

julia> A = AffineAdd(Exp(3),[1.;2.;3.],false)
e-d  ℝ^3 -> ℝ^3

julia> A*[3.;4.;5.] == exp.([3.;4.;5.]).-[1.;2.;3.]
true

```

"""
struct AffineAdd{L <: AbstractOperator, D <: Union{AbstractArray, Number}, S} <: AbstractOperator
  A::L
  d::D
  function AffineAdd(A::L, d::D, sign::Bool = true) where {L, D <: AbstractArray} 
      if size(d) != size(A,1) 
          throw(DimensionMismatch("codomain size of $A not compatible with array `d` of size $(size(d))"))
      end
      if eltype(d) != codomainType(A) 
          error("cannot tilt opertor having codomain type $(codomainType(A)) with array of type $(eltype(d))")
      end
      new{L,D,sign}(A,d)
  end
  # scalar
  function AffineAdd(A::L, d::D, sign::Bool = true) where {L, D <: Number} 
      if typeof(d) <: Complex && codomainType(A) <: Real
          error("cannot tilt opertor having codomain type $(codomainType(A)) with array of type $(eltype(d))")
      end
      new{L,D,sign}(A,d)
  end
end

# Mappings
# array
function A_mul_B!(y::DD, T::AffineAdd{L, D, true}, x) where {L <: AbstractOperator, DD, D} 
    A_mul_B!(y,T.A,x)
    y .+= T.d
end

function A_mul_B!(y::DD, T::AffineAdd{L, D, false}, x) where {L <: AbstractOperator, DD, D} 
    A_mul_B!(y,T.A,x)
    y .-= T.d
end

Ac_mul_B!(y, T::AffineAdd{L, D}, x) where {L <: AbstractOperator, D} = Ac_mul_B!(y,T.A,x)

# Properties

size(L::AffineAdd) = size(L.A)

domainType(L::AffineAdd) = domainType(L.A)
codomainType(L::AffineAdd) = codomainType(L.A)

is_linear(L::AffineAdd) = is_linear(L.A)
is_null(L::AffineAdd) = is_null(L.A)
is_eye(L::AffineAdd) = is_diagonal(L.A)
is_diagonal(L::AffineAdd) = is_diagonal(L.A)
is_invertible(L::AffineAdd) = is_invertible(L.A)
is_AcA_diagonal(L::AffineAdd) = is_AcA_diagonal(L.A) 
is_AAc_diagonal(L::AffineAdd) = is_AAc_diagonal(L.A)
is_full_row_rank(L::AffineAdd) = is_full_row_rank(L.A)
is_full_column_rank(L::AffineAdd) = is_full_column_rank(L.A)

fun_name(T::AffineAdd{L,D,S}) where {L,D,S} = "$(fun_name(T.A))"*(S ? "+" : "-")*"d"
fun_type(L::AffineAdd) = fun_type(L.A)

diag(L::AffineAdd) = diag(L.A)
diag_AcA(L::AffineAdd) = diag_AcA(L.A)
diag_AAc(L::AffineAdd) = diag_AAc(L.A)
