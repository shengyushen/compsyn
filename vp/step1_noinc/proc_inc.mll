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
								try 
									List.find (fun x -> Sys.file_exists x) nl
								with Not_found -> begin
									Printf.fprintf stderr "fatal error : not found %s \n"  tfn1;
									exit 1
								end
							end
						end
						in 
						begin
							Printf.printf  "//using %s as %s\n" fn tfn1;
							let inputFileChannle = open_in fn in
							let lexbuf1 = Lexing.from_channel inputFileChannle in
							while (proc_inc pathlist lexbuf1)!=Eof do
								flush stdout;
							done
						end
						;
						Other
					}
      | '\n'                            { proc_inc pathlist lexbuf           }
      | _                               { proc_include pathlist lexbuf      }
