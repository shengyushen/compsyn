(*gf type with string list as data, instead of inferred type*)
(*the first string is instance name, the second is Z output, the rest are inputs*)
type type_flat =
	TYPE_FLAT_GFADD      of string*(string list)*(string list)*(string list)
 |TYPE_FLAT_GFMULTFLAT of string*(string list)*(string list)*(string list)
 |TYPE_FLAT_GFMULT     of string*(string list)*(string list)*(string list)
 |TYPE_FLAT_GFDIV      of string*(string list)*(string list)*(string list)
 |TYPE_FLAT_TOWER2FLAT of string*(string list)*(string list)
 |TYPE_FLAT_FLAT2TOWER of string*(string list)*(string list)
 |TYPE_FLAT_EO         of string*string*string*string
 |TYPE_FLAT_IV         of string*string*string
 |TYPE_FLAT_AN2        of string*string*string*string
 |TYPE_FLAT_OR2        of string*string*string*string
 |TYPE_FLAT_NULL
;;

type type_integrated = 
	TYPE_INT_GFADD      of int*int*int
 |TYPE_INT_GFMULTFLAT of  int*int*int
 |TYPE_INT_GFMULT     of  int*int*int
 |TYPE_INT_GFDIV      of  int*int*int
 |TYPE_INT_TOWER2FLAT of  int*int
 |TYPE_INT_FLAT2TOWER of  int*int
 |TYPE_INT_EO         of  int*int*int
 |TYPE_INT_IV         of  int*int
 |TYPE_INT_AN2        of  int*int*int
 |TYPE_INT_OR2        of  int*int*int
;;
