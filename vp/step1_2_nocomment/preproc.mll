{
	(*this is the list of definition*)
	let def_list = ref [("","")] ;;
	let print_pos pos = begin
		Printf.printf "//%s " pos.Lexing.pos_fname;
		Printf.printf "Line %d " pos.Lexing.pos_lnum;
		Printf.printf "Char %d\n" (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
	end
	;;
	exception Ssyeof of string
	
	type token = 
		| DIRECTIVE_define
		| DIRECTIVE_else
		| DIRECTIVE_endif
		| DIRECTIVE_ifdef
		| DIRECTIVE_ifndef
		| Other
		| Eof
		| Eol

	let prt_fatal str = begin
		Printf.printf  "\n// FATAL CHECKER NODEF : %s \n"  str;
	end

}


rule preproc = parse
	"//" [^ '\n']* '\n' as cmt   {
			Lexing.new_line lexbuf ;
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			Other
		}
	| "\n" {
			print_endline "";
			Lexing.new_line lexbuf ;
			Eol
		}
	| "/*"              as cmt    { (*multiline comment*)
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			Other
		}
	| "`line"		 {
						print_string "`line";
						line_skip_blank  lexbuf
		}
	| eof				{ Eof                      }
	| [' ' '\t' 'a'-'z' 'A'-'Z' '0'-'9' '_']+ as ssss		{
			print_string ssss; Other
		}
	| _ as lsm				{
			print_char lsm; Other
		}
and comment depth stpos = parse
	"*/" as cmt  { (*end of current comment*)
		if(depth==1) then (*the first level of nested comment*)
			Other
		else
			comment (depth-1) stpos lexbuf
		}
	| "/*" as cmt {  (*new nested comment*)
			comment (depth+1) stpos lexbuf
		}
	| '\n' as lsm {
			Lexing.new_line lexbuf ;
			comment depth stpos lexbuf
		}
	| _ as lsm {
			comment depth stpos lexbuf
		}
and line_skip_blank  = parse
	[' ' '\t']+	{
		line_number  lexbuf
	}
	| _ {
		prt_fatal "`line must be followed by blanks and line number and  filename";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		Other
	}
and line_number  = parse
	['0'-'9']+ as linenum {
		let ln = int_of_string linenum
		in begin
			if(ln<=0) then begin
				Printf.printf "Warning : line number <=0 may leads to incorrect referring to original files\n";
				print_pos (lexbuf.Lexing.lex_curr_p)
			end
			;
			Printf.printf " %s" linenum;
			line_skip_blank2  (ln-1) lexbuf
		end
	}
	| _ {
		prt_fatal "`line and blanks must be followed by line number and  filename";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		Other
	}
and line_skip_blank2  ln = parse
	[' ' '\t']+	{
		line_filename  ln lexbuf
	}
	| _ {
		prt_fatal "`line and blanks and line number must be followed by  blanks";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		Other
	}
and line_filename  ln = parse
	'\"' [^ '\n' ' ' '\t' ]+ '\"' as fn {
		let realfn = String.sub fn 1 ((String.length fn)-2)
		in begin
			lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = realfn };
			lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_lnum  = ln };
			Printf.printf " \"%s\" " realfn;
			endofline lexbuf;
			Other
		end
	}
	| _ {
		prt_fatal "`line and blanks and line number and blanks must be followed by filename";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		Other
	}
and endofline = parse
	'\n' {
			print_endline "";
			let endpos=Lexing.lexeme_end_p lexbuf
			in begin
				Lexing.new_line lexbuf;
				Eol
			end
		}
	| eof {
			Eof
		}
	| _ as lxm {
			print_char lxm;
			endofline lexbuf
		}
