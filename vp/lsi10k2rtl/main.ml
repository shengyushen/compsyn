open Rtl
open Sys
open Print_v

(*open the temp dir*)
let tempdirname = "lsi10k2rtl/";;
command (String.concat " " ["rm -rf " ;tempdirname]);;
command (String.concat " " ["mkdir "  ;tempdirname]);;

let start_time = Unix.gettimeofday ();;

(*Manager.set_gc 1000000 (Gc.full_major) (Gc.full_major)
;;
*)
(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let elabModName = Sys.argv.(2) ;;

let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;

let very_struct =
Parser.source_text Very.verilog lexbuf
;;
close_in  inputFileChannle
;; 

(*regenerate the parsed file to be verified by formality*)
begin
	(*command (String.concat "" ["mkdir "  ;tempdirname; "lsi10k2rtl"]) ;*)
	let parseout = open_out "lsi10k2rtl/parse.v"
	in
	print_v_source_text parseout very_struct
	;
	close_out parseout
end
;;

(*
(*from arg 6 and so on, are the input and output spec*)
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

let (instrlist,outstrlist) = get_inout 6
;;


print_endline "====input list====";;
List.iter (fun x -> begin print_string "input list " ;print_endline x; end) instrlist;;

print_endline "====output list====";;
List.iter (fun x -> begin print_string "output list "; print_endline x; end) outstrlist;;
*)

let objRTL = new rtl very_struct tempdirname 
;;

(*we dont support parameter now, so I chose to remove [] to avoid type error*)
(*objRTL#elaborate elabModName []
;;*)
objRTL#elaborate elabModName
;;

begin
	let dumpout = open_out ("lsi10k2rtl_res.v")
	in
	objRTL#print_rtl elabModName dumpout
	;
	close_out dumpout
end
;;
 (*delay and length*)  (*io list to be used as dual syn*)
(*objRTL#compsyn (int_of_string Sys.argv.(4)) (int_of_string Sys.argv.(5)) instrlist outstrlist 
;;

(*
objRTL#flatten 
;;

objRTL#print_rtl_flat elabModName
;;

objRTL#print_exlif elabModName
;;
*)
let end_time = Unix.gettimeofday ();;
Printf.fprintf stderr "TIME : compsyn end %f \n" (end_time -. start_time);;

*)
