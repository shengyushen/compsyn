open Typedef
open Elabmod
open Misc
open Sys
open Elabmod

exception No_such_clock

type eventype=Noedge | Edge

class rtl  = fun very_struct_init tmpdirname1  debugFlag->
object (self)

(*rtl syntax tree*)
	val very_struct = very_struct_init

(*temp dir and their various files*)
	val tmpdirname = tmpdirname1
	
	val mutable topmod = new elabmod debugFlag
	val mutable addMod = new elabmod debugFlag
	val mutable mulMod = new elabmod debugFlag

	method elaborate elabModName additiveMod multplicativeMod = begin
		let module2beElaborated = self#findOneModuleInVerystruct elabModName
		and addMod2beElabotated = self#findOneModuleInVerystruct additiveMod
		and mulMod2beElaborated = self#findOneModuleInVerystruct multplicativeMod
		in begin
			topmod#init module2beElaborated tmpdirname;
			addMod#init addMod2beElabotated tmpdirname;
			mulMod#init mulMod2beElaborated tmpdirname;
		end
	end

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
	
	
	method compsyn stepList unfoldNumber notUsedOutputList = begin
(* 		inferring field size *)
		let addFieldSize = addMod#getFieldSize
		and mulFieldSize = mulMod#getFieldSize
		in begin
			assert (addFieldSize = mulFieldSize);
			printf "Info : working on field GF(2^%s)\n" addFieldSize;
			addMod#encoderCNF;
		

(* 1.	checking additive closure : dont need*)
(* 2.	checking Abelian *)
			addMod#checkingAbelian;
(* 3.	associative *)
(* 4.	zero *)
(* 5.	inverse *)

			addMod#inferZero;
	 		topmod#compsyn stepList unfoldNumber notUsedOutputList 
		end
	end
end
;;
