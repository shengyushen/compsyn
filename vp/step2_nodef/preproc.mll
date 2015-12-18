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
			print_string cmt;
			Lexing.new_line lexbuf ;
			Other
		}
	| "\n" {
			print_endline "";
			Lexing.new_line lexbuf ;
			Eol
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf
		}
	| "`define"			{
			proc_define lexbuf ;
			DIRECTIVE_define 
		}
	| "`ifdef"				{ 
			proc_ifdef lexbuf; 
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			DIRECTIVE_ifdef 
		}
	| "`ifndef"			{ 
			proc_ifndef lexbuf; 
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			DIRECTIVE_ifndef 
		}
	| "`else"|"elsif"|"`endif" as impdef{
			prt_fatal (Printf.sprintf  "unmatched %s"  impdef);
			print_pos (Lexing.lexeme_start_p lexbuf);
			(*something on the same line still neeed to be processed*)
			(*endline lexbuf;*)
			Other
		}
	| "`undef"				{
			(*removing the defined*)
			proc_undef lexbuf; Other
		}
	| '`'['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as defname {
			begin
				match defname with
				| "`accelerate"			-> print_string "`accelerate"
				| "`autoexpand_vectornets"	-> print_string "`autoexpand_vectornets"
				| "`begin_keywords"	-> print_string "`begin_keywords"
				| "`celldefine"			-> print_string "`celldefine"
				| "`default_nettype"		-> print_string "`default_nettype"
				| "`define"			-> print_string "`define"
				| "`else"			-> print_string "`else"
				| "`endcelldefine"		-> print_string "`endcelldefine"
				| "`end_keywords"		-> print_string "`end_keywords"
				| "`endif"			-> print_string "`endif"
				| "`endprotect"			-> print_string "`endprotect"
				| "`endprotected"		-> print_string "`endprotected"
				| "`expand_vectornets"		-> print_string "`expand_vectornets"
				| "`ifdef"			-> print_string "`ifdef"
				| "`include"			-> print_string "`include"
				| "`line"			-> begin
						print_string "`line";
						line_skip_blank  lexbuf
					end
				| "`noaccelerate"		-> print_string "`noaccelerate"
				| "`noexpand_vectornets"	-> print_string "`noexpand_vectornets"
				| "`noremove_gatenames"		-> print_string "`noremove_gatenames"
				| "`noremove_netnames"		-> print_string "`noremove_netnames"
				| "`nounconnected_drive"	-> print_string "`nounconnected_drive"
				| "`pragma"			-> print_string "`pragma"
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
						prt_fatal (Printf.sprintf  "no such definition %s" defname);
						print_pos (Lexing.lexeme_start_p lexbuf);
						()
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
and comment_inskip depth stpos = parse
	"*/" as cmt  { (*end of current comment*)
		if(depth==1) then (*the first level of nested comment*)
			Other
		else
			comment_inskip(depth-1) stpos lexbuf
		}
	| "/*" as cmt {  (*new nested comment*)
			comment_inskip (depth+1) stpos lexbuf
		}
	| '\n' as lsm {
			Lexing.new_line lexbuf ;
			comment_inskip depth stpos lexbuf
		}
	| _ as lsm {
			comment_inskip depth stpos lexbuf
		}
and preproc_str = parse
	'`'['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as defname {
			begin
				try 
					(List.assoc (String.sub defname 1 ((String.length defname)-1)) !def_list) ^ (preproc_str lexbuf)
				with Not_found -> begin
					prt_fatal (Printf.sprintf "no such definition in preproc_str %s" defname);
					print_pos (Lexing.lexeme_start_p lexbuf);
					preproc_str lexbuf
				end 
			end
		}
	| eof				{ ""                      }
	| _ as lsm				{
		(Printf.sprintf "%c" lsm) ^ (preproc_str lexbuf)
	}
and proc_define = parse 
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			proc_define lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_define lexbuf
		}
	| ['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def 	{
			proc_defined def lexbuf
		}
	| _ as lsm 	{
			proc_define lexbuf
		}
and proc_defined def = parse 
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			proc_defined def lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_defined def lexbuf
		}
	| [' ' '\t']+ as lsm	{
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
					if (lastc=' ') || (lastc='\t') then 
						proc_trim_blank (String.sub str2trim 0 ((String.length str2trim)-1))
					else str2trim
				end
				in 
				proc_trim_blank defed2
			end
			in
			def_list:=(def,defed)::(List.remove_assoc def !def_list);
		}
	| '\n' as lsm{
			print_char lsm; 
			Lexing.new_line lexbuf;
			def_list:=(def,"")::(List.remove_assoc def !def_list)
		}
	| _ as lsm							{
			print_char lsm; 
			def_list:=(def,"")::(List.remove_assoc def !def_list)
		}
and proc_ifdef  = parse 
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			proc_ifdef lexbuf 
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_ifdef lexbuf 
		}
	| ['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def	{
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
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			proc_ifndef lexbuf 
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_ifndef lexbuf 
		}
	| ['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def	{
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
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			do_then lexbuf
		}
	| "\n" {
			print_endline "";
			Lexing.new_line lexbuf ;
			do_then lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			do_then lexbuf
		}
	| "`ifdef"				{
			proc_ifdef lexbuf; 
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			do_then lexbuf; 
			DIRECTIVE_ifdef 
		}
	| "`ifndef"			{
			proc_ifndef lexbuf; 
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			do_then lexbuf; 
			DIRECTIVE_ifndef 
		}
	| "`else"				{
			skip_else lexbuf; 
			DIRECTIVE_else 
		}
	| "`elsif"				{
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
			| "`begin_keywords"	-> print_string "`begin_keywords"
			| "`celldefine"			-> print_string "`celldefine"
			| "`default_nettype"		-> print_string "`default_nettype"
			| "`define"			-> print_string "`define"
			| "`else"			-> print_string "`else"
			| "`endcelldefine"		-> print_string "`endcelldefine"
			| "`end_keywords"		-> print_string "`end_keywords"
			| "`endif"			-> print_string "`endif"
			| "`endprotect"			-> print_string "`endprotect"
			| "`endprotected"		-> print_string "`endprotected"
			| "`expand_vectornets"		-> print_string "`expand_vectornets"
			| "`ifdef"			-> print_string "`ifdef"
			| "`include"			-> print_string "`include"
			| "`line"			-> begin
						print_string "`line";
						line_skip_blank  lexbuf
					end
			| "`noaccelerate"		-> print_string "`noaccelerate"
			| "`noexpand_vectornets"	-> print_string "`noexpand_vectornets"
			| "`noremove_gatenames"		-> print_string "`noremove_gatenames"
			| "`noremove_netnames"		-> print_string "`noremove_netnames"
			| "`nounconnected_drive"	-> print_string "`nounconnected_drive"
			| "`pragma"			-> print_string "`pragma"
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
				with Not_found -> begin
					prt_fatal (Printf.sprintf  "no such definition %s" defname);
					print_pos (Lexing.lexeme_start_p lexbuf);
					()
				end 
			end
			;
			do_then lexbuf;
			Other
		}
	| [^ '`' '\n']* as lsm			{
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
	"//" [^ '\n']* '\n' as cmt   {
			Lexing.new_line lexbuf ;
			skip_else lexbuf
		}
	| "\n" {
			Lexing.new_line lexbuf ;
			skip_else lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
	  	comment_inskip 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			skip_else lexbuf
		}
	| "`ifdef"				{
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
	| [^ '`' '\n']* as lsm			{
			skip_else lexbuf; 
			Other
		}
	| _ as lsm				{
			skip_else lexbuf;
			Other 
		}
and proc_ifdef_inskip  = parse 
	"//" [^ '\n']* '\n' as cmt   {
			Lexing.new_line lexbuf ;
			proc_ifdef_inskip lexbuf
		}
	| "\n" {
			Lexing.new_line lexbuf ;
			proc_ifdef_inskip lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
	  	comment_inskip 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_ifdef_inskip lexbuf
		}
	| "`ifdef"				{
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
	| [^ '`' '\n']* as lsm			{
			proc_ifdef_inskip lexbuf; 
			Other
		}
	| _ as lsm				{
			proc_ifdef_inskip lexbuf; 
			Other 
		}
and do_else  = parse 
	"//" [^ '\n']* '\n' as cmt   {
			Lexing.new_line lexbuf ;
			do_else lexbuf
		}
	| "\n" {
			Lexing.new_line lexbuf ;
			do_else lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
	  	comment_inskip 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			do_else lexbuf
		}
	| "`ifdef"				{
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
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			do_else_in lexbuf ; 
			Other
		}
	| "`elsif"				{
			proc_ifdef lexbuf;
			Other
		}
	| "`endif"				{
			DIRECTIVE_endif 
		}
	| [^ '`' '\n']* as lsm			{
			do_else lexbuf; 
			Other
		}
	| _ 				{
			do_else lexbuf; 
			Other 
		}
and do_else_in  = parse 
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			do_else_in lexbuf
		}
	| "\n" {
			print_endline "";
			Lexing.new_line lexbuf ;
			do_else_in lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			do_else_in lexbuf
		}
	| "`ifdef"				{
			proc_ifdef lexbuf ; 
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
			do_else_in lexbuf ; 
			Other
		}
	| "`ifndef"				{
			proc_ifndef lexbuf ; 
			Printf.printf  "\n`line %d \"%s\" 1\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
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
			| "`begin_keywords"	-> print_string "`begin_keywords"
			| "`celldefine"			-> print_string "`celldefine"
			| "`default_nettype"		-> print_string "`default_nettype"
			| "`define"			-> print_string "`define"
			| "`else"			-> print_string "`else"
			| "`endcelldefine"		-> print_string "`endcelldefine"
			| "`end_keywords"		-> print_string "`end_keywords"
			| "`endif"			-> print_string "`endif"
			| "`endprotect"			-> print_string "`endprotect"
			| "`endprotected"		-> print_string "`endprotected"
			| "`expand_vectornets"		-> print_string "`expand_vectornets"
			| "`ifdef"			-> print_string "`ifdef"
			| "`include"			-> print_string "`include"
			| "`line"			-> begin
						print_string "`line";
						line_skip_blank  lexbuf
					end
			| "`noaccelerate"		-> print_string "`noaccelerate"
			| "`noexpand_vectornets"	-> print_string "`noexpand_vectornets"
			| "`noremove_gatenames"		-> print_string "`noremove_gatenames"
			| "`noremove_netnames"		-> print_string "`noremove_netnames"
			| "`nounconnected_drive"	-> print_string "`nounconnected_drive"
			| "`pragma"			-> print_string "`pragma"
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
				with Not_found -> begin
					prt_fatal (Printf.sprintf "no such definition %s " defname);
					print_pos (Lexing.lexeme_start_p lexbuf);
					()
				end 
			end
			;
			do_else_in lexbuf;
			Other
		}
	| [^ '`' '\n']* as lsm			{
			print_string lsm;
			do_else_in lexbuf; 
			Other
		}
	| _ as lsm				{
			print_char lsm;
			do_else_in lexbuf; 
			Other 
		}
and proc_undef = parse
	"//" [^ '\n']* '\n' as cmt   {
			print_string cmt;
			Lexing.new_line lexbuf ;
			proc_undef lexbuf
		}
	| "/*"              as cmt    { (*multiline comment*)
			print_string cmt;
	  	comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			proc_undef lexbuf
		}
	| ['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '_' '0'-'9']* as def 	{
			(*if it is defined?*)
			let found = 
			try 
				List.assoc def !def_list ;
				1
			with Not_found -> 0
			in 
			if found == 0 then begin
				prt_fatal (Printf.sprintf "undefined macro name %s is used in `undef" def);
				print_pos (Lexing.lexeme_start_p lexbuf);
				Other
			end
			else begin
				def_list:=(List.remove_assoc def !def_list);
				Other
			end
		}
	| '\n'|eof		{
			prt_fatal "undef dont contains the macro to be undefined";
			Lexing.new_line lexbuf ;
			print_pos (Lexing.lexeme_start_p lexbuf);
			Other
		}
	| _ as lsm 	{
			proc_undef lexbuf
		}
and line_skip_blank  = parse
	[' ' '\t']+	{
		line_number  lexbuf
	}
	| _ {
		prt_fatal "`line must be followed by blanks and line number and  filename";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		()
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
		()
	}
and line_skip_blank2  ln = parse
	[' ' '\t']+	{
		line_filename  ln lexbuf
	}
	| _ {
		prt_fatal "`line and blanks and line number must be followed by  blanks";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		()
	}
and line_filename  ln = parse
	'\"' [^ '\n' ' ' '\t' ]+ '\"' as fn {
		let realfn = String.sub fn 1 ((String.length fn)-2)
		in begin
			lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = realfn };
			lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_lnum  = ln };
			Printf.printf " \"%s\" " realfn;
			endofline lexbuf;
			()
		end
	}
	| _ {
		prt_fatal "`line and blanks and line number and blanks must be followed by filename";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		()
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
(*and endline = parse
'\n' {Other}
| _ {endline lexbuf}*)

