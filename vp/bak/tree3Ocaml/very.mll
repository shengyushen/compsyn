{
open Parser
open Printf
}

let unsigned_number= ['0'-'9']+

rule veriloglex  = parse
	unsigned_number as lxm {
			let lxm_no_ =  int_of_string lxm
			in
			UNSIGNED_NUMBER(lxm_no_)
		}
	| "NULL" { NULL(Lexing.lexeme lexbuf) }
	| "(" { LPARENT(Lexing.lexeme lexbuf) }
	| ")" { RPARENT(Lexing.lexeme lexbuf) }
	| ' '|'\n'|'\t'|'\r' {veriloglex lexbuf}
	| _ {
		Printf.printf "FATAL : incorrect syntax\n";
		veriloglex lexbuf
	}
{
}

