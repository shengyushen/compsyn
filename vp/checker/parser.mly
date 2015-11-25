%{
(*head*)
open Printf


let get_begin_pos t = begin
	match t with
	(p,_,_) -> p
end
;;
let get_finish_pos t = begin
	match t with
	(_,p,_) -> p
end
;;
let print_pos pos = begin
	Printf.printf "%s " pos.Lexing.pos_fname;
	Printf.printf "Line %d " pos.Lexing.pos_lnum;
	Printf.printf "Char %d\n" (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
end
;;
let print_both_pos t = begin
	Printf.printf "  Begin at ";
	print_pos (get_begin_pos t);
	Printf.printf "  Finish at ";
	print_pos (get_finish_pos t);
end
;;
let get_string_ssy t = begin
	match t with
	(_,_,str) -> str
end
;;
%}

/*declarations*/

/*tokens for interfacing with lex*/
%token  <Lexing.position*Lexing.position*string> MACRO_BEGIN_KEYWORDS
%token  <Lexing.position*Lexing.position*string> MACRO_CELLDEFINE
%token  <Lexing.position*Lexing.position*string> MACRO_DEFAULT_NETTYPE
%token  <Lexing.position*Lexing.position*string> MACRO_DEFINE
%token  <Lexing.position*Lexing.position*string> MACRO_ELSE
%token  <Lexing.position*Lexing.position*string> MACRO_ELSIF
%token  <Lexing.position*Lexing.position*string> MACRO_END_KEYWORDS
%token  <Lexing.position*Lexing.position*string> MACRO_ENDCELLDEFINE
%token  <Lexing.position*Lexing.position*string> MACRO_ENDIF
%token  <Lexing.position*Lexing.position*string> MACRO_IFDEF
%token  <Lexing.position*Lexing.position*string> MACRO_IFNDEF
%token  <Lexing.position*Lexing.position*string> MACRO_INCLUDE
%token  <Lexing.position*Lexing.position*string> MACRO_LINE
%token  <Lexing.position*Lexing.position*string> MACRO_NOUNCONNECTED_DRIVE
%token  <Lexing.position*Lexing.position*string> MACRO_PRAGMA
%token  <Lexing.position*Lexing.position*string> MACRO_RESETALL
%token  <Lexing.position*Lexing.position*string> MACRO_TIMESCALE
%token  <Lexing.position*Lexing.position*string> MACRO_UNCONNECTED_DRIVE
%token  <Lexing.position*Lexing.position*string> MACRO_UNDEF              


%token  <Lexing.position*Lexing.position*string> KEY_ALWAYS
%token  <Lexing.position*Lexing.position*string> KEY_AND
%token  <Lexing.position*Lexing.position*string> KEY_ASSIGN
%token  <Lexing.position*Lexing.position*string> KEY_AUTOMATIC
%token  <Lexing.position*Lexing.position*string> KEY_BEGIN
%token  <Lexing.position*Lexing.position*string> KEY_BUF
%token  <Lexing.position*Lexing.position*string> KEY_BUFIF0
%token  <Lexing.position*Lexing.position*string> KEY_BUFIF1
%token  <Lexing.position*Lexing.position*string> KEY_CASE
%token  <Lexing.position*Lexing.position*string> KEY_CASEX
%token  <Lexing.position*Lexing.position*string> KEY_CASEZ
%token  <Lexing.position*Lexing.position*string> KEY_CELL
%token  <Lexing.position*Lexing.position*string> KEY_CMOS
%token  <Lexing.position*Lexing.position*string> KEY_CONFIG
%token  <Lexing.position*Lexing.position*string> KEY_DEASSIGN
%token  <Lexing.position*Lexing.position*string> KEY_DEFAULT
%token  <Lexing.position*Lexing.position*string> KEY_DEFPARAM
%token  <Lexing.position*Lexing.position*string> KEY_DESIGN
%token  <Lexing.position*Lexing.position*string> KEY_DISABLE
%token  <Lexing.position*Lexing.position*string> KEY_EDGE
%token  <Lexing.position*Lexing.position*string> KEY_ELSE
%token  <Lexing.position*Lexing.position*string> KEY_END
%token  <Lexing.position*Lexing.position*string> KEY_ENDCASE
%token  <Lexing.position*Lexing.position*string> KEY_ENDCONFIG
%token  <Lexing.position*Lexing.position*string> KEY_ENDFUNCTION
%token  <Lexing.position*Lexing.position*string> KEY_ENDGENERATE
%token  <Lexing.position*Lexing.position*string> KEY_ENDMODULE
%token  <Lexing.position*Lexing.position*string> KEY_ENDPRIMITIVE
%token  <Lexing.position*Lexing.position*string> KEY_ENDSPECIFY
%token  <Lexing.position*Lexing.position*string> KEY_ENDTABLE
%token  <Lexing.position*Lexing.position*string> KEY_ENDTASK
%token  <Lexing.position*Lexing.position*string> KEY_EVENT
%token  <Lexing.position*Lexing.position*string> KEY_FOR
%token  <Lexing.position*Lexing.position*string> KEY_FORCE
%token  <Lexing.position*Lexing.position*string> KEY_FOREVER
%token  <Lexing.position*Lexing.position*string> KEY_FORK
%token  <Lexing.position*Lexing.position*string> KEY_FUNCTION
%token  <Lexing.position*Lexing.position*string> KEY_GENERATE
%token  <Lexing.position*Lexing.position*string> KEY_GENVAR
%token  <Lexing.position*Lexing.position*string> KEY_HIGHZ0
%token  <Lexing.position*Lexing.position*string> KEY_HIGHZ1
%token  <Lexing.position*Lexing.position*string> KEY_IF
%token  <Lexing.position*Lexing.position*string> KEY_IFNONE
%token  <Lexing.position*Lexing.position*string> KEY_INCDIR
%token  <Lexing.position*Lexing.position*string> KEY_INCLUDE
%token  <Lexing.position*Lexing.position*string> KEY_INITIAL
%token  <Lexing.position*Lexing.position*string> KEY_INOUT
%token  <Lexing.position*Lexing.position*string> KEY_INPUT
%token  <Lexing.position*Lexing.position*string> KEY_INSTANCE
%token  <Lexing.position*Lexing.position*string> KEY_INTEGER
%token  <Lexing.position*Lexing.position*string> KEY_JOIN
%token  <Lexing.position*Lexing.position*string> KEY_LARGE
%token  <Lexing.position*Lexing.position*string> KEY_LIBLIST
%token  <Lexing.position*Lexing.position*string> KEY_LIBRARY
%token  <Lexing.position*Lexing.position*string> KEY_LOCALPARAM
%token  <Lexing.position*Lexing.position*string> KEY_MACROMODULE
%token  <Lexing.position*Lexing.position*string> KEY_MEDIUM
%token  <Lexing.position*Lexing.position*string> KEY_MODULE
%token  <Lexing.position*Lexing.position*string> KEY_NAND
%token  <Lexing.position*Lexing.position*string> KEY_NEGEDGE
%token  <Lexing.position*Lexing.position*string> KEY_NMOS
%token  <Lexing.position*Lexing.position*string> KEY_NOR
%token  <Lexing.position*Lexing.position*string> KEY_NOSHOWCANCELLED
%token  <Lexing.position*Lexing.position*string> KEY_NOT
%token  <Lexing.position*Lexing.position*string> KEY_NOTIF0
%token  <Lexing.position*Lexing.position*string> KEY_NOTIF1
%token  <Lexing.position*Lexing.position*string> KEY_OR
%token  <Lexing.position*Lexing.position*string> KEY_OUTPUT
%token  <Lexing.position*Lexing.position*string> KEY_PARAMETER
%token  <Lexing.position*Lexing.position*string> KEY_PMOS
%token  <Lexing.position*Lexing.position*string> KEY_POSEDGE
%token  <Lexing.position*Lexing.position*string> KEY_PRIMITIVE
%token  <Lexing.position*Lexing.position*string> KEY_PULL0
%token  <Lexing.position*Lexing.position*string> KEY_PULL1
%token  <Lexing.position*Lexing.position*string> KEY_PULLDOWN
%token  <Lexing.position*Lexing.position*string> KEY_PULLUP
%token  <Lexing.position*Lexing.position*string> KEY_PULSESTYLE_ONEVENT
%token  <Lexing.position*Lexing.position*string> KEY_PULSESTYLE_ONDETECT
%token  <Lexing.position*Lexing.position*string> KEY_RCMOS
%token  <Lexing.position*Lexing.position*string> KEY_REAL
%token  <Lexing.position*Lexing.position*string> KEY_REALTIME
%token  <Lexing.position*Lexing.position*string> KEY_REG
%token  <Lexing.position*Lexing.position*string> KEY_RELEASE
%token  <Lexing.position*Lexing.position*string> KEY_REPEAT
%token  <Lexing.position*Lexing.position*string> KEY_RNMOS
%token  <Lexing.position*Lexing.position*string> KEY_RPMOS
%token  <Lexing.position*Lexing.position*string> KEY_RTRAN
%token  <Lexing.position*Lexing.position*string> KEY_RTRANIF0
%token  <Lexing.position*Lexing.position*string> KEY_RTRANIF1
%token  <Lexing.position*Lexing.position*string> KEY_SCALARED
%token  <Lexing.position*Lexing.position*string> KEY_SHOWCANCELLED
%token  <Lexing.position*Lexing.position*string> KEY_SIGNED
%token  <Lexing.position*Lexing.position*string> KEY_SMALL
%token  <Lexing.position*Lexing.position*string> KEY_SPECIFY
%token  <Lexing.position*Lexing.position*string> KEY_SPECPARAM
%token  <Lexing.position*Lexing.position*string> KEY_STRONG0
%token  <Lexing.position*Lexing.position*string> KEY_STRONG1
%token  <Lexing.position*Lexing.position*string> KEY_SUPPLY0
%token  <Lexing.position*Lexing.position*string> KEY_SUPPLY1
%token  <Lexing.position*Lexing.position*string> KEY_TABLE
%token  <Lexing.position*Lexing.position*string> KEY_TASK
%token  <Lexing.position*Lexing.position*string> KEY_TIME
%token  <Lexing.position*Lexing.position*string> KEY_TRAN
%token  <Lexing.position*Lexing.position*string> KEY_TRANIF0
%token  <Lexing.position*Lexing.position*string> KEY_TRANIF1
%token  <Lexing.position*Lexing.position*string> KEY_TRI
%token  <Lexing.position*Lexing.position*string> KEY_TRI0
%token  <Lexing.position*Lexing.position*string> KEY_TRI1
%token  <Lexing.position*Lexing.position*string> KEY_TRIAND
%token  <Lexing.position*Lexing.position*string> KEY_TRIOR
%token  <Lexing.position*Lexing.position*string> KEY_TRIREG
%token  <Lexing.position*Lexing.position*string> KEY_UNSIGNED
%token  <Lexing.position*Lexing.position*string> KEY_USE
%token  <Lexing.position*Lexing.position*string> KEY_UWIRE
%token  <Lexing.position*Lexing.position*string> KEY_VECTORED
%token  <Lexing.position*Lexing.position*string> KEY_WAIT
%token  <Lexing.position*Lexing.position*string> KEY_WAND
%token  <Lexing.position*Lexing.position*string> KEY_WEAK0
%token  <Lexing.position*Lexing.position*string> KEY_WEAK1
%token  <Lexing.position*Lexing.position*string> KEY_WHILE
%token  <Lexing.position*Lexing.position*string> KEY_WIRE
%token  <Lexing.position*Lexing.position*string> KEY_WOR
%token  <Lexing.position*Lexing.position*string> KEY_XNOR
%token  <Lexing.position*Lexing.position*string> KEY_XOR                            

%token  <Lexing.position*Lexing.position*string> SYSFUN_COUNTDRIVERS
%token  <Lexing.position*Lexing.position*string> SYSFUN_GETPATTERN  
%token  <Lexing.position*Lexing.position*string> SYSFUN_INCSAVE     
%token  <Lexing.position*Lexing.position*string> SYSFUN_INPUT       
%token  <Lexing.position*Lexing.position*string> SYSFUN_KEY         
%token  <Lexing.position*Lexing.position*string> SYSFUN_LIST        
%token  <Lexing.position*Lexing.position*string> SYSFUN_LOG         
%token  <Lexing.position*Lexing.position*string> SYSFUN_NOKEY       
%token  <Lexing.position*Lexing.position*string> SYSFUN_NOLOG       
%token  <Lexing.position*Lexing.position*string> SYSFUN_RESET       
%token  <Lexing.position*Lexing.position*string> SYSFUN_RESET_COUNT 
%token  <Lexing.position*Lexing.position*string> SYSFUN_RESET_VALUE 
%token  <Lexing.position*Lexing.position*string> SYSFUN_RESTART     
%token  <Lexing.position*Lexing.position*string> SYSFUN_SAVE        
%token  <Lexing.position*Lexing.position*string> SYSFUN_SCALE       
%token  <Lexing.position*Lexing.position*string> SYSFUN_SCOPE       
%token  <Lexing.position*Lexing.position*string> SYSFUN_SHOWSCOPES  
%token  <Lexing.position*Lexing.position*string> SYSFUN_SHOWVARS    
%token  <Lexing.position*Lexing.position*string> SYSFUN_SREADMEMB   
%token  <Lexing.position*Lexing.position*string> SYSFUN_SREADMEMH   

%token <Lexing.position*Lexing.position*string> COMMENT 
%token <Lexing.position*Lexing.position*string> EOL
%token <Lexing.position*Lexing.position*string> EOF 
%token <Lexing.position*Lexing.position*string> STRING



%token <Lexing.position*Lexing.position*string> DECIMAL_NUMBER
%token <Lexing.position*Lexing.position*string> BINARY_NUMBER
%token <Lexing.position*Lexing.position*string> OCTAL_NUMBER
%token <Lexing.position*Lexing.position*string> HEX_NUMBER




%start source_text
%type <int> source_text

%%

/*rules*/
source_text :
	item_list EOF {0}
;

item_list :
	{0}
	| item item_list {0}
;


item :
	  MACRO_BEGIN_KEYWORDS					{printf "macro_begin_keywords\n"}
	|	MACRO_CELLDEFINE							{printf "macro_celldefine\n"}
	|	MACRO_DEFAULT_NETTYPE					{printf "macro_default_nettype\n"}
	|	MACRO_DEFINE									{printf "macro_define\n"}
	|	MACRO_ELSE										{printf "macro_else\n"}
	|	MACRO_ELSIF										{printf "macro_elsif\n"}
	|	MACRO_END_KEYWORDS						{printf "macro_end_keywords\n"}
	|	MACRO_ENDCELLDEFINE						{printf "macro_endcelldefine\n"}
	|	MACRO_ENDIF										{printf "macro_endif\n"}
	|	MACRO_IFDEF										{printf "macro_ifdef\n"}
	|	MACRO_IFNDEF									{printf "macro_ifndef\n"}
	|	MACRO_INCLUDE									{printf "macro_include\n"}
	|	MACRO_LINE										{printf "macro_line\n"}
	|	MACRO_NOUNCONNECTED_DRIVE			{printf "macro_nounconnected_drive\n"}
	|	MACRO_PRAGMA									{printf "macro_pragma\n"}
	|	MACRO_RESETALL								{printf "macro_resetall\n"}
	|	MACRO_TIMESCALE								{printf "macro_timescale\n"}
	|	MACRO_UNCONNECTED_DRIVE				{printf "macro_unconnected_drive\n"}
	|	MACRO_UNDEF										{printf "macro_undef\n"}
	|	KEY_ALWAYS										{printf "key_always\n"}
	|	KEY_AND												{printf "key_and\n"}
	|	KEY_ASSIGN										{printf "key_assign\n"}
	|	KEY_AUTOMATIC									{printf "key_automatic\n"}
	|	KEY_BEGIN											{printf "key_begin\n"}
	|	KEY_BUF												{printf "key_buf\n"}
	|	KEY_BUFIF0										{printf "key_bufif0\n"}
	|	KEY_BUFIF1										{printf "key_bufif1\n"}
	|	KEY_CASE											{printf "key_case\n"}
	|	KEY_CASEX											{printf "key_casex\n"}
	|	KEY_CASEZ											{printf "key_casez\n"}
	|	KEY_CELL											{printf "key_cell\n"}
	|	KEY_CMOS											{printf "key_cmos\n"}
	|	KEY_CONFIG										{printf "key_config\n"}
	|	KEY_DEASSIGN									{printf "key_deassign\n"}
	|	KEY_DEFAULT										{printf "key_default\n"}
	|	KEY_DEFPARAM									{printf "key_defparam\n"}
	|	KEY_DESIGN										{printf "key_design\n"}
	|	KEY_DISABLE										{printf "key_disable\n"}
	|	KEY_EDGE											{printf "key_edge\n"}
	|	KEY_ELSE											{printf "key_else\n"}
	|	KEY_END												{printf "key_end\n"}
	|	KEY_ENDCASE										{printf "key_endcase\n"}
	|	KEY_ENDCONFIG									{printf "key_endconfig\n"}
	|	KEY_ENDFUNCTION								{printf "key_endfunction\n"}
	|	KEY_ENDGENERATE								{printf "key_endgenerate\n"}
	|	KEY_ENDMODULE									{printf "key_endmodule\n"}
	|	KEY_ENDPRIMITIVE							{printf "key_endprimitive\n"}
	|	KEY_ENDSPECIFY								{printf "key_endspecify\n"}
	|	KEY_ENDTABLE									{printf "key_endtable\n"}
	|	KEY_ENDTASK										{printf "key_endtask\n"}
	|	KEY_EVENT											{printf "key_event\n"}
	|	KEY_FOR												{printf "key_for\n"}
	|	KEY_FORCE											{printf "key_force\n"}
	|	KEY_FOREVER										{printf "key_forever\n"}
	|	KEY_FORK											{printf "key_fork\n"}
	|	KEY_FUNCTION									{printf "key_function\n"}
	|	KEY_GENERATE									{printf "key_generate\n"}
	|	KEY_GENVAR										{printf "key_genvar\n"}
	|	KEY_HIGHZ0										{printf "key_highz0\n"}
	|	KEY_HIGHZ1										{printf "key_highz1\n"}
	|	KEY_IF												{printf "key_if\n"}
	|	KEY_IFNONE										{printf "key_ifnone\n"}
	|	KEY_INCDIR										{printf "key_incdir\n"}
	|	KEY_INCLUDE										{printf "key_include\n"}
	|	KEY_INITIAL										{printf "key_initial\n"}
	|	KEY_INOUT											{printf "key_inout\n"}
	|	KEY_INPUT											{printf "key_input\n"}
	|	KEY_INSTANCE									{printf "key_instance\n"}
	|	KEY_INTEGER										{printf "key_integer\n"}
	|	KEY_JOIN											{printf "key_join\n"}
	|	KEY_LARGE											{printf "key_large\n"}
	|	KEY_LIBLIST										{printf "key_liblist\n"}
	|	KEY_LIBRARY										{printf "key_library\n"}
	|	KEY_LOCALPARAM								{printf "key_localparam\n"}
	|	KEY_MACROMODULE								{printf "key_macromodule\n"}
	|	KEY_MEDIUM										{printf "key_medium\n"}
	|	KEY_MODULE										{printf "key_module\n"}
	|	KEY_NAND											{printf "key_nand\n"}
	|	KEY_NEGEDGE										{printf "key_negedge\n"}
	|	KEY_NMOS											{printf "key_nmos\n"}
	|	KEY_NOR												{printf "key_nor\n"}
	|	KEY_NOSHOWCANCELLED						{printf "key_noshowcancelled\n"}
	|	KEY_NOT												{printf "key_not\n"}
	|	KEY_NOTIF0										{printf "key_notif0\n"}
	|	KEY_NOTIF1										{printf "key_notif1\n"}
	|	KEY_OR												{printf "key_or\n"}
	|	KEY_OUTPUT										{printf "key_output\n"}
	|	KEY_PARAMETER									{printf "key_parameter\n"}
	|	KEY_PMOS											{printf "key_pmos\n"}
	|	KEY_POSEDGE										{printf "key_posedge\n"}
	|	KEY_PRIMITIVE									{printf "key_primitive\n"}
	|	KEY_PULL0											{printf "key_pull0\n"}
	|	KEY_PULL1											{printf "key_pull1\n"}
	|	KEY_PULLDOWN									{printf "key_pulldown\n"}
	|	KEY_PULLUP										{printf "key_pullup\n"}
	|	KEY_PULSESTYLE_ONEVENT				{printf "key_pulsestyle_onevent\n"}
	|	KEY_PULSESTYLE_ONDETECT				{printf "key_pulsestyle_ondetect\n"}
	|	KEY_RCMOS											{printf "key_rcmos\n"}
	|	KEY_REAL											{printf "key_real\n"}
	|	KEY_REALTIME									{printf "key_realtime\n"}
	|	KEY_REG												{printf "key_reg\n"}
	|	KEY_RELEASE										{printf "key_release\n"}
	|	KEY_REPEAT										{printf "key_repeat\n"}
	|	KEY_RNMOS											{printf "key_rnmos\n"}
	|	KEY_RPMOS											{printf "key_rpmos\n"}
	|	KEY_RTRAN											{printf "key_rtran\n"}
	|	KEY_RTRANIF0									{printf "key_rtranif0\n"}
	|	KEY_RTRANIF1									{printf "key_rtranif1\n"}
	|	KEY_SCALARED									{printf "key_scalared\n"}
	|	KEY_SHOWCANCELLED							{printf "key_showcancelled\n"}
	|	KEY_SIGNED										{printf "key_signed\n"}
	|	KEY_SMALL											{printf "key_small\n"}
	|	KEY_SPECIFY										{printf "key_specify\n"}
	|	KEY_SPECPARAM									{printf "key_specparam\n"}
	|	KEY_STRONG0										{printf "key_strong0\n"}
	|	KEY_STRONG1										{printf "key_strong1\n"}
	|	KEY_SUPPLY0										{printf "key_supply0\n"}
	|	KEY_SUPPLY1										{printf "key_supply1\n"}
	|	KEY_TABLE											{printf "key_table\n"}
	|	KEY_TASK											{printf "key_task\n"}
	|	KEY_TIME											{printf "key_time\n"}
	|	KEY_TRAN											{printf "key_tran\n"}
	|	KEY_TRANIF0										{printf "key_tranif0\n"}
	|	KEY_TRANIF1										{printf "key_tranif1\n"}
	|	KEY_TRI												{printf "key_tri\n"}
	|	KEY_TRI0											{printf "key_tri0\n"}
	|	KEY_TRI1											{printf "key_tri1\n"}
	|	KEY_TRIAND										{printf "key_triand\n"}
	|	KEY_TRIOR											{printf "key_trior\n"}
	|	KEY_TRIREG										{printf "key_trireg\n"}
	|	KEY_UNSIGNED									{printf "key_unsigned\n"}
	|	KEY_USE												{printf "key_use\n"}
	|	KEY_UWIRE											{printf "key_uwire\n"}
	|	KEY_VECTORED									{printf "key_vectored\n"}
	|	KEY_WAIT											{printf "key_wait\n"}
	|	KEY_WAND											{printf "key_wand\n"}
	|	KEY_WEAK0											{printf "key_weak0\n"}
	|	KEY_WEAK1											{printf "key_weak1\n"}
	|	KEY_WHILE											{printf "key_while\n"}
	|	KEY_WIRE											{printf "key_wire\n"}
	|	KEY_WOR												{printf "key_wor\n"}
	|	KEY_XNOR											{printf "key_xnor\n"}
	|	KEY_XOR												{printf "key_xor\n"}
	|	SYSFUN_COUNTDRIVERS						{printf "sysfun_countdrivers\n"}
	|	SYSFUN_GETPATTERN							{printf "sysfun_getpattern\n"}
	|	SYSFUN_INCSAVE								{printf "sysfun_incsave\n"}
	|	SYSFUN_INPUT									{printf "sysfun_input\n"}
	|	SYSFUN_KEY										{printf "sysfun_key\n"}
	|	SYSFUN_LIST										{printf "sysfun_list\n"}
	|	SYSFUN_LOG										{printf "sysfun_log\n"}
	|	SYSFUN_NOKEY									{printf "sysfun_nokey\n"}
	|	SYSFUN_NOLOG									{printf "sysfun_nolog\n"}
	|	SYSFUN_RESET									{printf "sysfun_reset\n"}
	|	SYSFUN_RESET_COUNT						{printf "sysfun_reset_count\n"}
	|	SYSFUN_RESET_VALUE						{printf "sysfun_reset_value\n"}
	|	SYSFUN_RESTART								{printf "sysfun_restart\n"}
	|	SYSFUN_SAVE										{printf "sysfun_save\n"}
	|	SYSFUN_SCALE									{printf "sysfun_scale\n"}
	|	SYSFUN_SCOPE									{printf "sysfun_scope\n"}
	|	SYSFUN_SHOWSCOPES							{printf "sysfun_showscopes\n"}
	|	SYSFUN_SHOWVARS								{printf "sysfun_showvars\n"}
	|	SYSFUN_SREADMEMB							{printf "sysfun_sreadmemb\n"}
	|	SYSFUN_SREADMEMH							{printf "sysfun_sreadmemh\n"}
	| STRING												{printf "string %s\n" (get_string_ssy $1)}
	| COMMENT												{
			printf "comment \n" ;  
			print_both_pos $1;
		}
	


%%

(*trailer*)

