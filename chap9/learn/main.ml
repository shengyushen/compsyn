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
