type comparison = Less | Equal | Great

(*abstract element type *)
module type ORDERED_TYPE =
sig
	type t
	val compare : t -> t -> comparison
	val print : t -> unit
end

(*functor is from struct to struct*)
module SSYSet =
functor (Elt : ORDERED_TYPE) -> struct
	type element  = Elt.t
	type set = element list
	let empty = []

	let rec add x s = begin
		match s with
		[] -> [x]
		| hd::tl -> begin
			match Elt.compare x hd with
			Less -> x::s
			| Equal -> s
			| Great -> hd::(add x tl)
		end
	end

	let rec member x s = begin
		match s with
		[] -> false
		| hd::tl -> begin
			match Elt.compare x hd with
			Less -> false
			| Equal -> true
			| Great -> member x tl
		end
	end

	let rec print s = begin
		match s with
		[] -> ()
		| hd::tl -> begin
			Elt.print hd ;
			print tl
		end
	end
end
(*implementation of ORDERED_TYPE*)
module OrderingString =
struct
	type t = string
	let compare x y = begin
		if(x = y) then Equal
		else if (x < y) then Less
		else Great
	end
	let print x = begin
		Printf.printf " %s " x
	end
end
(*instanation of Set*)
module StringSet = SSYSet (OrderingString)


