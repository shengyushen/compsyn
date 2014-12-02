open Typedef
open Typedefcommon
open Circuit_obj
open Elabmod
open Misc
open Misc2
open Sys
open Elabmod

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
	end
(*
	method link elabModName = begin
		(*actually some previous elaborate code should be placed here
		  that is to say, elaborate it only deal with a module himself
		  and link take care of issue between multiple module
		*)
	end
*)
	
	method print_rtl modName dumpout = begin
		let matchModName emod = begin
			if (string_equ modName (emod#getname)) then true
			else false
		end
		in
		let emod=List.find matchModName elaboratedModuleList
		in
		emod#print dumpout
	end
	
	method compsyn (*(bound:int)*)  (instrlist:string list) (outstrlist:string list) = begin
		match elaboratedModuleList with
		[topmod] -> topmod#compsyn (*bound*) instrlist outstrlist
	end
end
;;
