{
(*head here*)
open Parser
open Printf


let stringssy_string = ref "";;


let append_stringssy str =  begin
	stringssy_string := String.concat "" [!stringssy_string;str]
end
and clear_stringssy () = begin
	stringssy_string := ""
end
and print_pos pos = begin
	Printf.printf "F %s " pos.Lexing.pos_fname;
	Printf.printf "L %d " pos.Lexing.pos_lnum;
	Printf.printf "C %d\n" (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
end
}


(*A.8.7 Numbers 
from binary_value to the end*)

let x_digit      = 'x' | 'X'
let z_digit      = 'z' | 'Z' | '?'
let binary_digit = x_digit | z_digit | ['0' '1']
let octal_digit  = x_digit | z_digit | ['0'-'7']
let decimal_digit= ['0'-'9']
let hex_digit    = x_digit | z_digit | ['0'-'9' 'A'-'F' 'a'-'f']
let non_zero_decimal_digit = ['1'-'9']
let decimal_base = '\''['s' 'S']?'d' | '\''['s' 'S']?'D'
let inary_base   = '\''['s' 'S']?'b' | '\''['s' 'S']?'B'
let octal_base   = '\''['s' 'S']?'o' | '\''['s' 'S']?'O'
let hex_base     = '\''['s' 'S']?'h' | '\''['s' 'S']?'H'
let binary_value = binary_digit ( _ | binary_digit )*
let octal_value  = octal_digit  ( _ | octal_digit  )*
let hex_value    = hex_digit    ( _ | hex_digit    )*


rule veriloglex = parse
		[' ' '\t']+	{veriloglex lexbuf} (*skip blank*)
  | eof										{ 
			EOF(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf, Lexing.lexeme lexbuf)
		}
	| "//"                	{	(*comment to end of line*)
			let stpos = Lexing.lexeme_start_p lexbuf
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
			end
		}  
	| "/*"									{	(*multiline comment*)
			comment 1 (Lexing.lexeme_start_p lexbuf)  lexbuf
		}
	| '\n'									{	(*incleasing line number*)
			printf "newline at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			Lexing.new_line lexbuf ;
			veriloglex lexbuf
		}
	| '\"'									{ (*matching string*)
			stringssy_string := "";
			stringssy lexbuf 
		}
	|"`begin_keywords"			{  
			(*MACRO_BEGIN_KEYWORDS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `begin_keywords at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`celldefine"        	{  
			(*MACRO_CELLDEFINE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `celldefine at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`default_nettype"   	{  
			(*MACRO_DEFAULT_NETTYPE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `default_nettype at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`end_keywords"      	{  
			(*MACRO_END_KEYWORDS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `end_keywords at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`endcelldefine"     	{  
			(*MACRO_ENDCELLDEFINE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `endcelldefine at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`line"              	{  
			(*MACRO_LINE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `line at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`nounconnected_drive"	{  
			(*MACRO_NOUNCONNECTED_DRIVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `nounconnected_drive at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`pragma"            	{  
			(*MACRO_PRAGMA(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `pragma at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`timescale"         	{  
			(*MACRO_TIMESCALE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `timescale at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`unconnected_drive" 	{  
			(*MACRO_UNCONNECTED_DRIVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)*)
			printf "Warning : Ignoring `unconnected_drive at ";
			print_pos (Lexing.lexeme_start_p lexbuf);
			endofline lexbuf;
			veriloglex lexbuf
		}
	|"`include"           	{  MACRO_INCLUDE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`define"            	{  MACRO_DEFINE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`else"              	{  MACRO_ELSE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`elsif"             	{  MACRO_ELSIF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`endif"             	{  MACRO_ENDIF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`ifdef"             	{  MACRO_IFDEF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`ifndef"            	{  MACRO_IFNDEF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`resetall"          	{  MACRO_RESETALL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"`undef"             	{  MACRO_UNDEF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"always"								{  KEY_ALWAYS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"and"									{KEY_AND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"assign"            		{KEY_ASSIGN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"automatic"          {KEY_AUTOMATIC(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"begin"              {KEY_BEGIN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"buf"                {KEY_BUF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"bufif0"             {KEY_BUFIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"bufif1"             {KEY_BUFIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"case"               {KEY_CASE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"casex"              {KEY_CASEX(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"casez"              {KEY_CASEZ(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"cell"               {KEY_CELL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"cmos"               {KEY_CMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"config"             {KEY_CONFIG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"deassign"           {KEY_DEASSIGN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"default"            {KEY_DEFAULT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"defparam"           {KEY_DEFPARAM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"design"             {KEY_DESIGN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"disable"            {KEY_DISABLE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"edge"								{KEY_EDGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"else"               {KEY_ELSE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"end"                {KEY_END(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endcase"            {KEY_ENDCASE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endconfig"          {KEY_ENDCONFIG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endfunction"        {KEY_ENDFUNCTION(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endgenerate"        {KEY_ENDGENERATE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endmodule"          {KEY_ENDMODULE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endprimitive"       {KEY_ENDPRIMITIVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endspecify"         {KEY_ENDSPECIFY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endtable"           {KEY_ENDTABLE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"endtask"            {KEY_ENDTASK(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"event"              {KEY_EVENT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"for"                {KEY_FOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"force"              {KEY_FORCE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"forever"            {KEY_FOREVER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"fork"               {KEY_FORK(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"function"           {KEY_FUNCTION(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"generate"           {KEY_GENERATE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"genvar"							{KEY_GENVAR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"highz0"             {KEY_HIGHZ0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"highz1"             {KEY_HIGHZ1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"if"                 {KEY_IF(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"ifnone"             {KEY_IFNONE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"incdir"             {KEY_INCDIR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"include"            {KEY_INCLUDE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"initial"            {KEY_INITIAL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"inout"              {KEY_INOUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"input"              {KEY_INPUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"instance"           {KEY_INSTANCE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"integer"            {KEY_INTEGER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"join"               {KEY_JOIN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"large"              {KEY_LARGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"liblist"            {KEY_LIBLIST(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"library"            {KEY_LIBRARY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"localparam"         {KEY_LOCALPARAM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"macromodule"        {KEY_MACROMODULE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"medium"             {KEY_MEDIUM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"module"							{KEY_MODULE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"nand"               {KEY_NAND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"negedge"            {KEY_NEGEDGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"nmos"               {KEY_NMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"nor"                {KEY_NOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"noshowcancelled"    {KEY_NOSHOWCANCELLED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"not"                {KEY_NOT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"notif0"             {KEY_NOTIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"notif1"             {KEY_NOTIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"or"                 {KEY_OR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"output"             {KEY_OUTPUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"parameter"          {KEY_PARAMETER(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pmos"               {KEY_PMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"posedge"            {KEY_POSEDGE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"primitive"          {KEY_PRIMITIVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pull0"              {KEY_PULL0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pull1"              {KEY_PULL1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pulldown"           {KEY_PULLDOWN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pullup"             {KEY_PULLUP(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pulsestyle_onevent"	{KEY_PULSESTYLE_ONEVENT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"pulsestyle_ondetect" {KEY_PULSESTYLE_ONDETECT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"rcmos"               {KEY_RCMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"real"                {KEY_REAL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"realtime"            {KEY_REALTIME(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"reg"                 {KEY_REG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"release"             {KEY_RELEASE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"repeat"              {KEY_REPEAT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"rnmos"               {KEY_RNMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"rpmos"               {KEY_RPMOS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"rtran"               {KEY_RTRAN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"rtranif0"            {KEY_RTRANIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"rtranif1"            {KEY_RTRANIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"scalared"            {KEY_SCALARED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"showcancelled"       {KEY_SHOWCANCELLED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"signed"              {KEY_SIGNED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"small"               {KEY_SMALL(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"specify"             {KEY_SPECIFY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"specparam"           {KEY_SPECPARAM(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"strong0"							{KEY_STRONG0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"strong1"             {KEY_STRONG1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"supply0"             {KEY_SUPPLY0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"supply1"             {KEY_SUPPLY1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"table"               {KEY_TABLE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"task"                {KEY_TASK(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"time"                {KEY_TIME(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"tran"                {KEY_TRAN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"tranif0"             {KEY_TRANIF0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"tranif1"             {KEY_TRANIF1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"tri"                 {KEY_TRI(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"tri0"                {KEY_TRI0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"tri1"                {KEY_TRI1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"triand"              {KEY_TRIAND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"trior"               {KEY_TRIOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"trireg"              {KEY_TRIREG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"unsigned 1"          {KEY_UNSIGNED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"use"                 {KEY_USE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"uwire"               {KEY_UWIRE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"vectored"						{KEY_VECTORED(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"wait"                {KEY_WAIT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"wand"                {KEY_WAND(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"weak0"               {KEY_WEAK0(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"weak1"               {KEY_WEAK1(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"while"               {KEY_WHILE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"wire"                {KEY_WIRE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"wor"                 {KEY_WOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"xnor"                {KEY_XNOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"xor"                 {KEY_XOR(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$countdrivers"				{SYSFUN_COUNTDRIVERS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$getpattern"         {SYSFUN_GETPATTERN(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$incsave"            {SYSFUN_INCSAVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$input"              {SYSFUN_INPUT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$key"                {SYSFUN_KEY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$list"               {SYSFUN_LIST(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$log"                {SYSFUN_LOG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$nokey"              {SYSFUN_NOKEY(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$nolog"              {SYSFUN_NOLOG(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$reset"              {SYSFUN_RESET(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$reset_count"        {SYSFUN_RESET_COUNT(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$reset_value"        {SYSFUN_RESET_VALUE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$restart"            {SYSFUN_RESTART(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$save"               {SYSFUN_SAVE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$scale"              {SYSFUN_SCALE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$scope"              {SYSFUN_SCOPE(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$showscopes"         {SYSFUN_SHOWSCOPES(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$showvars"           {SYSFUN_SHOWVARS(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$sreadmemb"          {SYSFUN_SREADMEMB(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
	|"$sreadmemh"          {SYSFUN_SREADMEMH(Lexing.lexeme_start_p lexbuf,Lexing.lexeme_end_p lexbuf,Lexing.lexeme lexbuf)}
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
and stringssy  = parse
	"\\\"" {
		stringssy_string := String.concat "" [!stringssy_string;"\""];
		stringssy  lexbuf
	}
	| '\"' {
		STRING(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf,!stringssy_string)
	} 
	| '\n' {
		Printf.printf "FATAL : incomplete string %s\n" !stringssy_string;
		print_pos (Lexing.lexeme_end_p lexbuf);
		exit 0
	}
	| _ {
		stringssy_string := String.concat "" [!stringssy_string;Lexing.lexeme lexbuf];
		stringssy  lexbuf
	}
and comment depth stpos = parse
	"*/"	{	(*end of current comment*)
		if(depth==1) then (*the first level of nested comment*)
			COMMENT(stpos,Lexing.lexeme_end_p lexbuf,"")
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

{                       
(*trailer here*)        
}                       
                        
                        
                        
