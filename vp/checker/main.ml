
(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
(*
let elabModName = Sys.argv.(2) ;;
let tmpDirName = Sys.argv.(3) ;;
*)
(*open the temp dir*)
(*
let tempdirname = (String.concat "" ["./";"container_";tmpDirName;"/"]);;
*)
let start_time = Unix.gettimeofday ();;

(*Manager.set_gc 1000000 (Gc.full_major) (Gc.full_major)
;;
*)

let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;

lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = inputFileName };;

let very_struct = Parser.source_text (Very.veriloglex ) lexbuf ;;

close_in  inputFileChannle ;; 
