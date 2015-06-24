open Rtl
open Sys
open Misc
open Intlist

(*open the temp dir*)
let tempdirname = (String.concat "" ["./";"container_";Sys.argv.(3);"/"]);;

let start_time = Unix.gettimeofday ();;

(*Manager.set_gc 1000000 (Gc.full_major) (Gc.full_major)
;;
*)
(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let additiveMod = Sys.argv.(2) ;;
let multplicativeMod = Sys.argv.(3) ;;
let debugFlag = bool_of_string (Sys.argv.(4)) ;;


(*parsing stimulation*)

let objRTL= begin
	let inputFileChannle = open_in inputFileName
	in
	let lexbuf = Lexing.from_channel inputFileChannle
	in
	let very_struct = Parser.source_text Very.verilog lexbuf 
	in begin
		close_in  inputFileChannle ;
		new rtl very_struct tempdirname debugFlag
	end
end
in
begin
	objRTL#compsynRTL additiveMod multplicativeMod  ;
	exit 0
end;



