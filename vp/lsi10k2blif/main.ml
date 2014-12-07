open Sys
open Print_v

(*open the temp dir*)

(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let elabModName = Sys.argv.(2) ;;
let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;
let very_struct = Parser.source_text Very.verilog lexbuf ;;
close_in  inputFileChannle ;; 

(*regenerate the parsed file to be verified by formality*)
begin
	let parseout = open_out "lsi10k2blif_res.blif"
	in
	print_v_source_text parseout very_struct
	;
	close_out parseout
end
;;


exit 0

