type comparison = Less | Equal | Great
;;

(*module type is some virtual module*)
module  type ORDERED_TYPE =
sig
	type t
	val compare : t -> t -> comparison
	val print : t -> unit
end

module SSYSet :
functor (Elt : ORDERED_TYPE) -> 
sig
	type element  = Elt.t
	type set 
	val empty : set

	val add : element -> set -> set
	val member : element -> set -> bool
	val print : set -> unit
end

module OrderingString :
sig
	type t = string
	val compare : t -> t -> comparison
	val print : t -> unit
end

class ssy  :
int ->
object
	method display : int -> unit
end
