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


%token <Lexing.position*Lexing.position*string> COMMENT 
%token <Lexing.position*Lexing.position*string> EOL
%token <Lexing.position*Lexing.position*string> EOF_INCLUDED
%token <Lexing.position*Lexing.position*string> EOF 

/*A.8.6 Operators*/
/*op for both unary and binary*/
%token <Lexing.position*Lexing.position*string> OP12_ADD
%token <Lexing.position*Lexing.position*string> OP12_SUB
%token <Lexing.position*Lexing.position*string> OP12_AND
%token <Lexing.position*Lexing.position*string> OP12_OR
%token <Lexing.position*Lexing.position*string> OP12_XOR
%token <Lexing.position*Lexing.position*string> OP12_XNOR

/*ops for unary*/
%token <Lexing.position*Lexing.position*string> OP1_GANTANHAO
%token <Lexing.position*Lexing.position*string> OP1_BOLANGHAO
%token <Lexing.position*Lexing.position*string> OP1_REDUCE_NAND
%token <Lexing.position*Lexing.position*string> OP1_REDUCE_NOR

/*ops for binary*/
%token <Lexing.position*Lexing.position*string> OP2_MULTIPLE
%token <Lexing.position*Lexing.position*string> OP2_DIV
%token <Lexing.position*Lexing.position*string> OP2_MOD
%token <Lexing.position*Lexing.position*string> OP2_EQU2
%token <Lexing.position*Lexing.position*string> OP2_NEQ2
%token <Lexing.position*Lexing.position*string> OP2_EQU3
%token <Lexing.position*Lexing.position*string> OP2_NEQ3
%token <Lexing.position*Lexing.position*string> OP2_AND
%token <Lexing.position*Lexing.position*string> OP2_OR
%token <Lexing.position*Lexing.position*string> OP2_POWER
%token <Lexing.position*Lexing.position*string> OP2_LT
%token <Lexing.position*Lexing.position*string> OP2_LE
%token <Lexing.position*Lexing.position*string> OP2_GT
%token <Lexing.position*Lexing.position*string> OP2_GE
%token <Lexing.position*Lexing.position*string> OP2_LOGICAL_RIGHTSHIFT
%token <Lexing.position*Lexing.position*string> OP2_LOGICAL_LEFTSHIFT
%token <Lexing.position*Lexing.position*string> OP2_ARITHMETIC_RIGHTSHIFT
%token <Lexing.position*Lexing.position*string> OP2_ARITHMETIC_LEFTSHIFT
%token <Lexing.position*Lexing.position*string> OP2_QUESTION

%token <Lexing.position*Lexing.position*string> LPARENT
%token <Lexing.position*Lexing.position*string> RPARENT
%token <Lexing.position*Lexing.position*string> COMMA    /*,*/
%token <Lexing.position*Lexing.position*string> SEMICOLON /*;*/
%token <Lexing.position*Lexing.position*string> COLON  /*:*/
%token <Lexing.position*Lexing.position*string> LSQUARE  
%token <Lexing.position*Lexing.position*string> RSQUARE
%token <Lexing.position*Lexing.position*string> LHUA
%token <Lexing.position*Lexing.position*string> RHUA
%token <Lexing.position*Lexing.position*string> PERIOD
%token <Lexing.position*Lexing.position*string> AT
%token <Lexing.position*Lexing.position*string> JING

%token <Lexing.position*Lexing.position*string> EQU1 /*=*/








/*A.8.7 Numbers */
%token <Lexing.position*Lexing.position*string> UNSIGNED_NUMBER
%token <Lexing.position*Lexing.position*string> REAL_NUMBER
%token <Lexing.position*Lexing.position*string> NUMBER
/*A.8.8 Strings*/
%token <Lexing.position*Lexing.position*string> STRING
/*A.9.3 Identifiers*/
%token <Lexing.position*Lexing.position*string> ESCAPED_IDENTIFIER
%token <Lexing.position*Lexing.position*string> SIMPLE_IDENTIFIER
%token  <Lexing.position*Lexing.position*string> SYSTEM_TASK_FUNCTION_IDENTIFIER


%start source_text
%type <int> source_text

%%

/*rules*/
/*A.1.2 Verilog source text*/
source_text : description_list {$1}
;

description_list : 
			{[]}
	|	description description_list {$1::$2}
;

description :
	module_declaration	{T_description__module_declaration($1)}
	| udp_declaration		{T_description__udp_declaration($1)}
	| config_declaration	{T_description__config_declaration($1)}
;

module_declaration :
		attribute_instance_list 
		module_keyword 
		module_identifier 
		module_parameter_port_list 
		list_of_ports 
		SEMICOLON 
		module_item_list
		KEY_ENDMODULE
		{	T_module_declaration__1(
				$1,$3,$4,$5,$7)}
	| attribute_instance_list 
		module_keyword 
		module_identifier 
		module_parameter_port_list
		list_of_port_declarations
		SEMICOLON 
		non_port_module_item_list
		KEY_ENDMODULE
		{	T_module_declaration__2(
				$1,$3,$4,$5,$7)}
;

attribute_instance_list :
		{[]}
	| attribute_instance attribute_instance_list {$1::$2}
;

module_item_list :
		{[]}
	| module_item module_item_list {$1::$2}
;

module_keyword : 
		KEY_MODULE			{$1}
	|	KEY_MACROMODULE	{$1}

non_port_module_item_list :
	{[]}
	| non_port_module_item non_port_module_item_list
		{$1::$2}

/*A.1.3 Module parameters and ports*/
module_parameter_port_list :
	JING 
	LPARENT 
		parameter_declaration comma_parameter_declaration_list
	RPARENT
	{$3::$4}
;

comma_parameter_declaration_list :
	{[]}
	| COMMA parameter_declaration parameter_declaration_list
		{$2::$3}
;

list_of_ports : 
	LPARENT 
		port comma_port_list
	RPARENT
		{$2::$3}
;

comma_port_list :
	COMMA port comma_port_list
	{$2::$3}
;

list_of_port_declarations :
	LPARENT 
		port_declaration comma_port_declaration_list
	RPARENT
		{$2::$3}
	| LPARENT RPARENT
		{[]}
;

port :
	port_expression_opt {T_port_position($1)}
	| PERIOD  port_identifier LPARENT port_expression_opt RPARENT
		{T_port_expression($2,$4)}
;

port_expression_opt :
	{T_port_expression([])}
	| port_expression {$1}
;

port_expression :
	port_reference	{T_port_expression([$1])}
	| LHUA port_reference comma_port_reference_list RHUA
		{T_port_expression($2::$3)}
;

port_reference :
	port_identifier lsquare_constant_range_expression_rsquare_opt
;

lsquare_constant_range_expression_rsquare_opt :
	{T_range_expression_NOSPEC}
	| lsquare_constant_range_expression_rsquare {$1}


lsquare_constant_range_expression_rsquare_opt :
	LSQUARE
		constant_range_expression
	RSQUARE
		{$2}
;

port_declaration :
	attribute_instance_list inout_declaration 
		{T_port_declaration__inout_declaration($1,$2)}
	| attribute_instance_list input_declaration
		{T_port_declaration__input_declaration($1,$2)}
	| attribute_instance_list output_declaration
		{T_port_declaration__output_declaration($1,$2)}
;

/*A.1.4 Module items*/
module_item :
	port_declaration SEMICOLON {
		T_module_item__port_declaration($1)}
	| non_port_module_item {$1}
;

non_port_module_item :
	module_or_generate_item {$1}
	| generate_region {
		T_module_item__generate_region($1)}
	| specify_block {
		T_module_item__specify_block($1)}
	| attribute_instance_list parameter_declaration SEMICOLON {
		T_module_item__parameter_declaration($1,$2)
	| attribute_instance_list specparam_declaration {
		T_module_item__specparam_declaration($1,$2)
;

module_or_generate_item :
	attribute_instance_list net_declaration      {
		T_module_item__net_declaration($1,$2)}
|	attribute_instance_list reg_declaration      {
		T_module_item__reg_declaration($1,$2)}
|	attribute_instance_list integer_declaration  {
		T_module_item__integer_declaration($1,$2)}
|	attribute_instance_list real_declaration     {
		T_module_item__real_declaration($1,$2)}
|	attribute_instance_list time_declaration     {
		T_module_item__time_declaration($1,$2)}
|	attribute_instance_list realtime_declaration {
		T_module_item__realtime_declaration($1,$2)}
|	attribute_instance_list event_declaration    {
		T_module_item__event_declaration($1,$2)}
|	attribute_instance_list genvar_declaration   {
		T_module_item__genvar_declaration($1,$2)
|	attribute_instance_list task_declaration     {
		T_module_item__task_declaration($1,$2)}
|	attribute_instance_list function_declaration {
		T_module_item__function_declaration($1,$2)}
| attribute_instance_list local_parameter_declaration SEMICOLON {
		T_module_item__local_parameter_declaration($1,$2)}
| attribute_instance_list parameter_override {
		T_module_item__parameter_override($1,$2)}
| attribute_instance_list continuous_assign {
		T_module_item__continuous_assign($1,$2)}
| attribute_instance_list gate_instantiation {
		T_module_item__gate_instantiation($1,$2)}
| attribute_instance_list udp_instantiation {
		T_module_item__udp_instantiation($1,$2)}
| attribute_instance_list module_instantiation {
		T_module_item__module_instantiation($1,$2)}
| attribute_instance_list initial_construct {
		T_module_item__initial_construct($1,$2)}
| attribute_instance_list always_construct {
		T_module_item__always_construct($1,$2)}
| attribute_instance_list loop_generate_construct {
		T_module_item__loop_generate_construct($1,$2)}
| attribute_instance_list conditional_generate_construct {
		T_module_item__conditional_generate_construct($1,$2)}
;

parameter_override :
	KEY_DEFPARAM list_of_defparam_assignments SEMICOLON
	 {$2}


/*A.1.5 Configuration source text*/
config_declaration :
	KEY_CONFIG config_identifier SEMICOLON
	design_statement
	config_rule_statement_list
	KEY_ENDCONFIG
	{T_config_declaration($2,$4,$5)}
;

design_statement : 
	KEY_DESIGN 
		library_identifier_period_opt_cell_identifier_list
	SEMICOLON
		{T_design_statement($2)}
;

library_identifier_period_opt_cell_identifier_list :
	{[]}
	| library_identifier_period_opt_cell_identifier library_identifier_period_opt_cell_identifier_list {$1::$2}
;

library_identifier_period_opt_cell_identifier :
	library_identifier_period_opt cell_identifier
	{T_lib_cell_identifier($1,$2)}
;

library_identifier_period_opt :
	{""}
	| library_identifier PERIOD {$1}

config_rule_statement :
	KEY_DEFAULT liblist_clause SEMICOLON {
			T_config_rule_statement__default($2)}
	| inst_clause liblist_clause SEMICOLON {
			T_config_rule_statement__inst_lib($1,$2)}
	| inst_clause use_clause SEMICOLON	{
			T_config_rule_statement__inst_use($1,$2)}
	| cell_clause liblist_clause SEMICOLON	{
			T_config_rule_statement__cell_lib($1,$2)}
	| cell_clause use_clause SEMICOLON	{
			T_config_rule_statement__cell_use($1,$2)}


inst_clause : 
	KEY_INSTANCE inst_name {$2}
;

inst_name : 
	topmodule_identifier comma_instance_identifier_list
	{$1::$2}
;

comma_instance_identifier_list :
	COMMA instance_identifier comma_instance_identifier_list
	{$2::$3}
;

cell_clause ::= cell [ library_identifier.]cell_identifier
liblist_clause ::= liblist { library_identifier }
use_clause ::= use [library_identifier.]cell_identifier[:config]
A.2 Declarations
A.2.1 Declaration types
A.2.1.1 Module parameter declarations
local_parameter_declaration ::=
localparam [ signed ] [ range ] list_of_param_assignments
| localparam parameter_type list_of_param_assignments
parameter_declaration ::=
parameter [ signed ] [ range ] list_of_param_assignments
| parameter parameter_type list_of_param_assignments
specparam_declaration ::= specparam [ range ] list_of_specparam_assignments ;
parameter_type ::=
integer | real | realtime | time
A.2.1.2 Port declarations
inout_declaration ::= inout [ net_type ] [ signed ] [ range ]
list_of_port_identifiers
input_declaration ::= input [ net_type ] [ signed ] [ range ]
list_of_port_identifiers
output_declaration ::=
output [ net_type ] [ signed ] [ range ]
list_of_port_identifiers
| output reg [ signed ] [ range ]
list_of_variable_port_identifiers
| output output_variable_type
list_of_variable_port_identifiers
Copyright © 2006 IEEE. All rights reserved.
489
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
A.2.1.3 Type declarations
event_declaration ::= event list_of_event_identifiers ;
integer_declaration ::= integer list_of_variable_identifiers ;
net_declaration ::=
net_type [ signed ]
[ delay3 ] list_of_net_identifiers ;
| net_type [ drive_strength ] [ signed ]
[ delay3 ] list_of_net_decl_assignments ;
| net_type [ vectored | scalared ] [ signed ]
range [ delay3 ] list_of_net_identifiers ;
| net_type [ drive_strength ] [ vectored | scalared ] [ signed ]
range [ delay3 ] list_of_net_decl_assignments ;
| trireg [ charge_strength ] [ signed ]
[ delay3 ] list_of_net_identifiers ;
| trireg [ drive_strength ] [ signed ]
[ delay3 ] list_of_net_decl_assignments ;
| trireg [ charge_strength ] [ vectored | scalared ] [ signed ]
range [ delay3 ] list_of_net_identifiers ;
| trireg [ drive_strength ] [ vectored | scalared ] [ signed ]
range [ delay3 ] list_of_net_decl_assignments ;
real_declaration ::= real list_of_real_identifiers ;
realtime_declaration ::= realtime list_of_real_identifiers ;
reg_declaration ::= reg [ signed ] [ range ]
list_of_variable_identifiers ;
time_declaration ::= time list_of_variable_identifiers ;
A.2.2 Declaration data types
A.2.2.1 Net and variable types
net_type ::=
supply0 | supply1
| tri
| triand | trior | tri0 | tri1
| uwire | wire | wand | wor
output_variable_type ::= integer | time
real_type ::=
real_identifier { dimension }
| real_identifier = constant_expression
variable_type ::=
variable_identifier { dimension }
| variable_identifier = constant_expression
A.2.2.2 Strengths
drive_strength ::=
( strength0 , strength1 )
| ( strength1 , strength0 )
| ( strength0 , highz1 )
| ( strength1 , highz0 )
490
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
| ( highz0 , strength1 )
| ( highz1 , strength0 )
strength0 ::= supply0 | strong0 | pull0 | weak0
strength1 ::= supply1 | strong1 | pull1 | weak1
charge_strength ::= ( small ) | ( medium ) | ( large )
A.2.2.3 Delays
delay3 ::=
# delay_value
| # ( mintypmax_expression [ , mintypmax_expression [ , mintypmax_expression ] ] )
delay2 ::=
# delay_value
| # ( mintypmax_expression [ , mintypmax_expression ] )
delay_value ::=
unsigned_number
| real_number
| identifier
A.2.3 Declaration lists
list_of_defparam_assignments ::= defparam_assignment { , defparam_assignment }
list_of_event_identifiers ::= event_identifier { dimension }
{ , event_identifier { dimension } }
list_of_net_decl_assignments ::= net_decl_assignment { , net_decl_assignment }
list_of_net_identifiers ::= net_identifier { dimension }
{ , net_identifier { dimension } }
list_of_param_assignments ::= param_assignment { , param_assignment }
list_of_port_identifiers ::= port_identifier { , port_identifier }
list_of_real_identifiers ::= real_type { , real_type }
list_of_specparam_assignments ::= specparam_assignment { , specparam_assignment }
list_of_variable_identifiers ::= variable_type { , variable_type }
list_of_variable_port_identifiers ::= port_identifier [ = constant_expression ]
{ , port_identifier [ = constant_expression ] }
A.2.4 Declaration assignments
defparam_assignment ::= hierarchical_parameter_identifier = constant_mintypmax_expression
net_decl_assignment ::= net_identifier = expression
param_assignment ::= parameter_identifier = constant_mintypmax_expression
specparam_assignment ::=
specparam_identifier = constant_mintypmax_expression
| pulse_control_specparam
pulse_control_specparam ::=
PATHPULSE$ = ( reject_limit_value [ , error_limit_value ] )
| PATHPULSE$specify_input_terminal_descriptor$specify_output_terminal_descriptor
= ( reject_limit_value [ , error_limit_value ] )
error_limit_value ::= limit_value
reject_limit_value ::= limit_value
limit_value ::= constant_mintypmax_expression
Copyright © 2006 IEEE. All rights reserved.
491
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
A.2.5 Declaration ranges
dimension ::= [ dimension_constant_expression : dimension_constant_expression ]
range ::= [ msb_constant_expression : lsb_constant_expression ]
A.2.6 Function declarations
function_declaration ::=
function [ automatic ] [ function_range_or_type ] function_identifier ;
function_item_declaration { function_item_declaration }
function_statement
endfunction
| function [ automatic ] [ function_range_or_type ] function_identifier ( function_port_list ) ;
{ block_item_declaration }
function_statement
endfunction
function_item_declaration ::=
block_item_declaration
| { attribute_instance } tf_input_declaration ;
function_port_list ::= { attribute_instance } tf_input_declaration { , { attribute_instance }
tf_input_declaration }
function_range_or_type ::=
[ signed ] [ range ]
| integer
| real
| realtime
| time
A.2.7 Task declarations
task_declaration ::=
task [ automatic ] task_identifier ;
{ task_item_declaration }
statement_or_null
endtask
| task [ automatic ] task_identifier ( [ task_port_list ] ) ;
{ block_item_declaration }
statement_or_null
endtask
task_item_declaration ::=
block_item_declaration
| { attribute_instance } tf_input_declaration ;
| { attribute_instance } tf_output_declaration ;
| { attribute_instance } tf_inout_declaration ;
task_port_list ::= task_port_item { , task_port_item }
task_port_item ::=
{ attribute_instance } tf_input_declaration
| { attribute_instance } tf_output_declaration
| { attribute_instance } tf_inout_declaration
492
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
tf_input_declaration ::=
input [ reg ] [ signed ] [ range ] list_of_port_identifiers
| input task_port_type list_of_port_identifiers
tf_output_declaration ::=
output [ reg ] [ signed ] [ range ] list_of_port_identifiers
| output task_port_type list_of_port_identifiers
tf_inout_declaration ::=
inout [ reg ] [ signed ] [ range ] list_of_port_identifiers
| inout task_port_type list_of_port_identifiers
task_port_type ::=
integer | real | realtime | time
A.2.8 Block item declarations
block_item_declaration ::=
{ attribute_instance } reg [ signed ] [ range ] list_of_block_variable_identifiers ;
| { attribute_instance } integer list_of_block_variable_identifiers ;
| { attribute_instance } time list_of_block_variable_identifiers ;
| { attribute_instance } real list_of_block_real_identifiers ;
| { attribute_instance } realtime list_of_block_real_identifiers ;
| { attribute_instance } event_declaration
| { attribute_instance } local_parameter_declaration ;
| { attribute_instance } parameter_declaration ;
list_of_block_variable_identifiers ::= block_variable_type { , block_variable_type }
list_of_block_real_identifiers ::= block_real_type { , block_real_type }
block_variable_type ::= variable_identifier { dimension }
block_real_type ::= real_identifier { dimension }
A.3 Primitive instances
A.3.1 Primitive instantiation and instances
gate_instantiation ::=
cmos_switchtype [delay3]
cmos_switch_instance { , cmos_switch_instance } ;
| enable_gatetype [drive_strength] [delay3]
enable_gate_instance { , enable_gate_instance } ;
| mos_switchtype [delay3]
mos_switch_instance { , mos_switch_instance } ;
| n_input_gatetype [drive_strength] [delay2]
n_input_gate_instance { , n_input_gate_instance } ;
| n_output_gatetype [drive_strength] [delay2]
n_output_gate_instance { , n_output_gate_instance } ;
| pass_en_switchtype [delay2]
pass_enable_switch_instance { , pass_enable_switch_instance } ;
| pass_switchtype
pass_switch_instance { , pass_switch_instance } ;
| pulldown [pulldown_strength]
Copyright © 2006 IEEE. All rights reserved.
493
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
pull_gate_instance { , pull_gate_instance } ;
| pullup [pullup_strength]
pull_gate_instance { , pull_gate_instance } ;
cmos_switch_instance ::= [ name_of_gate_instance ] ( output_terminal , input_terminal ,
ncontrol_terminal , pcontrol_terminal )
enable_gate_instance ::= [ name_of_gate_instance ] ( output_terminal , input_terminal , enable_terminal )
mos_switch_instance ::= [ name_of_gate_instance ] ( output_terminal , input_terminal , enable_terminal )
n_input_gate_instance ::= [ name_of_gate_instance ] ( output_terminal , input_terminal { , input_terminal } )
n_output_gate_instance ::= [ name_of_gate_instance ] ( output_terminal { , output_terminal } ,
input_terminal )
pass_switch_instance ::= [ name_of_gate_instance ] ( inout_terminal , inout_terminal )
pass_enable_switch_instance ::= [ name_of_gate_instance ] ( inout_terminal , inout_terminal ,
enable_terminal )
pull_gate_instance ::= [ name_of_gate_instance ] ( output_terminal )
name_of_gate_instance ::= gate_instance_identifier [ range ]
A.3.2 Primitive strengths
pulldown_strength ::=
( strength0 , strength1 )
| ( strength1 , strength0 )
| ( strength0 )
pullup_strength ::=
( strength0 , strength1 )
| ( strength1 , strength0 )
| ( strength1 )
A.3.3 Primitive terminals
enable_terminal ::= expression
inout_terminal ::= net_lvalue
input_terminal ::= expression
ncontrol_terminal ::= expression
output_terminal ::= net_lvalue
pcontrol_terminal ::= expression
A.3.4 Primitive gate and switch types
cmos_switchtype ::= cmos | rcmos
enable_gatetype ::= bufif0 | bufif1 | notif0 | notif1
mos_switchtype ::= nmos | pmos | rnmos | rpmos
n_input_gatetype ::= and | nand | or | nor | xor | xnor
n_output_gatetype ::= buf | not
pass_en_switchtype ::= tranif0 | tranif1 | rtranif1 | rtranif0
pass_switchtype ::= tran | rtran
494
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
A.4 Module instantiation and generate construct
A.4.1 Module instantiation
module_instantiation ::=
module_identifier [ parameter_value_assignment ]
module_instance { , module_instance } ;
parameter_value_assignment ::= # ( list_of_parameter_assignments )
list_of_parameter_assignments ::=
ordered_parameter_assignment { , ordered_parameter_assignment } |
named_parameter_assignment { , named_parameter_assignment }
ordered_parameter_assignment ::= expression
named_parameter_assignment ::= . parameter_identifier ( [ mintypmax_expression ] )
module_instance ::= name_of_module_instance ( [ list_of_port_connections ] )
name_of_module_instance ::= module_instance_identifier [ range ]
list_of_port_connections ::=
ordered_port_connection { , ordered_port_connection }
| named_port_connection { , named_port_connection }
ordered_port_connection ::= { attribute_instance } [ expression ]
named_port_connection ::= { attribute_instance } . port_identifier ( [ expression ] )
A.4.2 Generate construct
generate_region ::=
generate { module_or_generate_item } endgenerate
genvar_declaration ::=
genvar list_of_genvar_identifiers ;
list_of_genvar_identifiers ::=
genvar_identifier { , genvar_identifier }
loop_generate_construct ::=
for ( genvar_initialization ; genvar_expression ; genvar_iteration )
generate_block
genvar_initialization ::=
genvar_identifier = constant_expression
genvar_expression ::=
genvar_primary
| unary_operator { attribute_instance } genvar_primary
| genvar_expression binary_operator { attribute_instance } genvar_expression
| genvar_expression ? { attribute_instance } genvar_expression : genvar_expression
genvar_iteration ::=
genvar_identifier = genvar_expression
genvar_primary ::=
constant_primary
| genvar_identifier
conditional_generate_construct ::=
if_generate_construct
| case_generate_construct
if_generate_construct ::=
if ( constant_expression ) generate_block_or_null
Copyright © 2006 IEEE. All rights reserved.
495
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
[ else generate_block_or_null ]
case_generate_construct ::=
case ( constant_expression )
case_generate_item { case_generate_item } endcase
case_generate_item ::=
constant_expression { , constant_expression } : generate_block_or_null
| default [ : ] generate_block_or_null
generate_block ::=
module_or_generate_item
| begin [ : generate_block_identifier ] { module_or_generate_item } end
generate_block_or_null ::=
generate_block
| ;
A.5 UDP declaration and instantiation
A.5.1 UDP declaration
udp_declaration ::=
{ attribute_instance } primitive udp_identifier ( udp_port_list ) ;
udp_port_declaration { udp_port_declaration }
udp_body
endprimitive
| { attribute_instance } primitive udp_identifier ( udp_declaration_port_list ) ;
udp_body
endprimitive
A.5.2 UDP ports
udp_port_list ::= output_port_identifier , input_port_identifier { , input_port_identifier }
udp_declaration_port_list ::=
udp_output_declaration , udp_input_declaration { , udp_input_declaration }
udp_port_declaration ::=
udp_output_declaration ;
| udp_input_declaration ;
| udp_reg_declaration ;
udp_output_declaration ::=
{ attribute_instance } output port_identifier
| { attribute_instance } output reg port_identifier [ = constant_expression ]
udp_input_declaration ::= { attribute_instance } input list_of_port_identifiers
udp_reg_declaration ::= { attribute_instance } reg variable_identifier
A.5.3 UDP body
udp_body ::= combinational_body | sequential_body
combinational_body ::= table combinational_entry { combinational_entry } endtable
combinational_entry ::= level_input_list : output_symbol ;
sequential_body ::= [ udp_initial_statement ] table sequential_entry { sequential_entry } endtable
496
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
udp_initial_statement ::= initial output_port_identifier = init_val ;
init_val ::= 1'b0 | 1'b1 | 1'bx | 1'bX | 1'B0 | 1'B1 | 1'Bx | 1'BX | 1 | 0
sequential_entry ::= seq_input_list : current_state : next_state ;
seq_input_list ::= level_input_list | edge_input_list
level_input_list ::= level_symbol { level_symbol }
edge_input_list ::= { level_symbol } edge_indicator { level_symbol }
edge_indicator ::= ( level_symbol level_symbol ) | edge_symbol
current_state ::= level_symbol
next_state ::= output_symbol | -
output_symbol ::= 0 | 1 | x | X
level_symbol ::= 0 | 1 | x | X | ? | b | B
edge_symbol ::= r | R | f | F | p | P | n | N | *
A.5.4 UDP instantiation
udp_instantiation ::= udp_identifier [ drive_strength ] [ delay2 ]
udp_instance { , udp_instance } ;
udp_instance ::= [ name_of_udp_instance ] ( output_terminal , input_terminal
{ , input_terminal } )
name_of_udp_instance ::= udp_instance_identifier [ range ]
A.6 Behavioral statements
A.6.1 Continuous assignment statements
continuous_assign ::= assign [ drive_strength ] [ delay3 ] list_of_net_assignments ;
list_of_net_assignments ::= net_assignment { , net_assignment }
net_assignment ::= net_lvalue = expression
A.6.2 Procedural blocks and assignments
initial_construct ::= initial statement
always_construct ::= always statement
blocking_assignment ::= variable_lvalue = [ delay_or_event_control ] expression
nonblocking_assignment ::= variable_lvalue <= [ delay_or_event_control ] expression
procedural_continuous_assignments ::=
assign variable_assignment
| deassign variable_lvalue
| force variable_assignment
| force net_assignment
| release variable_lvalue
| release net_lvalue
variable_assignment ::= variable_lvalue = expression
A.6.3 Parallel and sequential blocks
par_block ::= fork [ : block_identifier
{ block_item_declaration } ] { statement } join
Copyright © 2006 IEEE. All rights reserved.
497
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
seq_block ::= begin [ : block_identifier
{ block_item_declaration } ] { statement } end
A.6.4 Statements
statement ::=
{ attribute_instance } blocking_assignment ;
| { attribute_instance } case_statement
| { attribute_instance } conditional_statement
| { attribute_instance } disable_statement
| { attribute_instance } event_trigger
| { attribute_instance } loop_statement
| { attribute_instance } nonblocking_assignment ;
| { attribute_instance } par_block
| { attribute_instance } procedural_continuous_assignments ;
| { attribute_instance } procedural_timing_control_statement
| { attribute_instance } seq_block
| { attribute_instance } system_task_enable
| { attribute_instance } task_enable
| { attribute_instance } wait_statement
statement_or_null ::=
statement
| { attribute_instance } ;
function_statement 1 ::= statement
A.6.5 Timing control statements
delay_control ::=
# delay_value
| # ( mintypmax_expression )
delay_or_event_control ::=
delay_control
| event_control
| repeat ( expression ) event_control
disable_statement ::=
disable hierarchical_task_identifier ;
| disable hierarchical_block_identifier ;
event_control ::=
@ hierarchical_event_identifier
| @ ( event_expression )
| @*
| @ (*)
event_trigger ::=
-> hierarchical_event_identifier { [ expression ] } ;
event_expression ::=
expression
| posedge expression
| negedge expression
| event_expression or event_expression
498
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
| event_expression , event_expression
procedural_timing_control ::=
delay_control
| event_control
procedural_timing_control_statement ::=
procedural_timing_control statement_or_null
wait_statement ::=
wait ( expression ) statement_or_null
A.6.6 Conditional statements
conditional_statement ::=
if ( expression )
statement_or_null [ else statement_or_null ]
| if_else_if_statement
if_else_if_statement ::=
if ( expression ) statement_or_null
{ else if ( expression ) statement_or_null }
[ else statement_or_null ]
A.6.7 Case statements
case_statement ::=
case ( expression )
case_item { case_item } endcase
| casez ( expression )
case_item { case_item } endcase
| casex ( expression )
case_item { case_item } endcase
case_item ::=
expression { , expression } : statement_or_null
| default [ : ] statement_or_null
A.6.8 Looping statements
loop_statement ::=
forever statement
| repeat ( expression ) statement
| while ( expression ) statement
| for ( variable_assignment ; expression ; variable_assignment )
statement
A.6.9 Task enable statements
system_task_enable ::= system_task_identifier [ ( [ expression ] { , [ expression ] } ) ] ;
task_enable ::= hierarchical_task_identifier [ ( expression { , expression } ) ] ;
Copyright © 2006 IEEE. All rights reserved.
499
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
A.7 Specify section
A.7.1 Specify block declaration
specify_block ::= specify { specify_item } endspecify
specify_item ::=
specparam_declaration
| pulsestyle_declaration
| showcancelled_declaration
| path_declaration
| system_timing_check
pulsestyle_declaration ::=
pulsestyle_onevent list_of_path_outputs ;
| pulsestyle_ondetect list_of_path_outputs ;
showcancelled_declaration ::=
showcancelled list_of_path_outputs ;
| noshowcancelled list_of_path_outputs ;
A.7.2 Specify path declarations
path_declaration ::=
simple_path_declaration ;
| edge_sensitive_path_declaration ;
| state_dependent_path_declaration ;
simple_path_declaration ::=
parallel_path_description = path_delay_value
| full_path_description = path_delay_value
parallel_path_description ::=
( specify_input_terminal_descriptor [ polarity_operator ] => specify_output_terminal_descriptor )
full_path_description ::=
( list_of_path_inputs [ polarity_operator ] *> list_of_path_outputs )
list_of_path_inputs ::=
specify_input_terminal_descriptor { , specify_input_terminal_descriptor }
list_of_path_outputs ::=
specify_output_terminal_descriptor { , specify_output_terminal_descriptor }
A.7.3 Specify block terminals
specify_input_terminal_descriptor ::=
input_identifier [ [ constant_range_expression ] ]
specify_output_terminal_descriptor ::=
output_identifier [ [ constant_range_expression ] ]
input_identifier ::= input_port_identifier | inout_port_identifier
output_identifier ::= output_port_identifier | inout_port_identifier
A.7.4 Specify path delays
path_delay_value ::=
list_of_path_delay_expressions
500
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
| ( list_of_path_delay_expressions )
list_of_path_delay_expressions ::=
t_path_delay_expression
| trise_path_delay_expression , tfall_path_delay_expression
| trise_path_delay_expression , tfall_path_delay_expression , tz_path_delay_expression
| t01_path_delay_expression , t10_path_delay_expression , t0z_path_delay_expression ,
tz1_path_delay_expression , t1z_path_delay_expression , tz0_path_delay_expression
| t01_path_delay_expression , t10_path_delay_expression , t0z_path_delay_expression ,
tz1_path_delay_expression , t1z_path_delay_expression , tz0_path_delay_expression ,
t0x_path_delay_expression , tx1_path_delay_expression , t1x_path_delay_expression ,
tx0_path_delay_expression , txz_path_delay_expression , tzx_path_delay_expression
t_path_delay_expression ::= path_delay_expression
trise_path_delay_expression ::= path_delay_expression
tfall_path_delay_expression ::= path_delay_expression
tz_path_delay_expression ::= path_delay_expression
t01_path_delay_expression ::= path_delay_expression
t10_path_delay_expression ::= path_delay_expression
t0z_path_delay_expression ::= path_delay_expression
tz1_path_delay_expression ::= path_delay_expression
t1z_path_delay_expression ::= path_delay_expression
tz0_path_delay_expression ::= path_delay_expression
t0x_path_delay_expression ::= path_delay_expression
tx1_path_delay_expression ::= path_delay_expression
t1x_path_delay_expression ::= path_delay_expression
tx0_path_delay_expression ::= path_delay_expression
txz_path_delay_expression ::= path_delay_expression
tzx_path_delay_expression ::= path_delay_expression
path_delay_expression ::= constant_mintypmax_expression
edge_sensitive_path_declaration ::=
parallel_edge_sensitive_path_description = path_delay_value
| full_edge_sensitive_path_description = path_delay_value
parallel_edge_sensitive_path_description ::=
( [ edge_identifier ] specify_input_terminal_descriptor =>
( specify_output_terminal_descriptor [ polarity_operator ] : data_source_expression ) )
full_edge_sensitive_path_description ::=
( [ edge_identifier ] list_of_path_inputs *>
( list_of_path_outputs [ polarity_operator ] : data_source_expression ) )
data_source_expression ::= expression
edge_identifier ::= posedge | negedge
state_dependent_path_declaration ::=
if ( module_path_expression ) simple_path_declaration
| if ( module_path_expression ) edge_sensitive_path_declaration
| ifnone simple_path_declaration
polarity_operator ::= + | -
Copyright © 2006 IEEE. All rights reserved.
501
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
A.7.5 System timing checks
A.7.5.1 System timing check commands
system_timing_check ::=
$setup_timing_check
| $hold_timing_check
| $setuphold_timing_check
| $recovery_timing_check
| $removal_timing_check
| $recrem_timing_check
| $skew_timing_check
| $timeskew_timing_check
| $fullskew_timing_check
| $period_timing_check
| $width_timing_check
| $nochange_timing_check
$setup_timing_check ::=
$setup ( data_event , reference_event , timing_check_limit [ , [ notifier ] ] ) ;
$hold_timing_check ::=
$hold ( reference_event , data_event , timing_check_limit [ , [ notifier ] ] ) ;
$setuphold_timing_check ::=
$setuphold ( reference_event , data_event , timing_check_limit , timing_check_limit
[ , [ notifier ] [ , [ stamptime_condition ] [ , [ checktime_condition ]
[ , [ delayed_reference ] [ , [ delayed_data ] ] ] ] ] ] ) ;
$recovery_timing_check ::=
$recovery ( reference_event , data_event , timing_check_limit [ , [ notifier ] ] ) ;
$removal_timing_check ::=
$removal ( reference_event , data_event , timing_check_limit [ , [ notifier ] ] ) ;
$recrem_timing_check ::=
$recrem ( reference_event , data_event , timing_check_limit , timing_check_limit
[ , [ notifier ] [ , [ stamptime_condition ] [ , [ checktime_condition ]
[ , [ delayed_reference ] [ , [ delayed_data ] ] ] ] ] ] ) ;
$skew_timing_check ::=
$skew ( reference_event , data_event , timing_check_limit [ , [ notifier ] ] ) ;
$timeskew_timing_check ::=
$timeskew ( reference_event , data_event , timing_check_limit
[ , [ notifier ] [ , [ event_based_flag ] [ , [ remain_active_flag ] ] ] ] ) ;
$fullskew_timing_check ::=
$fullskew ( reference_event , data_event , timing_check_limit , timing_check_limit
[ , [ notifier ] [ , [ event_based_flag ] [ , [ remain_active_flag ] ] ] ] ) ;
$period_timing_check ::=
$period ( controlled_reference_event , timing_check_limit [ , [ notifier ] ] ) ;
$width_timing_check ::=
$width ( controlled_reference_event , timing_check_limit
[ , threshold [ , notifier ] ] ) ;
$nochange_timing_check ::=
$nochange ( reference_event , data_event , start_edge_offset ,
end_edge_offset [ , [ notifier ] ] ) ;
502
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
A.7.5.2 System timing check command arguments
checktime_condition ::= mintypmax_expression
controlled_reference_event ::= controlled_timing_check_event
data_event ::= timing_check_event
delayed_data ::=
terminal_identifier
| terminal_identifier [ constant_mintypmax_expression ]
delayed_reference ::=
terminal_identifier
| terminal_identifier [ constant_mintypmax_expression ]
end_edge_offset ::= mintypmax_expression
event_based_flag ::= constant_expression
notifier ::= variable_identifier
reference_event ::= timing_check_event
remain_active_flag ::= constant_expression
stamptime_condition ::= mintypmax_expression
start_edge_offset ::= mintypmax_expression
threshold ::= constant_expression
timing_check_limit ::= expression
A.7.5.3 System timing check event definitions
timing_check_event ::=
[timing_check_event_control] specify_terminal_descriptor [ &&& timing_check_condition ]
controlled_timing_check_event ::=
timing_check_event_control specify_terminal_descriptor [ &&& timing_check_condition ]
timing_check_event_control ::=
posedge
| negedge
| edge_control_specifier
specify_terminal_descriptor ::=
specify_input_terminal_descriptor
| specify_output_terminal_descriptor
edge_control_specifier ::= edge [ edge_descriptor { , edge_descriptor } ]
edge_descriptor 2 ::=
01
| 10
| z_or_x zero_or_one
| zero_or_one z_or_x
zero_or_one ::= 0 | 1
z_or_x ::= x | X | z | Z
timing_check_condition ::=
scalar_timing_check_condition
| ( scalar_timing_check_condition )
Copyright © 2006 IEEE. All rights reserved.
503
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
scalar_timing_check_condition ::=
expression
| ~ expression
| expression == scalar_constant
| expression === scalar_constant
| expression != scalar_constant
| expression !== scalar_constant
scalar_constant ::=
1'b0 | 1'b1 | 1'B0 | 1'B1 | 'b0 | 'b1 | 'B0 | 'B1 | 1 | 0
A.8 Expressions
A.8.1 Concatenations
concatenation ::= { expression { , expression } }
constant_concatenation ::= { constant_expression { , constant_expression } }
constant_multiple_concatenation ::= { constant_expression constant_concatenation }
module_path_concatenation ::= { module_path_expression { , module_path_expression } }
module_path_multiple_concatenation ::= { constant_expression module_path_concatenation }
multiple_concatenation ::= { constant_expression concatenation }
A.8.2 Function calls
constant_function_call ::= function_identifier { attribute_instance }
( constant_expression { , constant_expression } )
constant_system_function_call ::= system_function_identifier
( constant_expression { , constant_expression } )
function_call ::= hierarchical_function_identifier{ attribute_instance }
( expression { , expression } )
system_function_call ::= system_function_identifier
[ ( expression { , expression } ) ]
A.8.3 Expressions
base_expression ::= expression
conditional_expression ::= expression1 ? { attribute_instance } expression2 : expression3
constant_base_expression ::= constant_expression
constant_expression ::=
constant_primary
| unary_operator { attribute_instance } constant_primary
| constant_expression binary_operator { attribute_instance } constant_expression
| constant_expression ? { attribute_instance } constant_expression : constant_expression
constant_mintypmax_expression ::=
constant_expression
| constant_expression : constant_expression : constant_expression
constant_range_expression ::=
constant_expression
| msb_constant_expression : lsb_constant_expression
504
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
| constant_base_expression +: width_constant_expression
| constant_base_expression -: width_constant_expression
dimension_constant_expression ::= constant_expression
expression ::=
primary
| unary_operator { attribute_instance } primary
| expression binary_operator { attribute_instance } expression
| conditional_expression
expression1 ::= expression
expression2 ::= expression
expression3 ::= expression
lsb_constant_expression ::= constant_expression
mintypmax_expression ::=
expression
| expression : expression : expression
module_path_conditional_expression ::= module_path_expression ? { attribute_instance }
module_path_expression : module_path_expression
module_path_expression ::=
module_path_primary
| unary_module_path_operator { attribute_instance } module_path_primary
| module_path_expression binary_module_path_operator { attribute_instance }
module_path_expression
| module_path_conditional_expression
module_path_mintypmax_expression ::=
module_path_expression
| module_path_expression : module_path_expression : module_path_expression
msb_constant_expression ::= constant_expression
range_expression ::=
expression
| msb_constant_expression : lsb_constant_expression
| base_expression +: width_constant_expression
| base_expression -: width_constant_expression
width_constant_expression ::= constant_expression
A.8.4 Primaries
constant_primary ::=
number
| parameter_identifier [ [ constant_range_expression ] ]
| specparam_identifier [ [ constant_range_expression ] ]
| constant_concatenation
| constant_multiple_concatenation
| constant_function_call
| constant_system_function_call
| ( constant_mintypmax_expression )
| string
Copyright © 2006 IEEE. All rights reserved.
505
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
module_path_primary ::=
number
| identifier
| module_path_concatenation
| module_path_multiple_concatenation
| function_call
| system_function_call
| ( module_path_mintypmax_expression )
primary ::=
number
| hierarchical_identifier [ { [ expression ] } [ range_expression ] ]
| concatenation
| multiple_concatenation
| function_call
| system_function_call
| ( mintypmax_expression )
| string
A.8.5 Expression left-side values
net_lvalue ::=
hierarchical_net_identifier [ { [ constant_expression ] } [ constant_range_expression ] ]
| { net_lvalue { , net_lvalue } }
variable_lvalue ::=
hierarchical_variable_identifier [ { [ expression ] } [ range_expression ] ]
| { variable_lvalue { , variable_lvalue } }
A.8.6 Operators
unary_operator ::=
+ | - | ! | ~ | & | ~& | | | ~| | ^ | ~^ | ^~
binary_operator ::=
+ | - | * | / | % | == | != | === | !== | && | || | **
| < | <= | > | >= | & | | | ^ | ^~ | ~^ | >> | << | >>> | <<<
unary_module_path_operator ::=
! | ~ | & | ~& | | | ~| | ^ | ~^ | ^~
binary_module_path_operator ::=
== | != | && | || | & | | | ^ | ^~ | ~^
A.8.7 Numbers
number ::=
decimal_number
| octal_number
| binary_number
| hex_number
| real_number
real_number 2 ::=
unsigned_number . unsigned_number
506
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
| unsigned_number [ . unsigned_number ] exp [ sign ] unsigned_number
exp ::= e | E
decimal_number ::=
unsigned_number
| [ size ] decimal_base unsigned_number
| [ size ] decimal_base x_digit { _ }
| [ size ] decimal_base z_digit { _ }
binary_number ::= [ size ] binary_base binary_value
octal_number ::= [ size ] octal_base octal_value
hex_number ::= [ size ] hex_base hex_value
sign ::= + | -
size ::= non_zero_unsigned_number
non_zero_unsigned_number 2 ::= non_zero_decimal_digit { _ | decimal_digit}
unsigned_number 2 ::= decimal_digit { _ | decimal_digit }
binary_value 2 ::= binary_digit { _ | binary_digit }
octal_value 2 ::= octal_digit { _ | octal_digit }
hex_value 2 ::= hex_digit { _ | hex_digit }
decimal_base 2 ::= '[s|S]d | '[s|S]D
binary_base 2 ::= '[s|S]b | '[s|S]B
octal_base 2 ::= '[s|S]o | '[s|S]O
hex_base 2 ::= '[s|S]h | '[s|S]H
non_zero_decimal_digit ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
decimal_digit ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
binary_digit ::= x_digit | z_digit | 0 | 1
octal_digit ::= x_digit | z_digit | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
hex_digit ::=
x_digit | z_digit | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
| a | b | c | d | e | f | A | B | C | D | E | F
x_digit ::= x | X
z_digit ::= z | Z | ?
A.8.8 Strings
string ::= " { Any_ASCII_Characters_except_new_line } "
A.9 General
A.9.1 Attributes
attribute_instance ::= (* attr_spec { , attr_spec } *)
attr_spec ::=
attr_name [ = constant_expression ]
attr_name ::= identifier
Copyright © 2006 IEEE. All rights reserved.
507
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.IEEE
Std 1364-2005
IEEE STANDARD FOR VERILOG ®
A.9.2 Comments
comment ::=
one_line_comment
| block_comment
one_line_comment ::= // comment_text \n
block_comment ::= /* comment_text */
comment_text ::= { Any_ASCII_character }
A.9.3 Identifiers
block_identifier ::= identifier
cell_identifier ::= identifier
config_identifier ::= identifier
escaped_identifier ::= \ {Any_ASCII_character_except_white_space} white_space
event_identifier ::= identifier
function_identifier ::= identifier
gate_instance_identifier ::= identifier
generate_block_identifier ::= identifier
genvar_identifier ::= identifier
hierarchical_block_identifier ::= hierarchical_identifier
hierarchical_event_identifier ::= hierarchical_identifier
hierarchical_function_identifier ::= hierarchical_identifier
hierarchical_identifier ::= { identifier [ [ constant_expression ] ] . } identifier
hierarchical_net_identifier ::= hierarchical_identifier
hierarchical_parameter_identifier ::= hierarchical_identifier
hierarchical_variable_identifier ::= hierarchical_identifier
hierarchical_task_identifier ::= hierarchical_identifier
identifier ::=
simple_identifier
| escaped_identifier
inout_port_identifier ::= identifier
input_port_identifier ::= identifier
instance_identifier ::= identifier
library_identifier ::= identifier
module_identifier ::= identifier
module_instance_identifier ::= identifier
net_identifier ::= identifier
output_port_identifier ::= identifier
parameter_identifier ::= identifier
port_identifier ::= identifier
real_identifier ::= identifier
simple_identifier 3 ::= [ a-zA-Z_ ] { [ a-zA-Z0-9_$ ] }
specparam_identifier ::= identifier
system_function_identifier 4 ::= $[ a-zA-Z0-9_$ ]{ [ a-zA-Z0-9_$ ] }
system_task_identifier 4 ::= $[ a-zA-Z0-9_$ ]{ [ a-zA-Z0-9_$ ] }
task_identifier ::= identifier
terminal_identifier ::= identifier
text_macro_identifier ::= identifier
508
Copyright © 2006 IEEE. All rights reserved.
Authorized licensed use limited to: University of Science and Technology of China. Downloaded on September 20,2012 at 02:33:32 UTC from IEEE Xplore. Restrictions apply.HARDWARE DESCRIPTION LANGUAGE
IEEE
Std 1364-2005
topmodule_identifier ::= identifier
udp_identifier ::= identifier
udp_instance_identifier ::= identifier
variable_identifier ::= identifier
A.9.4 White space
white_space ::= space | tab | newline | eof 5

%%

(*trailer*)

