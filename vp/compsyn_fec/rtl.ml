open Typedef
open Elabmod
open Misc
open Sys
open Elabmod

exception No_such_clock

type eventype=Noedge | Edge

class rtl  = fun very_struct_init tmpdirname1  ->
object (self)

(*rtl syntax tree*)
	val very_struct = very_struct_init

(*temp dir and their various files*)
	val tmpdirname = tmpdirname1
	
	val mutable elaboratedModuleList : elabmod list = []

	method elaborate elabModName = begin
		(*we dont want to deal with parameter now*)
		(*if (List.length paramlist) != 0 then begin
			Printf.printf "fatal error : parameter is not supported at this stage\n";
			exit 1
		end
		;*)
		(*find this exact module definition*)
		let module2beElaborated = self#findOneModuleInVerystruct elabModName
		in 
		let newElabModule = new elabmod 
		in begin
			newElabModule#init module2beElaborated tmpdirname;
			elaboratedModuleList <- newElabModule::elaboratedModuleList
		end
	end
(*
	method link elabModName = begin
		(*actually some previous elaborate code should be placed here
		  that is to say, elaborate it only deal with a module himself
		  and link take care of issue between multiple module
		*)
	end
*)
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
	
	
	method compsyn stepList unfoldNumber= begin
		match elaboratedModuleList with
		[topmod] -> topmod#compsyn stepList unfoldNumber
	end
end
;;
