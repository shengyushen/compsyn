open Rtl
open Sys
open Print_v

(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let elabModName = Sys.argv.(2) ;;
let tmpDirName = Sys.argv.(3) ;;

(*open the temp dir*)
let tempdirname = (String.concat "" ["./";"container_";tmpDirName;"/"]);;

let start_time = Unix.gettimeofday ();;

(*Manager.set_gc 1000000 (Gc.full_major) (Gc.full_major)
;;
*)

let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;

let very_struct = Parser.source_text Very.verilog lexbuf ;;
close_in  inputFileChannle ;; 

(*regenerate the parsed file to be verified by formality*)
begin
	command (String.concat "" ["mkdir "  ;tempdirname; "parseout"]) ;
	let parseout = open_out (String.concat "" [tempdirname ; "parseout/" ; elabModName ;".v"])
	in
	print_v_source_text parseout very_struct
	;
	close_out parseout
end
;;

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

print_endline "====input list====";;
List.iter (fun x -> begin print_string "input list " ;print_endline x; end) instrlist;;

print_endline "====output list====";;
List.iter (fun x -> begin print_string "output list "; print_endline x; end) outstrlist;;


let objRTL = new rtl very_struct tempdirname ;;

objRTL#elaborate elabModName ;;

begin
	command (String.concat "" ["mkdir "  ;tempdirname; "dumpout"]) ;
	let dumpout = open_out (String.concat "" [tempdirname ; "dumpout/" ; elabModName ;".v"])
	in
	objRTL#print_rtl elabModName dumpout
	;
	close_out dumpout
end
;;

(*we dont use bound any more*)
objRTL#compsyn  instrlist outstrlist;;

exit 0

