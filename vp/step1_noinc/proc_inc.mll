{
	(*this is the list of definition*)
	let def_list = ref [("","")] ;

	exception Ssyeof of string
	
	type token = 
              | DIRECTIVE_include
              | Other
              | Eof
              | Eol
}

rule proc_inc pathlist = parse
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Other
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf
		}
	| "`include"			{   
			proc_include pathlist lexbuf ; 
			DIRECTIVE_include 
		}
	| eof				{ 
			Eof                      
		}
	| '\n'				{
			Lexing.new_line lexbuf ;
			Printf.printf "\n";
			Other
		}
	| [^ '\n' '`' '/']+ as ssss		{
			print_string ssss; 
			Other
		}
	| _ as lsm				{
			print_char lsm; 
			Other
		}
and comment depth stpos = parse
	"*/" as cmt  { (*end of current comment*)
		print_string cmt;
		if(depth==1) then (*the first level of nested comment*)
			Other
		else
			comment (depth-1) stpos lexbuf
		}
	| "/*" as cmt {  (*new nested comment*)
			print_string cmt;
			comment (depth+1) stpos lexbuf
		}
	| '\n' as lsm {
			print_char lsm; 
			Lexing.new_line lexbuf ;
			comment depth stpos lexbuf
		}
	| _ as lsm {
			print_char lsm; 
			comment depth stpos lexbuf
		}
and proc_include pathlist = parse 
	"//" [^ '\n']* '\n'  as cmt  {
			print_string cmt;
			proc_include pathlist lexbuf
		}
	| "/*"   as cmt               { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_include pathlist lexbuf
		}
	| '"'[^ '"' '\n']+'"' as filename	{
			let tfn1=String.sub filename 1 ((String.length filename)-2) 
			in
			let fn = begin
				if Sys.file_exists tfn1 then tfn1
				else begin
					let nl = List.map (fun x -> x ^ "/" ^ tfn1) pathlist
					in
					let found_filename= begin
						try 
							List.find (fun x -> Sys.file_exists x) nl
						with Not_found -> begin
							Printf.printf  "\n// FATAL : not found %s \n"  tfn1;
							""
						end
					end
					in begin
						Printf.printf "\n// INFO : using %s as %s\n" found_filename tfn1;
						found_filename
					end
				end
			end
			in 
			begin
				if(fn<>"") then begin
					Printf.printf  "\n`line 1 \"%s\" 1\n" fn ;
					let inputFileChannle = open_in fn in
					let lexbuf1 = Lexing.from_channel inputFileChannle 
					in begin
						lexbuf1.Lexing.lex_curr_p <- { lexbuf1.Lexing.lex_curr_p with pos_fname = fn};
						while (proc_inc pathlist lexbuf1)!=Eof do
							flush stdout;
						done
					end
					;			
					Printf.printf  "\n//jump back to %s\n" (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname);
					Printf.printf  "\n`line %d \"%s\" 2\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)+1) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
					close_in inputFileChannle
				end
			end
			;
			Other
	}
	| '\n'  as lsm { 
			print_char lsm; 
			proc_inc pathlist lexbuf           
		}
	| _  as lsm   { 
			print_char lsm; 
			proc_include pathlist lexbuf      
		}
