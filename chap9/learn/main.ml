open Printf
open Arg
open Misc

(*showing how to parse command line*)
let usage_string = "checker.exe -I [include path] -i [int option]  -D [dst path] -D [dst path2] -d|-nd  anonymous"
and istring = ref ""
and iint = ref 0
and dpathlist = ref []
and debug = ref false
and anon_param = ref ""
;;

let addDpath str = begin
	dpathlist := str::(!dpathlist)
end
and anon_fun str = begin
	anon_param := str
end
in
let old_spec_list = [
("-I",Set_string(istring)," only one -I option can use Set_*");
("-i",Set_int(iint),   " only one -i option can use Set_*");
("-D",String(addDpath),   " multiple -D need to call function to add");
("-d",Set(debug),         " setting a flag");
("-nd",Clear(debug),      " clear a flag")
]
in
let spec_list = align old_spec_list
in
parse spec_list anon_fun usage_string
;;

printf "-I %s\n" !istring;;
printf "-i %d\n" !iint;;
List.iter (printf "-D %s\n") !dpathlist;;
printf "-d %b\n" !debug;;
printf "anon_param %s\n" !anon_param;;


(*module system*)
(*instanation of Set*)
module StringSet = SSYSet (OrderingString);;
begin
	let x = StringSet.add "ssy" (StringSet.empty )
	in
	let y = StringSet.add "ssd" x
	in
	StringSet.print y
	;
	
	printf "\n"
end
;;

begin
	let objssy = new ssy 1
	in 
	objssy#display 2
end
;;

class ssy2 initv = 
object 
	inherit ssy 200 as super
	method get_internal = begin
		super#get_internal
	end

	initializer begin
		internal_initv <- initv
	end
end
;;
begin
	printf "\n\n\n";
	let objssy2 = new ssy2 1
	in  begin
		printf "get_internal %d\n" (objssy2#get_internal ());
		objssy2#display 150
		(*the display result shows that the new initializer called after 
		 the super#initializer*)
	end
end
;;


begin
	printf "\n\n\n";
	printf "now in circule 1\n";
	let newssy= new ssy 1000
	in
	let new_circle = new circule newssy
	in
	new_circle#display ()
end
;;

begin
	printf "\n\n\n";
	printf "now in circule2 1\n";
	let newssy= new ssy_inhet 1000
	in
	let new_circle = new circule2 newssy
	in
	new_circle#display ()
end
;;

begin
	printf "\n\n\n";
	printf "now in coercion\n";
	let newssy= new ssy_inhet 10000
	and oldssy= new ssy 11
	and newssy_another = new ssy_another 12
	in begin
		newssy#display 100000;


		printf "\n\n\n";
		printf "after coercion\n";
		(*let newssy_ssy = ((new ssy_2arg 1 2) :> ssy )*)
		let newssy_ssy = new ssy_2arg 1 2
		in
		let newssylist=[oldssy;newssy;newssy_ssy;newssy_another]
		in begin
			List.iter (fun x -> x#display 1) newssylist
		end
	end
end
;;

begin
	printf "\n\n\n";
	printf "in fun and function\n";
	let f1 x y = x+y
	and f2 = fun x y -> x+y
	and f3 x = function y  -> x+y
	and f4 x = function `A -> 1 | `B -> 2 | _ -> 3
	in
	let f4res = (f4 1 `A)
	in
	printf "%d %d %d %d\n"  (f1 1 2) (f2 1 2) (f3 1 2) f4res
end
;;
