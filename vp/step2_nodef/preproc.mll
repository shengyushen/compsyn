{
	(*this is the list of definition*)
	let def_list = ref [("","")] 

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
}


rule preproc = parse
     | "`define"			{
						proc_define lexbuf ;
						DIRECTIVE_define 
     					}
     | "`ifdef"				{ proc_ifdef lexbuf; DIRECTIVE_ifdef }
     | "`ifndef"			{ proc_ifndef lexbuf; DIRECTIVE_ifndef }
     | '`'['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as defname {
						begin
						match defname with
							| "`accelerate"			-> print_string "`accelerate"
							| "`autoexpand_vectornets"	-> print_string "`autoexpand_vectornets"
							| "`celldefine"			-> print_string "`celldefine"
							| "`default_nettype"		-> print_string "`default_nettype"
							| "`define"			-> print_string "`define"
							| "`else"			-> print_string "`else"
							| "`endcelldefine"		-> print_string "`endcelldefine"
							| "`endif"			-> print_string "`endif"
							| "`endprotect"			-> print_string "`endprotect"
							| "`endprotected"		-> print_string "`endprotected"
							| "`expand_vectornets"		-> print_string "`expand_vectornets"
							| "`ifdef"			-> print_string "`ifdef"
							| "`include"			-> print_string "`include"
							| "`noaccelerate"		-> print_string "`noaccelerate"
							| "`noexpand_vectornets"	-> print_string "`noexpand_vectornets"
							| "`noremove_gatenames"		-> print_string "`noremove_gatenames"
							| "`noremove_netnames"		-> print_string "`noremove_netnames"
							| "`nounconnected_drive"	-> print_string "`nounconnected_drive"
							| "`protect"			-> print_string "`protect"
							| "`protected"			-> print_string "`protected"
							| "`remove_gatenames"		-> print_string "`remove_gatenames"
							| "`remove_netnames"		-> print_string "`remove_netnames"
							| "`resetall"			-> print_string "`resetall"
							| "`timescale"			-> print_string "`timescale"
							| "`unconnected_drive"		-> print_string "`unconnected_drive"
							| _ ->		try 
										let defedname = List.assoc (String.sub defname 1 ((String.length defname)-1)) !def_list in
										print_string defedname
									with Not_found -> begin
										Printf.fprintf stderr "%s" "no such definition";
										Printf.fprintf stderr "%s" defname;
										exit 1
									end 
						end
						;
						Other
					}
     | eof				{ Eof                      }
     | [^ '`' '\n']+ as ssss		{
     						print_string ssss; Other
     					}
     | _ as lsm				{
						print_char lsm; Other
					}
and preproc_str = parse
     '`'['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as defname {
						begin
									try 
										(List.assoc (String.sub defname 1 ((String.length defname)-1)) !def_list) ^ (preproc_str lexbuf)
									with Not_found -> begin
										Printf.fprintf stderr "%s" "no such definition in preproc_str \n";
										Printf.fprintf stderr "%s" defname;
										exit 1
									end 
						end
					}
     | eof				{ ""                      }
     | _ as lsm				{
						(Printf.sprintf "%c" lsm) ^ (preproc_str lexbuf)
					}
and proc_define = parse 
	['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def 	{
										proc_defined def lexbuf
									}
	| _ as lsm 	{
				proc_define lexbuf
			}
and proc_defined def = parse 
	[' ' '\t']+ as lsm	{
					proc_defined def lexbuf
				}
	| [^ '\n' ' ' '\t'][^ '\n' ]* as defed1			{
										(*if defed contain other macros?*)
										let defed2=preproc_str (Lexing.from_string defed1)
										in
										let defed = begin
											let rec proc_trim_blank str2trim= begin
												let lastc= String.get str2trim ((String.length str2trim)-1)
												in
												if (lastc=' ') || (lastc='\t') then proc_trim_blank (String.sub str2trim 0 ((String.length str2trim)-1))
												else str2trim
											end
											in 
											proc_trim_blank defed2
										end
										in
										def_list:=(def,defed)::(List.remove_assoc def !def_list);
									}
	| _ as lsm							{
										def_list:=(def,"")::(List.remove_assoc def !def_list);
									}
and proc_ifdef  = parse 
	['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def	{
									(*if it is defined?*)
									let found = 
									try 
										List.assoc def !def_list ;
										1
									with Not_found -> 0
									in 
									if found == 0 then begin
										do_else lexbuf
									end
									else begin
										do_then lexbuf
									end
									;
									Other
									}
     | _ as lsm				{
     						print_char lsm;
						proc_ifdef lexbuf; 
						Other 
					}
and proc_ifndef  = parse 
	['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def	{
									(*if it is defined?*)
									let found = 
									try 
										List.assoc def !def_list ;
										1
									with Not_found -> 0
									in 
									if found == 1 then begin
										do_else lexbuf
									end
									else begin
										do_then lexbuf
									end
									;
									Other
									}
     | _ as lsm				{
     						print_char lsm;
						proc_ifndef lexbuf; 
						Other 
					}
and do_then  = parse 
      "`ifdef"				{
      						proc_ifdef lexbuf; 
						do_then lexbuf; 
						DIRECTIVE_ifdef 
					}
      | "`ifndef"			{
      						proc_ifndef lexbuf; 
						do_then lexbuf; 
						DIRECTIVE_ifndef 
					}
     | "`else"				{
     						skip_else lexbuf; 
						DIRECTIVE_else 
					}
     | "`endif"				{
						DIRECTIVE_endif 
					}
     | "`define"			{
						proc_define lexbuf ;
						do_then lexbuf; 
						DIRECTIVE_define 
     					}
     | '`'['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as defname {
						begin
						match defname with
							| "`accelerate"			-> print_string "`accelerate"
							| "`autoexpand_vectornets"	-> print_string "`autoexpand_vectornets"
							| "`celldefine"			-> print_string "`celldefine"
							| "`default_nettype"		-> print_string "`default_nettype"
							| "`define"			-> print_string "`define"
							| "`else"			-> print_string "`else"
							| "`endcelldefine"		-> print_string "`endcelldefine"
							| "`endif"			-> print_string "`endif"
							| "`endprotect"			-> print_string "`endprotect"
							| "`endprotected"		-> print_string "`endprotected"
							| "`expand_vectornets"		-> print_string "`expand_vectornets"
							| "`ifdef"			-> print_string "`ifdef"
							| "`include"			-> print_string "`include"
							| "`noaccelerate"		-> print_string "`noaccelerate"
							| "`noexpand_vectornets"	-> print_string "`noexpand_vectornets"
							| "`noremove_gatenames"		-> print_string "`noremove_gatenames"
							| "`noremove_netnames"		-> print_string "`noremove_netnames"
							| "`nounconnected_drive"	-> print_string "`nounconnected_drive"
							| "`protect"			-> print_string "`protect"
							| "`protected"			-> print_string "`protected"
							| "`remove_gatenames"		-> print_string "`remove_gatenames"
							| "`remove_netnames"		-> print_string "`remove_netnames"
							| "`resetall"			-> print_string "`resetall"
							| "`timescale"			-> print_string "`timescale"
							| "`unconnected_drive"		-> print_string "`unconnected_drive"
							| _ ->		try 
										let defedname = List.assoc (String.sub defname 1 ((String.length defname)-1)) !def_list in
										print_string defedname;
										(*this is not same as that of preproc*)
										do_then lexbuf;
										()
									with Not_found -> begin
										Printf.fprintf stderr "%s" "no such definition";
										Printf.fprintf stderr "%s" defname;
										exit 1
									end 
						end
						;
						Other
					}
     | [^ '`']* as lsm			{
     						print_string lsm;
						do_then lexbuf; 
						Other
					}
     | _ as lsm				{
     						print_char lsm; 
						do_then lexbuf; 
						Other 
					}
and skip_else  = parse 
      "`ifdef"				{
      						proc_ifdef_inskip lexbuf; 
						skip_else lexbuf; 
						DIRECTIVE_ifdef 
					}
      | "`ifndef"			{
      						proc_ifdef_inskip lexbuf; 
						skip_else lexbuf; 
						DIRECTIVE_ifndef 
					}
     | "`endif"				{
     						DIRECTIVE_endif 
					}
     | [^ '`']* as lsm			{
						skip_else lexbuf; 
						Other
					}
     | _ as lsm				{
     						skip_else lexbuf;
						Other 
					}
and proc_ifdef_inskip  = parse 
      "`ifdef"				{
      						proc_ifdef_inskip lexbuf; 
      						proc_ifdef_inskip lexbuf; 
						DIRECTIVE_ifdef 
					}
      | "`ifndef"				{
      						proc_ifdef_inskip lexbuf; 
      						proc_ifdef_inskip lexbuf; 
						DIRECTIVE_ifndef 
					}
     | "`endif"				{
						DIRECTIVE_endif 
					}
     | [^ '`']* as lsm			{
						proc_ifdef_inskip lexbuf; 
						Other
					}
     | _ as lsm				{
						proc_ifdef_inskip lexbuf; 
						Other 
					}
and do_else  = parse 
     "`ifdef"				{
						proc_ifdef_inskip lexbuf ; 
						do_else lexbuf ;
						Other
					}
     | "`ifndef"				{
						proc_ifdef_inskip lexbuf ; 
						do_else lexbuf ;
						Other
					}
     | "`else"				{
     						do_else_in lexbuf ; 
						Other
     					}
     | "`endif"				{
						DIRECTIVE_endif 
					}
     | [^ '`']* as lsm			{
						do_else lexbuf; 
						Other
					}
     | _ 				{
						do_else lexbuf; 
						Other 
					}
and do_else_in  = parse 
     "`ifdef"				{
						proc_ifdef lexbuf ; 
						do_else_in lexbuf ; 
						Other
					}
     | "`ifndef"				{
						proc_ifndef lexbuf ; 
						do_else_in lexbuf ; 
						Other
					}
     | "`endif"				{
						DIRECTIVE_endif 
					}
     | "`define"			{
						proc_define lexbuf ;
						do_else_in lexbuf ; 
						DIRECTIVE_define 
     					}
     | '`'['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as defname {
						begin
						match defname with
							| "`accelerate"			-> print_string "`accelerate"
							| "`autoexpand_vectornets"	-> print_string "`autoexpand_vectornets"
							| "`celldefine"			-> print_string "`celldefine"
							| "`default_nettype"		-> print_string "`default_nettype"
							| "`define"			-> print_string "`define"
							| "`else"			-> print_string "`else"
							| "`endcelldefine"		-> print_string "`endcelldefine"
							| "`endif"			-> print_string "`endif"
							| "`endprotect"			-> print_string "`endprotect"
							| "`endprotected"		-> print_string "`endprotected"
							| "`expand_vectornets"		-> print_string "`expand_vectornets"
							| "`ifdef"			-> print_string "`ifdef"
							| "`include"			-> print_string "`include"
							| "`noaccelerate"		-> print_string "`noaccelerate"
							| "`noexpand_vectornets"	-> print_string "`noexpand_vectornets"
							| "`noremove_gatenames"		-> print_string "`noremove_gatenames"
							| "`noremove_netnames"		-> print_string "`noremove_netnames"
							| "`nounconnected_drive"	-> print_string "`nounconnected_drive"
							| "`protect"			-> print_string "`protect"
							| "`protected"			-> print_string "`protected"
							| "`remove_gatenames"		-> print_string "`remove_gatenames"
							| "`remove_netnames"		-> print_string "`remove_netnames"
							| "`resetall"			-> print_string "`resetall"
							| "`timescale"			-> print_string "`timescale"
							| "`unconnected_drive"		-> print_string "`unconnected_drive"
							| _ ->		try 
										let defedname = List.assoc (String.sub defname 1 ((String.length defname)-1)) !def_list in
										print_string defedname;
										(*this is not same as that of preproc*)
										do_else_in lexbuf;
										()
									with Not_found -> begin
										Printf.fprintf stderr "%s" "no such definition";
										Printf.fprintf stderr "%s" defname;
										exit 1
									end 
						end
						;
						Other
					}
     | [^ '`']* as lsm			{
     						print_string lsm;
						do_else_in lexbuf; 
						Other
					}
     | _ as lsm				{
     						print_char lsm;
						do_else_in lexbuf; 
						Other 
					}
