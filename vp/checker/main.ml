open Print_v

let start_time = Unix.gettimeofday ();;

let very_struct = begin
	let inputFileName = Sys.argv.(1) in
	let inputFileChannle = open_in inputFileName in
	let lexbuf = Lexing.from_channel inputFileChannle in begin
		lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = inputFileName };
		let very_struct = Parser.source_text (Very.veriloglex ) lexbuf in
		begin
			close_in  inputFileChannle ;
			very_struct
		end
	end
end
in
print_source_text stdout very_struct

;

