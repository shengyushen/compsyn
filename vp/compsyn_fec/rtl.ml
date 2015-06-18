open Typedef
open Elabmod
open Misc
open Sys
open Elabmod
open Printf

exception No_such_clock

type eventype=Noedge | Edge

class rtl  = fun very_struct_init tmpdirname1  debugFlag->
object (self)

(*rtl syntax tree*)
	val very_struct = very_struct_init

(*temp dir and their various files*)
	val tmpdirname = tmpdirname1
	

	method findOneModuleInVerystruct modName = begin
		let matchModuleName mn = fun md -> begin
			match md with 
			T_module_def(mn1,_,_) ->  mn=mn1
			| _ -> begin
				Printf.printf "fatal error: %s\n" "findOneModuleInVerystruct should not find anything other than T_module_def";
				print_string modName;
				exit 1
			end
		end
		in
		let matchedModuleList=List.filter (matchModuleName modName) very_struct
		in begin
			if (List.length matchedModuleList)!=1 then begin
				Printf.printf "fatal error : %s\n" "0 means nothing found , more then 1 means too many";
				Printf.printf "%s\n"modName;
				print_int (List.length matchedModuleList);
				exit 1
			end
			else List.hd matchedModuleList
		end
	end
	
	
	method compsynRTL elabModName stepList unfoldNumber notUsedOutputList fieldSize zero one = begin
		printf "fieldSize is %d\n"  fieldSize;
		printf "zero is : ";
		List.iter (printf "%d" ) zero;
		printf "\n";
		printf "one is : ";
		List.iter (printf "%d") one;
		printf "\n";

		let	topmod = new elabmod debugFlag
		and module2beElaborated = self#findOneModuleInVerystruct elabModName
		in begin
			topmod#init module2beElaborated tmpdirname;
	 		topmod#compsyn stepList unfoldNumber notUsedOutputList fieldSize zero one
		end
	end
end
;;
