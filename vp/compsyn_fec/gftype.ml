type type_net =
	TYPE_NET_ID of string
	| TYPE_NET_CONST of int
	| TYPE_NET_ARRAYBIT of string*int
;;

type type_ion = 
	TYPE_CONNECTION_NET 
	| TYPE_CONNECTION_IN 
	| TYPE_CONNECTION_OUT
;;

type type_connection = 
	type_ion*type_net

type type_2opgf = 
	GFADD
	| GFMULTFLAT
	| GFMULT
	| GFDIV
;;
type type_1opgf = 
	TOWER2FLAT
	| FLAT2TOWER
;;
type type_2opbool =
	EO 
	| AN2
	| OR2
;;
(*gf type with string list as data, instead of inferred type*)
(*the tuple are operation type and instance name, and is Z output, the rest are inputs*)
type type_flat =
	TYPE_FLAT_2OPGF      of type_2opgf*string*(type_connection list)*(type_connection list)*(type_connection list)
 |TYPE_FLAT_1OPGF      of type_1opgf*string*(type_connection list)*(type_connection list)
 |TYPE_FLAT_2OPBOOL    of type_2opbool*string*type_connection*type_connection*type_connection
 |TYPE_FLAT_IV         of string*type_connection*type_connection
 |TYPE_FLAT_NULL
;;

(*similar to type_flat but with index to an array of type_gfdata*)
type type_gfmod = 
	TYPE_GFMOD_2OPGF      of type_2opgf*string*int*int*int
 |TYPE_GFMOD_1OPGF      of type_1opgf*string*int*int
 |TYPE_GFMOD_2OPBOOL    of type_2opbool*string*int*int*int
 |TYPE_GFMOD_IV         of string*int*int
 |TYPE_GFMOD_NULL
;;

type type_gfdata = 
	TYPE_GFDATA_GF1024 of type_connection list
	| TYPE_GFDATA_GF3232 of type_connection list
	| TYPE_GFDATA_BOOL of type_connection
	| TYPE_GFDATA_NULL
