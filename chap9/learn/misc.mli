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
	val mutable internal_initv : int
	method display : int -> unit
	method private get_internal : unit -> int
end

class ssy_another  :
int ->
object
	val mutable internal_initv : int
	method display : int -> unit
	method private get_internal : unit -> int
end

class ssy_2arg :
int -> int ->
object
	method display : int -> unit
end

class ssy_inhet :
int ->
object 
	method display : int -> unit
end

class ['a] circule : 
'a -> 
object
	(*constraint is a powerful mechanism 
	that can specify a member function*)
(*	constraint 'a = <display : int -> unit ;..>*)
	(*a little stronger version with full class*)
	constraint 'a = #ssy
	val mutable v : 'a
	method display : unit -> unit
end

class ['a] circule2 : 
'a -> 
object 
	constraint 'a = #ssy_inhet
	val mutable v : 'a
	method display : unit -> unit
	
end
