{
(*head here*)
open Parser
open Printf
open String


let stringssy_string = ref "";;


let append_stringssy str =  begin
	stringssy_string := String.concat "" [!stringssy_string;str]
end
;;
let clear_stringssy () = begin
	stringssy_string := ""
end
;;
let print_pos pos = begin
	Printf.printf "%s " pos.Lexing.pos_fname;
	Printf.printf "Line %d " pos.Lexing.pos_lnum;
	Printf.printf "Char %d\n" (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
end
;;
let isNotEof_included t = begin
	match t with
	EOF_INCLUDED(_,_,_) -> false
	| _ -> true
end
;;
let char2int c = begin
	match c with
		'0' -> 0
	|	'1' -> 1
	|	'2' -> 2
	|	'3' -> 3
	|	'4' -> 4
	|	'5' -> 5
	|	'6' -> 6
	|	'7' -> 7
	|	'8' -> 8
	|	'9' -> 9
	| _ -> assert false
end
;;
let string_no_ str = begin
	let rec internal str1 = begin
		match str1 with
		"" -> str1
		| _ -> begin
			let hd = String.get str1 0
			and tl = String.sub str1 1 ((String.length str1)-1)
			in begin
				match hd with
				'_' -> internal tl
				| _ -> Printf.sprintf "%c%s" hd (internal tl)
			end
		end
	end
	in internal str
end
;;
let unsigned_numberStr2int str = begin
	let rec internal str1 tmp = begin
		match str1 with
		"" -> tmp
		| _ -> begin
			let hd = String.get str1 0
			and tl = String.sub str1 1 ((String.length str1)-1)
			in begin
				match hd with
				'_' -> internal tl tmp
				| _ -> internal tl (10*tmp + (char2int hd))
			end
		end
	end
	in internal str 0
end
;;
let get_size sz = begin
	let sz_no_  = unsigned_numberStr2int sz
	in begin
		if (sz_no_ == 0 ) then 32
		else sz_no_
	end
end
;;

}


(*A.8.7 Numbers *)

let x_digit      = 'x' | 'X'
let z_digit      = 'z' | 'Z' | '?'
let binary_digit = x_digit | z_digit | ['0' '1']
let octal_digit  = x_digit | z_digit | ['0'-'7']
let decimal_digit= ['0'-'9']
let hex_digit    = x_digit | z_digit | ['0'-'9' 'A'-'F' 'a'-'f']
let non_zero_decimal_digit = ['1'-'9']
let decimal_base = '\''['s' 'S']?'d' | '\''['s' 'S']?'D'
let binary_base   = '\''['s' 'S']?'b' | '\''['s' 'S']?'B'
let octal_base   = '\''['s' 'S']?'o' | '\''['s' 'S']?'O'
let hex_base     = '\''['s' 'S']?'h' | '\''['s' 'S']?'H'
let binary_value = binary_digit ( '_' | binary_digit )*
let octal_value  = octal_digit  ( '_' | octal_digit  )*
let hex_value    = hex_digit    ( '_' | hex_digit    )*
let unsigned_number = decimal_digit ( '_' | decimal_digit )* (*referred in parser*)
let non_zero_unsigned_number = non_zero_decimal_digit ( '_' | decimal_digit)* 
let size         = non_zero_unsigned_number
let sign         = '+' | '-'
let exp          = 'e' | 'E'
let real_number  =   (*referred in parser*)
	unsigned_number '.' unsigned_number
	| unsigned_number ( '.' unsigned_number )? exp  sign? unsigned_number


(*A.8.8 Strings*)
(*already deal with below*)

(*A.9.2 Comments*)
(*already deal with below*)


(*A.9.3 Identifiers*)
let escaped_identifier     = '\\' [^ ' ' '\t' '\n' ]+ ' '
let system_task_function_identifier = '$' ['a'-'z' 'A'-'Z' '0'-'9' '_' '$']+
let simple_identifier = ['a'-'z' 'A'-'Z' '_' ] [ 'a'-'z' 'A'-'Z' '0'-'9' '_' '$' ]*
(*A.9.4 White space*)
(*white space only used in escaped_identifier*)




(*useless directives*)
let useless_directives =
	 "`celldefine"        	  
	|"`default_nettype"   	  
	|"`end_keywords"      	  
	|"`endcelldefine"     	  
	|"`nounconnected_drive"	  
	|"`pragma"            	  
	|"`timescale"         	  
	|"`unconnected_drive" 	  
	|"`define"            	
	|"`else"              	
	|"`elsif"             	
	|"`endif"             	
	|"`ifdef"             	
	|"`ifndef"            	
	|"`resetall"          	
	|"`undef"             	


rule veriloglex  = parse
		[' ' '\t' '\n' ]+	{
			veriloglex  lexbuf
		}
	| system_task_function_identifier  {SYSTEM_TASK_FUNCTION_IDENTIFIER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	| escaped_identifier { ESCAPED_IDENTIFIER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf) }
	| simple_identifier  as idstr {
			match idstr with
			 "always"							-> KEY_ALWAYS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"and"								-> KEY_AND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"assign"            	-> KEY_ASSIGN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"automatic"          -> KEY_AUTOMATIC(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"begin"              -> KEY_BEGIN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"buf"                -> KEY_BUF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"bufif0"             -> KEY_BUFIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"bufif1"             -> KEY_BUFIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"case"               -> KEY_CASE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"casex"              -> KEY_CASEX(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"casez"              -> KEY_CASEZ(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"cell"               -> KEY_CELL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"cmos"               -> KEY_CMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"config"             -> KEY_CONFIG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"deassign"           -> KEY_DEASSIGN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"default"            -> KEY_DEFAULT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"defparam"           -> KEY_DEFPARAM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"design"             -> KEY_DESIGN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"disable"            -> KEY_DISABLE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"edge"								-> KEY_EDGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"else"               -> KEY_ELSE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"end"                -> KEY_END(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endcase"            -> KEY_ENDCASE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endconfig"          -> KEY_ENDCONFIG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endfunction"        -> KEY_ENDFUNCTION(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endgenerate"        -> KEY_ENDGENERATE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endmodule"          -> KEY_ENDMODULE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endprimitive"       -> KEY_ENDPRIMITIVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endspecify"         -> KEY_ENDSPECIFY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endtable"           -> KEY_ENDTABLE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"endtask"            -> KEY_ENDTASK(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"event"              -> KEY_EVENT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"for"                -> KEY_FOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"force"              -> KEY_FORCE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"forever"            -> KEY_FOREVER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"fork"               -> KEY_FORK(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"function"           -> KEY_FUNCTION(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"generate"           -> KEY_GENERATE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"genvar"							-> KEY_GENVAR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"highz0"             -> KEY_HIGHZ0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"highz1"             -> KEY_HIGHZ1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"if"                 -> KEY_IF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"ifnone"             -> KEY_IFNONE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"incdir"             -> KEY_INCDIR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"include"            -> KEY_INCLUDE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"initial"            -> KEY_INITIAL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"inout"              -> KEY_INOUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"input"              -> KEY_INPUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"instance"           -> KEY_INSTANCE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"integer"            -> KEY_INTEGER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"join"               -> KEY_JOIN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"large"              -> KEY_LARGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"liblist"            -> KEY_LIBLIST(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"library"            -> KEY_LIBRARY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"localparam"         -> KEY_LOCALPARAM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"macromodule"        -> KEY_MACROMODULE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"medium"             -> KEY_MEDIUM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"module"							-> KEY_MODULE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"nand"               -> KEY_NAND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"negedge"            -> KEY_NEGEDGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"nmos"               -> KEY_NMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"nor"                -> KEY_NOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"noshowcancelled"    -> KEY_NOSHOWCANCELLED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"not"                -> KEY_NOT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"notif0"             -> KEY_NOTIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"notif1"             -> KEY_NOTIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"or"                 -> KEY_OR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"output"             -> KEY_OUTPUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"parameter"          -> KEY_PARAMETER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pmos"               -> KEY_PMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"posedge"            -> KEY_POSEDGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"primitive"          -> KEY_PRIMITIVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pull0"              -> KEY_PULL0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pull1"              -> KEY_PULL1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pulldown"           -> KEY_PULLDOWN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pullup"             -> KEY_PULLUP(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pulsestyle_onevent"	-> KEY_PULSESTYLE_ONEVENT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pulsestyle_ondetect"-> KEY_PULSESTYLE_ONDETECT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"rcmos"              -> KEY_RCMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"real"               -> KEY_REAL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"realtime"           -> KEY_REALTIME(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"reg"                -> KEY_REG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"release"            -> KEY_RELEASE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"repeat"             -> KEY_REPEAT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"rnmos"              -> KEY_RNMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"rpmos"              -> KEY_RPMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"rtran"              -> KEY_RTRAN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"rtranif0"           -> KEY_RTRANIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"rtranif1"           -> KEY_RTRANIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"scalared"           -> KEY_SCALARED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"showcancelled"      -> KEY_SHOWCANCELLED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"signed"             -> KEY_SIGNED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"small"              -> KEY_SMALL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"specify"            -> KEY_SPECIFY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"specparam"          -> KEY_SPECPARAM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"strong0"						-> KEY_STRONG0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"strong1"            -> KEY_STRONG1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"supply0"            -> KEY_SUPPLY0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"supply1"            -> KEY_SUPPLY1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"table"              -> KEY_TABLE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"task"               -> KEY_TASK(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"time"               -> KEY_TIME(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"tran"               -> KEY_TRAN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"tranif0"            -> KEY_TRANIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"tranif1"            -> KEY_TRANIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"tri"                -> KEY_TRI(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"tri0"               -> KEY_TRI0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"tri1"               -> KEY_TRI1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"triand"             -> KEY_TRIAND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"trior"              -> KEY_TRIOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"trireg"             -> KEY_TRIREG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"unsigned"           -> KEY_UNSIGNED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"use"                -> KEY_USE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"uwire"              -> KEY_UWIRE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"vectored"						-> KEY_VECTORED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"wait"               -> KEY_WAIT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"wand"               -> KEY_WAND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"weak0"              -> KEY_WEAK0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"weak1"              -> KEY_WEAK1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"while"              -> KEY_WHILE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"wire"               -> KEY_WIRE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"wor"                -> KEY_WOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"xnor"               -> KEY_XNOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"xor"                -> KEY_XOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pulsestyle_onevent" -> KEY_PULSESTYLE_ONEVENT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"pulsestyle_ondetect" -> KEY_PULSESTYLE_ONDETECT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"showcancelled" -> KEY_SHOWCANCELLED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|"noshowcancelled" -> KEY_NOSHOWCANCELLED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)
			|_										-> SIMPLE_IDENTIFIER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)
		}
	|"PATHPULSE$"					 {KEY_PATHPULSE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$"									 {DOLLOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"->"									 {IMPLY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"=>"									 { IMPLY2(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"*>"									 { IMPLYSTART(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	| unsigned_number as lxm {
			let lxm_no_ =  unsigned_numberStr2int lxm
			in
			UNSIGNED_NUMBER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, lxm_no_)
		}
	| (size? as sz)  decimal_base [' ']* (unsigned_number as lxm) {
			let lxm_no_ =  unsigned_numberStr2int lxm
			and sz_no_  = get_size sz
			in
			UNSIGNED_NUMBER_size(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf,(sz_no_,lxm_no_))
		}
	| (size? as sz)  decimal_base [' ']* x_digit '_'* {
			assert false
		}
	| size?  decimal_base [' ']* z_digit '_'* {
			assert false
		}
	|	(size? as sz) octal_base [' ']* (octal_value as lxm) {
			let lxm_no_ =  string_no_ lxm
			and sz_no_  = get_size sz
			in 
			OCTAL_NUMBER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf ,(sz_no_,lxm_no_))
		}
	| (size? as sz) binary_base [' ']* (binary_value as lxm) {
			let lxm_no_ =  string_no_ lxm
			and sz_no_  = get_size sz
			in
			BINARY_NUMBER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf ,(sz_no_,lxm_no_))
		}
	| (size? as sz) hex_base [' ']* (hex_value as lxm ) {
			let lxm_no_ =  string_no_ lxm
			and sz_no_  = get_size sz
			in
			HEX_NUMBER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf ,(sz_no_,lxm_no_))
		}
	| real_number {
			REAL_NUMBER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)
		}
  | eof										{ 
			EOF(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)
		}
	| '+'		{OP2_ADD(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '-'		{OP2_SUB(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '&'		{OP2_AND(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '|'		{OP2_OR (Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '^'		{OP2_XOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "~^"|"^~"		{OP2_XNOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '!'		{OP1_LOGIC_NEG(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '~'		{OP1_BITWISE_NEG(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "~&"	{OP1_REDUCE_NAND(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "~|"	{OP1_REDUCE_NOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '*'		{OP2_MULTIPLE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '/'		{OP2_DIV(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '%'		{OP2_MOD(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "=="	{OP2_EQU2(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "!="	{OP2_NEQ2(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "==="	{OP2_EQU3(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "!=="	{OP2_NEQ3(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "&&"	{OP2_AND2(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "||"	{OP2_OR2(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "**"	{OP2_POWER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '<'		{OP2_LT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "<="	{OP2_LE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| '>'		{OP2_GT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ">="	{OP2_GE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ">>"	{OP2_LOGICAL_RIGHTSHIFT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "<<"	{OP2_LOGICAL_LEFTSHIFT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ">>>"	{OP2_ARITHMETIC_RIGHTSHIFT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "<<<"	{OP2_ARITHMETIC_LEFTSHIFT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "?"		{OP2_QUESTION(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "("		{LPARENT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "(*"		{LPARENTSTART(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ")"		{RPARENT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "*)"		{RPARENTSTART(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ","		{COMMA(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ";"		{SEMICOLON(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| ":"		{COLON(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "["		{LSQUARE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "]"		{RSQUARE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "="		{EQU1(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "{"		{LHUA(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "}"		{RHUA(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "."		{PERIOD(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "@"		{AT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "#"		{JING(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "+:"	{ADDRANGE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "-:"	{SUBRANGE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)}
	| "//"                	{	(*comment to end of line*)
			(*let stpos = Lexing.lexeme_start_p lexbuf
			in begin
				let xx=endofline lexbuf
				in begin
					match xx with
					EOF(_,endpos,_) ->
						COMMENT(stpos,endpos,"")
					| EOL(_,endpos,_) ->
						COMMENT(stpos,endpos,"")
					| _ -> assert false
				end
			end*)
			(*dont return comment, just go on*)
			endofline lexbuf;
			veriloglex  lexbuf
		}  
	| "/*"									{	(*multiline comment*)
			comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf;
			veriloglex  lexbuf
		}
	| '\n'									{	(*incleasing line number*)
			Lexing.new_line lexbuf ;
			veriloglex  lexbuf
		}
	| '\"'									{ (*matching string*)
			stringssy_string := "";
			stringssy  lexbuf 
		}
	| useless_directives			{  
			printf "//WARNING : Ignoring %s at " (Lexing.lexeme lexbuf);
			print_pos (Lexing.lexeme_start_p lexbuf);
			flush stdout;
			endofline lexbuf;
			veriloglex  lexbuf
		}
	|"`include"           	{  
			printf "Warning : `include should have been handles by step1 ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex  lexbuf
		}
	|"`line"              	{  
			line_skip_blank  lexbuf;
			veriloglex  lexbuf
		}
and endofline = parse
	'\n' {
			let endpos=Lexing.lexeme_end_p lexbuf
			in begin
				Lexing.new_line lexbuf;
				EOL(Lexing.lexeme_start_p lexbuf,endpos ,Lexing.lexeme lexbuf)  
			end
		}
	| eof {
			EOF(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)  
		}
	| _ {
			endofline lexbuf
		}
and stringssy   = parse
	"\\\"" {
		stringssy_string := String.concat "" [!stringssy_string;"\""];
		stringssy  lexbuf
	}
	| '\"' {
		STRING(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf,!stringssy_string)
	} 
	| '\n' {
		Printf.printf "//FATAL : incomplete string %s\n" !stringssy_string;
		print_pos (Lexing.lexeme_end_p lexbuf);
		veriloglex  lexbuf
	}
	| _ {
		stringssy_string := String.concat "" [!stringssy_string;Lexing.lexeme lexbuf];
		stringssy   lexbuf
	}
and comment depth stpos = parse
	"*/"	{	(*end of current comment*)
		if(depth==1) then (*the first level of nested comment*)
			(*COMMENT(stpos,Lexing.lexeme_end_p lexbuf,"")*)
			(*dont return comment, just go on*)
			0
		else 
			comment (depth-1) stpos lexbuf
	}
	| "/*" {	(*new nested comment*)
		comment (depth+1) stpos lexbuf
	}
	| '\n' {
		Lexing.new_line lexbuf ;
		comment depth stpos lexbuf
	}
	| _ {
		comment depth stpos lexbuf
	}
and line_skip_blank  = parse
	[' ' '\t']+	{
		printf "//INFO : skip blank\n";
		flush stdout;
		line_number  lexbuf
	}
	| _ {
		Printf.printf "//FATAL : `line must be followed by blanks and line number and  filename\n";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		0
	}
and line_number  = parse
	['0'-'9']+ as linenum {
		printf "line_number %s\n" linenum;
		flush stdout;
		let ln = int_of_string linenum
		in begin
			if(ln<=0) then begin
				Printf.printf "Warning : line number <=0 may leads to incorrect referring to original files\n";
				print_pos (lexbuf.Lexing.lex_curr_p)
			end
			;
			line_skip_blank2  (ln-1) lexbuf
		end
	}
	| _ {
		Printf.printf "//FATAL : `line and blanks must be followed by line number and  filename\n";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		0
	}
and line_skip_blank2  ln = parse
	[' ' '\t']+	{
		line_filename  ln lexbuf
	}
	| _ {
		Printf.printf "//FATAL : `line and blanks and line number must be followed by  blanks\n";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		0
	}
and line_filename  ln = parse
	'\"' [^ '\n' ' ' '\t' ]+ '\"' as fn {
		let realfn = String.sub fn 1 ((String.length fn)-2)
		in begin
			lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = realfn };
			lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_lnum  = ln };
			endofline lexbuf;
			printf "//INFO : at file name %s\n" realfn;
			flush stdout;
			0
		end
	}
	| _ {
		Printf.printf "//FATAL : `line and blanks and line number and blanks must be followed by filename\n";
		print_pos (Lexing.lexeme_start_p lexbuf);
		endofline lexbuf;
		0
	}
	


{                       
(*trailer here*)        
}                       
                        
                        
                        
