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
	
	
	method compsynRTL additiveMod multplicativeMod  = begin
		let (zero,addFieldSize) = begin
			let addMod = new elabmod debugFlag
			and addMod2beElabotated = self#findOneModuleInVerystruct additiveMod
			in begin
				addMod#init addMod2beElabotated tmpdirname;
				addMod#encoderCNF;

				(* 		inferring field size *)
				let addFieldSize = addMod#getFieldSize
				in 
				let addZero = begin
					printf "Info : working on field GF(2^%d)\n" addFieldSize;
					(* 1.	checking additive closure : dont need*)
					(* 2.	checking additive Abelian *)
					addMod#checkingAbelian;
					(* 3.	checking additive associative *)
					addMod#checkingAssiciative;
					(* 4.	finding out additive zero *)
					addMod#inferZero [];
				end
				in begin
					addMod#checkingInverse [] addZero;
					(addZero,addFieldSize)
				end
			end
		end
		in
		let one = begin
			let mulMod = new elabmod debugFlag
			and mulMod2beElaborated = self#findOneModuleInVerystruct multplicativeMod
			in begin
				mulMod#init mulMod2beElaborated tmpdirname;
				mulMod#encoderCNF;

				let mulFieldSize = mulMod#getFieldSize
				in
				let mulOne = begin
					assert (addFieldSize = mulFieldSize);
					mulMod#checkingAbelian;
					(* 			this is slow and should be verified with formality *)
					(* 			mulMod#checkingAssiciative; *)
					mulMod#inferZero [zero]
				end
				in begin
					(* 5.	checking inverse *)
 					mulMod#checkingInverse [zero] mulOne; 
					(* 6.	checking distribution will be done by formality*)
					flush stdout;
					mulOne
				end
			end
		end
		in 
		let fo = open_out "fieldInfo"
		in begin
(* 		printing out the field character *)
			fprintf fo "%d\n" addFieldSize;
			List.iter (fprintf fo "%d" ) zero;
			fprintf fo "\n";
			List.iter (fprintf fo "%d") one;
			fprintf fo "\n";

			close_out fo
		end
(*
		in 
		let	topmod = new elabmod debugFlag
		and module2beElaborated = self#findOneModuleInVerystruct elabModName
		in begin
			topmod#init module2beElaborated tmpdirname;
	 		topmod#compsyn stepList unfoldNumber notUsedOutputList 
		end
*)
	end
end
;;
