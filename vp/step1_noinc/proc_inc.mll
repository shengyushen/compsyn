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
     | "`include"			{ (*print_string "// `include " ; *)  proc_include pathlist lexbuf ; DIRECTIVE_include }
     | eof				{ Eof                      }
		 | '\n'				{
		 		Lexing.new_line lexbuf ;
				Printf.printf "\n";
				Other
		 	}
     | [^ '\n' '`' '/']+ as ssss		{
     						print_string ssss; Other
     					}
     | _ as lsm				{
						print_char lsm; Other
					}
and proc_include pathlist = parse 
	'"'[^ '"' '\n']+'"' as filename	{
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
										Printf.printf  "// FATAL : not found %s \n"  tfn1;
										""
									end
								end
								in begin
									Printf.printf "// INFO : using %s as %s\n" found_filename tfn1;
									found_filename
								end
							end
						end
						in 
						begin
							Printf.printf  "`line 1 \"%s\" 1\n" fn ;
							if(fn<>"") then begin
								let inputFileChannle = open_in fn in
								let lexbuf1 = Lexing.from_channel inputFileChannle 
								in begin
									lexbuf1.Lexing.lex_curr_p <- { lexbuf1.Lexing.lex_curr_p with pos_fname = fn};
									while (proc_inc pathlist lexbuf1)!=Eof do
										flush stdout;
									done
								end
								;
								Printf.printf  "//jump back to %s\n" (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname);
								Printf.printf  "`line %d \"%s\" 2\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)+1) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
								close_in inputFileChannle
							end
						end
						;
						Other
					}
      | '\n'                            { proc_inc pathlist lexbuf           }
      | _                               { proc_include pathlist lexbuf      }
