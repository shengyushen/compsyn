open Typedef
open Sys
open Print_v
open Elabmod

(*open the temp dir*)
let tempdirname = (String.concat "" ["./";"container_";Sys.argv.(3);"/"]);;

(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let elabModName = Sys.argv.(2) ;;
let inputFileChannle = open_in inputFileName;;
let lexbuf = Lexing.from_channel inputFileChannle;;
let very_struct = Parser.source_text Very.verilog lexbuf ;;
close_in  inputFileChannle ;; 

(*regenerate the parsed file to be verified by formality*)
(*begin
	command (String.concat "" ["mkdir "  ;tempdirname; "parseout"]) ;
	let parseout = open_out (String.concat "" [tempdirname ; "parseout/" ; elabModName ;".v"])
	in
	print_v_source_text parseout very_struct
	;
	close_out parseout
end
;;*)

(*from arg 5 and so on, are the input and output spec*)
let rec get_inout curi = begin
	if curi >= Array.length (Sys.argv) then ([],[])
	else begin
		let (inl,outl)= begin
			match Sys.argv.(curi) with
			"-Input" -> ([Sys.argv.(curi+1)],[])
			| "-Output" -> ([],[Sys.argv.(curi+1)])
			| _ -> begin
				Printf.printf "fatal error : improper io list\n";
				exit 1
			end
		end
		and (nextinl,nextoutl)=get_inout (curi+2)
		in
		((inl@nextinl),(outl@nextoutl))
	end
end
;;

let (instrlist,outstrlist) = get_inout 5 ;;

(*print_endline "====input list====";;
List.iter (fun x -> begin print_string "input list " ;print_endline x; end) instrlist;;

print_endline "====output list====";;
List.iter (fun x -> begin print_string "output list "; print_endline x; end) outstrlist;;
*)

let findOneModuleInVerystruct modName = begin
	let matchModuleName mn = fun md -> begin
		match md with 
		T_module_def(mn1,_,_) -> Misc.string_equ mn mn1
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
;;
let module2beElaborated = findOneModuleInVerystruct elabModName;;

let newElabModule = new elabmod ;;
newElabModule#init module2beElaborated tempdirname ;;

(*command (String.concat "" ["mkdir "  ;tempdirname; "dumpout"]) ;;
let dumpout = open_out (String.concat "" [tempdirname ; "dumpout/" ; elabModName ;".v"]);;
newElabModule#print dumpout;;
close_out dumpout;*)

(*let compsynM = new compsyn newElabModule;;
compsynM#compsyn instrlist outstrlist ;;*)
newElabModule#compsyn instrlist outstrlist ;;

exit 0

