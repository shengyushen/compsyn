open Printf

type comparison = Less | Equal | Great
;;

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

class virtual ssy_virtual initv = 
object (self)
	method virtual display : int -> unit
end


class ssy initv = 
object (self)
	(*notice that the virtual ssy_virtual have one parameter initv
	so we also need to set a initv (or an int const) here*)
	inherit ssy_virtual 100
	val mutable internal_initv = 0
	method display i = begin
		printf "init %d\n" initv;
		printf "internal_initv %d\n" (self#get_internal ());
		printf "i %d\n" i
	end

	method private get_internal () = begin
		internal_initv
	end

	initializer begin
		internal_initv <- initv
	end
end

class ssy_another initv = 
object (self)
	val mutable internal_initv = 0
	val mutable sdf=0
	method display i = begin
		printf "another\n";
		printf "init %d\n" initv;
		printf "internal_initv %d\n" (self#get_internal ());
		printf "i %d\n" i
	end

	method private get_internal () = begin
		internal_initv
	end

	initializer begin
		internal_initv <- initv
	end
end

class ssy_2arg initv (i2 : int) =
object
	inherit ssy initv as super
	val mutable ii2=i2
	method display i = begin
		super#display i;
		printf "more on ssy_2arg %d\n" ii2
	end
end

class ssy_inhet initv = 
object 
	inherit ssy initv as super
	val mutable ssy2 = 2*initv
	method display i = begin
		super#display i;
		printf "additional in ssy_inhet\n";
		printf "%d\n" ssy2
	end
end


class ['a] circule (c:'a) = 
object
	constraint 'a = <display : int -> unit ;..>
	val mutable v =c 
	method display () = begin
		printf "now in circule\n";
		v#display 1
	end
end


class ['a] circule2 (c:'a) = 
object
	constraint 'a = <display : int -> unit ;..>
	val mutable v =c 
	method display () = begin
		printf "now in circule\n";
		v#display 1
	end
end


