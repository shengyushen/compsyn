# 1 "proc_inc.mll"
 
	(*this is the list of definition*)
	let def_list = ref [("","")] ;

	exception Ssyeof of string
	
	type token = 
              | DIRECTIVE_include
              | Other
              | Eof
              | Eol

# 15 "proc_inc.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base = 
   "\000\000\251\255\001\000\253\255\254\255\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\002\000\253\255\254\255\
    \003\000\004\000\255\255";
  Lexing.lex_backtrk = 
   "\255\255\255\255\003\000\255\255\255\255\004\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \002\000\255\255\255\255";
  Lexing.lex_default = 
   "\002\000\000\000\002\000\000\000\000\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\000\000\014\000\000\000\000\000\
    \017\000\017\000\000\000";
  Lexing.lex_trans = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\003\000\255\255\015\000\255\255\255\255\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\016\000\255\255\018\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \005\000\255\255\000\000\008\000\011\000\012\000\000\000\000\000\
    \000\000\006\000\000\000\000\000\009\000\000\000\007\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\010\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \004\000\255\255\255\255\255\255\255\255";
  Lexing.lex_check = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\000\000\002\000\013\000\016\000\017\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\013\000\016\000\017\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \002\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\002\000\255\255\007\000\010\000\011\000\255\255\255\255\
    \255\255\005\000\255\255\255\255\008\000\255\255\006\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\009\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\002\000\013\000\016\000\017\000";
  Lexing.lex_base_code = 
   "";
  Lexing.lex_backtrk_code = 
   "";
  Lexing.lex_default_code = 
   "";
  Lexing.lex_trans_code = 
   "";
  Lexing.lex_check_code = 
   "";
  Lexing.lex_code = 
   "";
}

let rec proc_inc pathlist lexbuf =
    __ocaml_lex_proc_inc_rec pathlist lexbuf 0
and __ocaml_lex_proc_inc_rec pathlist lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 15 "proc_inc.mll"
                    ( (*print_string "// `include " ; *)  proc_include pathlist lexbuf ; DIRECTIVE_include )
# 118 "proc_inc.ml"

  | 1 ->
# 16 "proc_inc.mll"
              ( Eof                      )
# 123 "proc_inc.ml"

  | 2 ->
# 17 "proc_inc.mll"
             (
		 		Lexing.new_line lexbuf ;
				Printf.printf "\n";
				Other
		 	)
# 132 "proc_inc.ml"

  | 3 ->
let
# 22 "proc_inc.mll"
                            ssss
# 138 "proc_inc.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 22 "proc_inc.mll"
                                  (
     						print_string ssss; Other
     					)
# 144 "proc_inc.ml"

  | 4 ->
let
# 25 "proc_inc.mll"
            lsm
# 150 "proc_inc.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 25 "proc_inc.mll"
                   (
						print_char lsm; Other
					)
# 156 "proc_inc.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_proc_inc_rec pathlist lexbuf __ocaml_lex_state

and proc_include pathlist lexbuf =
    __ocaml_lex_proc_include_rec pathlist lexbuf 13
and __ocaml_lex_proc_include_rec pathlist lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
let
# 29 "proc_inc.mll"
                        filename
# 168 "proc_inc.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 29 "proc_inc.mll"
                                 (
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
										Printf.printf  "FATAL : not found %s \n"  tfn1;
										exit 1
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
							let inputFileChannle = open_in fn in
							let lexbuf1 = Lexing.from_channel inputFileChannle in
							while (proc_inc pathlist lexbuf1)!=Eof do
								flush stdout;
							done
							;
							Printf.printf  "//jump back to %s\n" (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname);
							Printf.printf  "`line %d \"%s\" 2\n" ((lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum)+1) (lexbuf.Lexing.lex_curr_p.Lexing.pos_fname) ;
						end
						;
						Other
					)
# 208 "proc_inc.ml"

  | 1 ->
# 66 "proc_inc.mll"
                                        ( proc_inc pathlist lexbuf           )
# 213 "proc_inc.ml"

  | 2 ->
# 67 "proc_inc.mll"
                                        ( proc_include pathlist lexbuf      )
# 218 "proc_inc.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_proc_include_rec pathlist lexbuf __ocaml_lex_state

;;

