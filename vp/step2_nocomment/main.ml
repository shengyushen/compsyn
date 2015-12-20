let start_time = Unix.gettimeofday ();;

let inputFileName = Sys.argv.(1) ;; 

let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;

lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = inputFileName };;

let parseverilog lexbuf1 = 
	while true do
		if (Preproc.preproc lexbuf1)==Preproc.Eof then  raise (Preproc.Ssyeof "Ssyeof") ;
		flush stdout;
	done
;;

try
	parseverilog lexbuf
with Preproc.Ssyeof s -> 
		let end_time = Unix.gettimeofday ();
		in
		Printf.fprintf stderr "TIME : end %f \n" (end_time -. start_time)
		;
		exit 0
;;
