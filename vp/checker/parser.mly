%{
(*head*)
open Printf
open Typedef



let get1 t = begin
	match t with
	(p,_,_) -> p
end
;;
let get_begin_pos t = get1 t 
;;
let get2 t = begin
	match t with
	(_,p,_) -> p
end
;;
let get_finish_pos t = get2 t 
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
let get3 t = begin
	match t with
	(_,_,str) -> str
end
;;
let get_string_ssy t = get3 t
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
%token  <Lexing.position*Lexing.position*string> KEY_PATHPULSE


%token <Lexing.position*Lexing.position*string> COMMENT 
%token <Lexing.position*Lexing.position*string> EOL
%token <Lexing.position*Lexing.position*string> EOF_INCLUDED
%token <Lexing.position*Lexing.position*string> EOF 

/*A.8.6 Operators*/
/*op for both unary and binary*/
%token <Lexing.position*Lexing.position*string> OP2_ADD
%token <Lexing.position*Lexing.position*string> OP2_SUB
%token <Lexing.position*Lexing.position*string> OP2_AND
%token <Lexing.position*Lexing.position*string> OP2_OR
%token <Lexing.position*Lexing.position*string> OP2_XOR
%token <Lexing.position*Lexing.position*string> OP2_XNOR

/*ops for unary*/
%token <Lexing.position*Lexing.position*string> OP1_LOGIC_NEG
%token <Lexing.position*Lexing.position*string> OP1_BITWISE_NEG
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
%token <Lexing.position*Lexing.position*string> OP2_AND2
%token <Lexing.position*Lexing.position*string> OP2_OR2
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



%token <Lexing.position*Lexing.position*string> DOLLOR /*$*/
%token <Lexing.position*Lexing.position*string> IMPLY /* -> */
%token <Lexing.position*Lexing.position*string> IMPLY2 /*=>*/
%token <Lexing.position*Lexing.position*string> IMPLYSTART /* *> */
%token <Lexing.position*Lexing.position*string> ADDRANGE /* +: */
%token <Lexing.position*Lexing.position*string> SUBRANGE /* -: */
%token <Lexing.position*Lexing.position*string> LPARENTSTART  /* -: */
%token <Lexing.position*Lexing.position*string> RPARENTSTART  /* -: */








/*A.8.7 Numbers */
%token <Lexing.position*Lexing.position*int> UNSIGNED_NUMBER
%token <Lexing.position*Lexing.position*(int*int) > UNSIGNED_NUMBER_size
%token <Lexing.position*Lexing.position*(int*string) > OCTAL_NUMBER
%token <Lexing.position*Lexing.position*(int*string) > BINARY_NUMBER
%token <Lexing.position*Lexing.position*(int*string) > HEX_NUMBER
%token <Lexing.position*Lexing.position*string> REAL_NUMBER
/*A.8.8 Strings*/
%token <Lexing.position*Lexing.position*string> STRING
/*A.9.3 Identifiers*/
%token <Lexing.position*Lexing.position*string> ESCAPED_IDENTIFIER
%token <Lexing.position*Lexing.position*string> SIMPLE_IDENTIFIER
%token  <Lexing.position*Lexing.position*string> SYSTEM_TASK_FUNCTION_IDENTIFIER


%right OP2_QUESTION
%left  OP2_OR2
%left  OP2_AND2
%left  OP2_OR
%left  OP2_XOR OP2_XNOR
%left  OP2_AND
%left  OP2_EQU2 OP2_NEQ2 OP2_EQU3 OP2_NEQ3
%left  OP2_LT OP2_LE OP2_GT OP2_GE
%left  OP2_LOGICAL_LEFTSHIFT OP2_LOGICAL_RIGHTSHIFT OP2_ARITHMETIC_LEFTSHIFT OP2_ARITHMETIC_RIGHTSHIFT
%left  OP2_ADD OP2_SUB
%left  OP2_MULTIPLE OP2_DIV OP2_MOD
%left  OP2_POWER
/*unary only operator*/
%left  OP1_LOGIC_NEG  OP1_BITWISE_NEG OP1_REDUCE_NAND OP1_REDUCE_NOR
/*unary operator symbol that maybe used as binary operator*/
%nonassoc   OP1_ADD OP1_SUB OP1_AND OP1_OR OP1_XOR OP1_XNOR







%start source_text
%type <Typedef.description list> source_text

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
;
non_port_module_item_list :
	{[]}
	| non_port_module_item non_port_module_item_list
		{$1::$2}
;

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
	| COMMA parameter_declaration comma_parameter_declaration_list
		{$2::$3}
;

list_of_ports : 
	LPARENT 
		port comma_port_list
	RPARENT
		{$2::$3}
;

comma_port_list :
	{[]}
	| COMMA port comma_port_list
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


comma_port_declaration_list :
	{[]}
	| COMMA port_declaration comma_port_declaration_list
		{$2::$3}

port :
	port_expression_opt {T_port_position($1)}
	| PERIOD  port_identifier LPARENT port_expression_opt RPARENT
		{T_port_exp($2,$4)}
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

comma_port_reference_list :
	{[]}
	| COMMA port_reference comma_port_reference_list 
		{$2::$3}
;

port_reference :
	port_identifier lsquare_range_expression_rsquare_opt
		{T_port_reference($1,$2)}
;

lsquare_range_expression_rsquare_opt :
	{T_range_expression_NOSPEC}
	| lsquare_range_expression_rsquare {$1}
;

lsquare_range_expression_rsquare :
	LSQUARE
		range_expression
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
/*	| specify_block {
		T_module_item__specify_block($1)}*/
	| attribute_instance_list parameter_declaration SEMICOLON {
		T_module_item__parameter_declaration($1,$2)}
/*	| attribute_instance_list specparam_declaration {
		T_module_item__specparam_declaration($1,$2)}*/
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
		T_module_item__genvar_declaration($1,$2)}
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
;

/*A.1.5 Configuration source text*/
config_declaration :
	KEY_CONFIG config_identifier SEMICOLON
	design_statement
	config_rule_statement_list
	KEY_ENDCONFIG
	{T_config_declaration($2,$4,$5)}
;


config_rule_statement_list :
	{[]}
	| config_rule_statement config_rule_statement_list
		{$1::$2}
;

design_statement : 
	KEY_DESIGN 
		library_identifier_period_opt_cell_identifier_list
	SEMICOLON
		{T_design_statement($2)}
;

library_identifier_period_opt_cell_identifier_list :
	{[]}
	| library_identifier_period_opt_cell_identifier_list library_identifier_period_opt_cell_identifier  
		{$1@[$2]}
;

library_identifier_period_opt_cell_identifier :
	library_identifier_period_opt cell_identifier
	{T_lib_cell_identifier($1,$2)}
;

library_identifier_period_opt :
	{T_identifier_NOSPEC}
	| library_identifier PERIOD {$1}
;

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
;

inst_clause : 
	KEY_INSTANCE inst_name {$2}
;

inst_name : 
	topmodule_identifier comma_instance_identifier_list
	{$1::$2}
;

comma_instance_identifier_list :
	{[]}
	| COMMA instance_identifier comma_instance_identifier_list
	{$2::$3}
;

cell_clause :
	KEY_CELL library_identifier_period_opt_cell_identifier {$2}
;

liblist_clause :
	KEY_LIBLIST library_identifier_list {$2}
;

library_identifier_list :
	{[]}
	| library_identifier library_identifier_list {$1::$2}
;

use_clause :
	KEY_USE library_identifier_period_opt_cell_identifier colon_config_opt
		{T_use_clause($2,$3)}
;

colon_config_opt :
	{T_colon_config_opt_FALSE}
	| COLON KEY_CONFIG  {T_colon_config_opt_TRUE}
;

/*A.2 Declarations
A.2.1 Declaration types
A.2.1.1 Module parameter declarations*/

local_parameter_declaration :
	KEY_LOCALPARAM signed_opt range_opt list_of_param_assignments
		{T_local_parameter_declaration_1($2,$3,$4)}
	| KEY_LOCALPARAM parameter_type list_of_param_assignments
		{T_local_parameter_declaration_2($2,$3)}
;

signed_opt :
	{T_signed_FALSE}
	| KEY_SIGNED {T_signed_TRUE}
;

range_opt :
	{T_range_NOSPEC}
	| range {$1}
;

parameter_declaration :
	KEY_PARAMETER signed_opt range_opt list_of_param_assignments
		{T_parameter_declaration_1($2,$3,$4)}
	| KEY_PARAMETER parameter_type list_of_param_assignments
		{T_parameter_declaration_2($2,$3)}
;

/*specparam_declaration :
	KEY_SPECPARAM range_opt list_of_specparam_assignments SEMICOLON
		{T_specparam_declaration($2,$3)}
;
*/
parameter_type :
	KEY_INTEGER {T_parameter_type__INTEGER}
	| KEY_REAL 	{T_parameter_type__REAL}
	| KEY_REALTIME {T_parameter_type__REALTIME}
	| KEY_TIME	{T_parameter_type__TIME}
;

/*A.2.1.2 Port declarations*/
inout_declaration :
	KEY_INOUT net_type_opt signed_opt range_opt list_of_port_identifiers
		{T_inout_declaration($2,$3,$4,$5)}
;

net_type_opt :
	{T_net_type_NOSPEC}
	| net_type {$1}
;

input_declaration :
	KEY_INPUT net_type_opt signed_opt  range_opt list_of_port_identifiers
		{T_input_declaration($2,$3,$4,$5)}
;

output_declaration :
	KEY_OUTPUT net_type_opt signed_opt range_opt list_of_port_identifiers
		{T_output_declaration_net($2,$3,$4,$5)}
	| KEY_OUTPUT KEY_REG signed_opt range_opt list_of_variable_port_identifiers
		{T_output_declaration_reg($3,$4,$5)}
	| KEY_OUTPUT output_variable_type list_of_variable_port_identifiers
		{T_output_declaration_var($2,$3)}
;		


/*A.2.1.3 Type declarations*/
event_declaration :
	KEY_EVENT list_of_event_identifiers SEMICOLON
		{T_event_declaration($2)}
;

integer_declaration :
	KEY_INTEGER list_of_variable_identifiers SEMICOLON
		{T_integer_declaration($2)}
;

net_declaration :
	net_type signed_opt delay3_opt list_of_net_identifiers SEMICOLON
		{T_net_declaration_net_type1($1,$2,$3,$4)}
	| net_type drive_strength_opt signed_opt delay3_opt list_of_net_decl_assignments SEMICOLON
		{T_net_declaration_net_type2($1,$2,$3,$4,$5)}
	| net_type vectored_scalared_opt signed_opt range delay3_opt list_of_net_identifiers SEMICOLON
		{T_net_declaration_net_type3($1,$2,$3,$4,$5,$6)}
	| net_type drive_strength_opt vectored_scalared_opt signed_opt range delay3_opt list_of_net_decl_assignments SEMICOLON
		{T_net_declaration_net_type4($1,$2,$3,$4,$5,$6,$7)}
	| KEY_TRIREG charge_strength_opt signed_opt delay3_opt list_of_net_identifiers SEMICOLON
		{T_net_declaration_trireg_1($2,$3,$4,$5)}
	| KEY_TRIREG drive_strength_opt signed_opt delay3_opt list_of_net_decl_assignments SEMICOLON
		{T_net_declaration_trireg_2($2,$3,$4,$5)}
	| KEY_TRIREG charge_strength_opt vectored_scalared_opt signed_opt range delay3_opt list_of_net_identifiers SEMICOLON
		{T_net_declaration_trireg_3($2,$3,$4,$5,$6)}
	| KEY_TRIREG drive_strength_opt vectored_scalared_opt signed_opt range delay3_opt list_of_net_decl_assignments SEMICOLON
		{T_net_declaration_trireg_4($2,$3,$4,$5,$6,$7)}
;

charge_strength_opt :
	{T_charge_strength_NOSPEC}
	| charge_strength {$1}
;

delay3_opt :
	{T_delay3_NOSPEC}
	| delay3 {$1}
;

vectored_scalared_opt :
	{T_vectored_scalared_NOSPEC}
	| KEY_VECTORED {T_vectored_scalared_vectored}
	| KEY_SCALARED {T_vectored_scalared_scalared}
;

drive_strength_opt :
	{T_drive_strength_NOSPEC}
	| drive_strength {$1}
;

real_declaration :
	KEY_REAL list_of_real_identifiers SEMICOLON
		{T_real_declaration($2)}
;

realtime_declaration :
	KEY_REALTIME list_of_real_identifiers SEMICOLON
		{T_realtime_declaration($2)}
;

reg_declaration : 
	KEY_REG signed_opt range_opt list_of_variable_identifiers SEMICOLON
		{T_reg_declaration($2,$3,$4)}
;

time_declaration :
	KEY_TIME list_of_variable_identifiers SEMICOLON
		{T_time_declaration($2)}
;

/*A.2.2 Declaration data types
A.2.2.1 Net and variable types*/
net_type :
	KEY_SUPPLY0 	{T_net_type__KEY_SUPPLY0}
	| KEY_SUPPLY1	{T_net_type__KEY_SUPPLY1}
	| KEY_TRI			{T_net_type__KEY_TRI}
	| KEY_TRIAND 	{T_net_type__KEY_TRIAND}
	| KEY_TRIOR 			{T_net_type__KEY_TRIOR}
	| KEY_TRI0 				{T_net_type__KEY_TRI0}
	| KEY_TRI1				{T_net_type__KEY_TRI1}
	| KEY_UWIRE 			{T_net_type__KEY_UWIRE}
	| KEY_WIRE 				{T_net_type__KEY_WIRE}
	| KEY_WAND 				{T_net_type__KEY_WAND}
	| KEY_WOR					{T_net_type__KEY_WOR}
;

output_variable_type :
	KEY_INTEGER {T_output_variable_type_INTEGER}
	| KEY_TIME {T_output_variable_type_TIME}
;

real_type :
	real_identifier dimension_list
		{T_real_type_noass($1,$2)}
	| real_identifier EQU1 expression
		{T_real_type_ass($1,$3)}
;

dimension_list :
	{[]}
	| dimension dimension_list
		{$1::$2}
;

variable_type :
	variable_identifier dimension_list
		{T_variable_type_noass($1,$2)}
	| variable_identifier EQU1 expression
		{T_variable_type_ass($1,$3)}
;

/*A.2.2.2 Strengths*/

drive_strength :
	LPARENT strength0 COMMA strength1 RPARENT
		{T_drive_strength($2,$4)}
	| LPARENT strength1 COMMA strength0 RPARENT
		{T_drive_strength($2,$4)}
	| LPARENT strength0 COMMA KEY_HIGHZ1 RPARENT
		{T_drive_strength($2,KEY_HIGHZ1)}
	| LPARENT strength1 COMMA KEY_HIGHZ0 RPARENT
		{T_drive_strength($2,KEY_HIGHZ0)}
	| LPARENT KEY_HIGHZ0 COMMA strength1 RPARENT
		{T_drive_strength(KEY_HIGHZ0,$4)}
	| LPARENT KEY_HIGHZ1 COMMA strength0 RPARENT
		{T_drive_strength(KEY_HIGHZ1,$4)}
;



strength0 :
	KEY_SUPPLY0		{KEY_SUPPLY0}
	| KEY_STRONG0		{KEY_STRONG0}
	| KEY_PULL0			{KEY_PULL0}
	| KEY_WEAK0 {KEY_WEAK0}
;
strength1 :
	KEY_SUPPLY1		{KEY_SUPPLY1}
	| KEY_STRONG1		{KEY_STRONG1}
	| KEY_PULL1			{KEY_PULL1}
	| KEY_WEAK1 {KEY_WEAK1}
;

charge_strength : 
	LPARENT KEY_SMALL RPARENT 
		{T_charge_strength__small}
	| LPARENT KEY_MEDIUM RPARENT 
		{T_charge_strength__medium}
	| LPARENT KEY_LARGE RPARENT
		{T_charge_strength__large}
;

/*A.2.2.3 Delays*/

delay3 :
	JING delay_value
		{T_delay3_1($2)}
	| JING LPARENT mintypmax_expression  RPARENT
		{T_delay3_minmax1($3)}
	| JING LPARENT mintypmax_expression  COMMA mintypmax_expression RPARENT
		{T_delay3_minmax2($3,$5)}
	| JING LPARENT mintypmax_expression  COMMA mintypmax_expression COMMA mintypmax_expression  RPARENT
		{T_delay3_minmax3($3,$5,$7)}
;


delay2 :
	JING delay_value
		{T_delay2_1($2)}
	| JING LPARENT mintypmax_expression RPARENT
		{T_delay2_minmax1($3)}
	| JING LPARENT mintypmax_expression COMMA mintypmax_expression  RPARENT
		{T_delay2_minmax2($3,$5)}
;


delay_value :
	UNSIGNED_NUMBER
		{T_delay_value_UNSIGNED_NUMBER(get1 $1, get2 $1, get3 $1)}
	| REAL_NUMBER
	 {T_delay_value_REAL_NUMBER(get1 $1, get2 $1, get3 $1)}
	| identifier
		{T_delay_value_id($1)}
;

/*A.2.3 Declaration lists*/
list_of_defparam_assignments :
	defparam_assignment comma_defparam_assignment_list
		{$1::$2}
;

comma_defparam_assignment_list :
	{[]}
	|COMMA defparam_assignment comma_defparam_assignment_list
		{$2::$3}
;

list_of_event_identifiers :
	event_identifier_dimension_list comma_event_identifier_dimension_list_list
		{$1::$2}
;

comma_event_identifier_dimension_list_list :
	{[]}
	| COMMA event_identifier_dimension_list comma_event_identifier_dimension_list_list
		{$2::$3}
;

event_identifier_dimension_list :
	event_identifier dimension_list
		{T_event_identifier_dimension_list($1,$2)}
;

list_of_net_decl_assignments :
	net_decl_assignment comma_net_decl_assignment_list
		{$1::$2}
;

comma_net_decl_assignment_list :
	{[]}
	| COMMA net_decl_assignment comma_net_decl_assignment_list
		{$2::$3}
;


list_of_net_identifiers :
	net_identifier_dimension_list
	comma_net_identifier_dimension_list_list
		{$1::$2}
;


net_identifier_dimension_list :
	net_identifier dimension_list
		{T_net_identifier_dimension_list($1,$2)}
;

comma_net_identifier_dimension_list_list:
	{[]}
	| COMMA net_identifier_dimension_list comma_net_identifier_dimension_list_list
		{$2::$3}
;

list_of_param_assignments :
	param_assignment comma_param_assignment_list
		{$1::$2}
;

comma_param_assignment_list :
	{[]}
	| COMMA param_assignment comma_param_assignment_list
		{$2::$3}
;

list_of_port_identifiers :
	port_identifier comma_port_identifier_list
		{$1::$2}
;

comma_port_identifier_list :
	{[]}
	| COMMA port_identifier comma_port_identifier_list
		{$2::$3}
;

list_of_real_identifiers :
	real_type comma_real_type_list
		{$1::$2}
;

comma_real_type_list :
	{[]}
	| COMMA real_type comma_real_type_list
		{$2::$3}
;

/*list_of_specparam_assignments :
	specparam_assignment comma_specparam_assignment_list
		{$1::$2}
;

comma_specparam_assignment_list :
	{[]}
	| COMMA specparam_assignment comma_specparam_assignment_list
		{$2::$3}
;
*/
list_of_variable_identifiers :
	variable_type comma_variable_type_list
		{$1::$2}
;

comma_variable_type_list :
	{[]}
	| COMMA variable_type comma_variable_type_list
		{$2::$3}
;

list_of_variable_port_identifiers :
	port_identifier_equ1_expression_opt
	comma_port_identifier_equ1_expression_opt_list
		{$1::$2}
;

port_identifier_equ1_expression_opt :
	port_identifier equ1_expression_opt
		{T_port_identifier_equ1_expression_opt($1,$2)}
;

equ1_expression_opt :
	{T_expression_NOSPEC}
	| EQU1 expression {$2}
;

comma_port_identifier_equ1_expression_opt_list :
	{[]}
	| COMMA port_identifier_equ1_expression_opt comma_port_identifier_equ1_expression_opt_list
		{$2::$3}
;

	

/*A.2.4 Declaration assignments*/
defparam_assignment :
	hierarchical_parameter_identifier EQU1 mintypmax_expression
		{T_defparam_assignment($1,$3)}
;

net_decl_assignment :
	net_identifier EQU1 expression
		{T_net_decl_assignment($1,$3)}
;

param_assignment :
	parameter_identifier EQU1 mintypmax_expression
		{T_param_assignment($1,$3)}
;

/*specparam_assignment :
	specparam_identifier EQU1 mintypmax_expression
		{T_specparam_assignment($1,$3)}
	| pulse_control_specparam
		{$1}
;


pulse_control_specparam :
	KEY_PATHPULSE EQU1 LPARENT reject_limit_value comma_error_limit_value_opt RPARENT
		{T_specparam_assignment_pulse1($4,$5)}
	| KEY_PATHPULSE specify_input_terminal_descriptor DOLLOR specify_output_terminal_descriptor EQU1 LPARENT reject_limit_value comma_error_limit_value_opt RPARENT
		{T_specparam_assignment_pulse2($2,$4,$7,$8)}
;
comma_error_limit_value_opt :
	{T_mintypmax_expression_NOSPEC}
	| COMMA error_limit_value {$2}
;	

error_limit_value : 
	limit_value
	{$1}
;

reject_limit_value :
	limit_value
		{$1}
;

limit_value : 
	mintypmax_expression
		{$1}
;

*/

/*A.2.5 Declaration ranges*/
dimension :
	LSQUARE	dimension_expression COLON dimension_expression RSQUARE
		{T_dimension($2,$4)}
;

range :
	LSQUARE expression COLON expression RSQUARE
		{T_range($2,$4)}
;


/*A.2.6 Function declarations*/
function_declaration :
	KEY_FUNCTION automatic_opt function_range_or_type_opt function_identifier SEMICOLON
	function_item_declaration function_item_declaration_list
	function_statement
	KEY_ENDFUNCTION
		{T_function_declaration_1($2,$3,$4,$6::$7,$8)}	
| KEY_FUNCTION automatic_opt function_range_or_type_opt function_identifier LPARENT function_port_list RPARENT SEMICOLON
	 block_item_declaration_list
	function_statement
	KEY_ENDFUNCTION
		{T_function_declaration_2($2,$3,$4,$6,$9,$10)}
;


function_item_declaration_list :
	{[]}
	| function_item_declaration function_item_declaration_list
		{$1::$2}
;

automatic_opt :
	{T_automatic_false}
	| KEY_AUTOMATIC {T_automatic_true}
;

function_range_or_type_opt :
	{T_function_range_or_type_NOSPEC}
	| function_range_or_type {$1}
;

function_item_declaration :
	block_item_declaration
		{T_function_item_declaration_block($1)}
	| attribute_instance_list tf_input_declaration SEMICOLON
		{T_function_item_declaration_input($1,$2)}
;

function_port_list :
	attribute_instance_list_tf_input_declaration 
	comma_attribute_instance_list_tf_input_declaration_list
		{$1::$2}
;

attribute_instance_list_tf_input_declaration :
	attribute_instance_list tf_input_declaration
		{T_attribute_instance_list_tf_input_declaration($1,$2)}
;

comma_attribute_instance_list_tf_input_declaration_list :
	{[]}
	| COMMA attribute_instance_list_tf_input_declaration comma_attribute_instance_list_tf_input_declaration_list
		{$2::$3}
;

function_range_or_type :
	{T_function_range_or_type_NOSPEC}
	|	KEY_SIGNED {T_function_range_or_type(T_signed_TRUE,T_range_NOSPEC)}
	| range				{T_function_range_or_type(T_signed_FALSE,$1)}
	|	KEY_SIGNED range {T_function_range_or_type(T_signed_TRUE,$2)}
	| KEY_INTEGER {T_function_range_or_type_INTEGER}
	| KEY_REAL				{T_function_range_or_type_REAL}
	| KEY_REALTIME		{T_function_range_or_type_REALTIME}
	| KEY_TIME				{T_function_range_or_type_TIME}
;



/*A.2.7 Task declarations*/

task_declaration :
	KEY_TASK automatic_opt task_identifier SEMICOLON
		task_item_declaration_list
		statement_or_null
		KEY_ENDTASK
		{T_task_declaration1($2,$3,$5,$6)}
	| KEY_TASK automatic_opt task_identifier LPARENT task_port_list  RPARENT SEMICOLON
		block_item_declaration_list
		statement_or_null
		KEY_ENDTASK
		{T_task_declaration2($2,$3,$5,$8,$9)}
;

task_item_declaration_list :
	{[]}
	| task_item_declaration task_item_declaration_list {$1::$2}
;

block_item_declaration_list :
	{[]}
	| block_item_declaration block_item_declaration_list
		{$1::$2}
;

task_item_declaration :
	block_item_declaration
		{T_task_item_declaration_block($1)}
	|  attribute_instance_list  tf_input_declaration SEMICOLON 
		{T_task_item_declaration_input($2)}
	|  attribute_instance_list  tf_output_declaration SEMICOLON
		{T_task_item_declaration_output($2)}
	|  attribute_instance_list  tf_inout_declaration SEMICOLON
		{T_task_item_declaration_inout($2)}
;

task_port_list :
	task_port_item comma_task_port_item_list
		{$1::$2}
;

comma_task_port_item_list :
	{[]}
	| COMMA task_port_item comma_task_port_item_list
		{$2::$3}
;

task_port_item :
		 attribute_instance_list tf_input_declaration
		 	{T_task_port_item_input($2)}
	|  attribute_instance_list tf_output_declaration
		 	{T_task_port_item_output($2)}
	|  attribute_instance_list tf_inout_declaration
		 	{T_task_port_item_inout($2)}
;


tf_input_declaration :
	KEY_INPUT reg_opt signed_opt range_opt list_of_port_identifiers
		{T_tf_input_declaration_reg($2,$3,$4,$5)}
	| KEY_INPUT task_port_type list_of_port_identifiers
		{T_tf_input_declaration_type($2,$3)}
;

reg_opt :
	{T_reg_false}
	| KEY_REG {T_reg_true}
;

tf_output_declaration :
	KEY_OUTPUT reg_opt signed_opt range_opt list_of_port_identifiers
		{T_tf_output_declaration_reg($2,$3,$4,$5)}
	| KEY_OUTPUT task_port_type list_of_port_identifiers
		{T_tf_output_declaration_type($2,$3)}
;

tf_inout_declaration :
	KEY_INOUT reg_opt signed_opt range_opt list_of_port_identifiers
		{T_tf_inout_declaration_reg($2,$3,$4,$5)}
	| KEY_INOUT task_port_type list_of_port_identifiers
		{T_tf_inout_declaration_type($2,$3)}
;

task_port_type :
	KEY_INTEGER			{T_task_port_type_integer}
	| KEY_REAL  		{T_task_port_type_real}
	| KEY_REALTIME	{T_task_port_type_realtime}
	| KEY_TIME			{T_task_port_type_time}
;


/*A.2.8 Block item declarations*/

block_item_declaration :
	 attribute_instance_list  KEY_REG signed_opt range_opt list_of_block_variable_identifiers SEMICOLON
	 	{T_block_item_declaration_reg($1,$3,$4,$5)}
|  attribute_instance_list  KEY_INTEGER list_of_block_variable_identifiers SEMICOLON
		{T_block_item_declaration_integer($1,$3)}
|  attribute_instance_list  KEY_TIME list_of_block_variable_identifiers SEMICOLON
		{T_block_item_declaration_time($1,$3)}
|  attribute_instance_list  KEY_REAL list_of_block_real_identifiers SEMICOLON
		{T_block_item_declaration_real($1,$3)}
|  attribute_instance_list  KEY_REALTIME list_of_block_real_identifiers SEMICOLON
		{T_block_item_declaration_realtime($1,$3)}
|  attribute_instance_list  event_declaration
		{T_block_item_declaration_event($1,$2)}
|  attribute_instance_list  local_parameter_declaration SEMICOLON
		{T_block_item_declaration_local_param($1,$2)}
|  attribute_instance_list  parameter_declaration SEMICOLON
		{T_block_item_declaration_param($1,$2)}
;

list_of_block_variable_identifiers : 
	block_variable_type comma_block_variable_type_list
		{$1::$2}
;

comma_block_variable_type_list :
	{[]}
	| COMMA block_variable_type comma_block_variable_type_list
		{$2::$3}
;

list_of_block_real_identifiers :
	block_real_type comma_block_real_type_list
		{$1::$2}
;

comma_block_real_type_list :
	{[]}
	| COMMA block_real_type comma_block_real_type_list
		{$2::$3}
;

block_variable_type :
	variable_identifier dimension_list
		{T_block_variable_type($1,$2)}
;

block_real_type :
	real_identifier dimension_list
		{T_block_real_type($1,$2)}
;


/*A.3 Primitive instances
A.3.1 Primitive instantiation and instances*/

gate_instantiation :
	cmos_switchtype delay3_opt cmos_switch_instance comma_cmos_switch_instance_list SEMICOLON
		{T_gate_instantiation_cmos($1,$2,$3::$4)}
	| enable_gatetype drive_strength_opt delay3_opt enable_gate_instance comma_enable_gate_instance_list SEMICOLON
		{T_gate_instantiation_enable($1,$2,$3,$4::$5)}
	| mos_switchtype delay3_opt mos_switch_instance comma_mos_switch_instance_list SEMICOLON
		{T_gate_instantiation_mos($1,$2,$3::$4)}
	| n_input_gatetype drive_strength_opt delay2_opt n_input_gate_instance comma_n_input_gate_instance_list SEMICOLON
		{T_gate_instantiation_input($1,$2,$3,$4::$5)}
	| n_output_gatetype drive_strength_opt delay2_opt n_output_gate_instance comma_n_output_gate_instance_list SEMICOLON
		{T_gate_instantiation_output($1,$2,$3,$4::$5)}
	| pass_en_switchtype delay2_opt pass_enable_switch_instance comma_pass_enable_switch_instance_list SEMICOLON
		{T_gate_instantiation_pass_en($1,$2,$3::$4)}
	| pass_switchtype pass_switch_instance comma_pass_switch_instance_list SEMICOLON
		{T_gate_instantiation_pass($1,$2::$3)}
	| KEY_PULLDOWN pulldown_strength_opt pull_gate_instance comma_pull_gate_instance_list SEMICOLON
		{T_gate_instantiation_pulldown($2,$3::$4)}
	| KEY_PULLUP pullup_strength_opt pull_gate_instance comma_pull_gate_instance_list SEMICOLON
		{T_gate_instantiation_pullup($2,$3::$4)}
;

comma_n_output_gate_instance_list :
	{[]}
	| COMMA n_output_gate_instance comma_n_output_gate_instance_list
		{$2::$3}
;

comma_pass_enable_switch_instance_list :
	{[]}
	| COMMA pass_enable_switch_instance comma_pass_enable_switch_instance_list
		{$2::$3}
;

comma_pass_switch_instance_list :
	{[]}
	| COMMA pass_switch_instance comma_pass_switch_instance_list
		{$2::$3}
;

comma_pull_gate_instance_list :
	{[]}
	| COMMA pull_gate_instance comma_pull_gate_instance_list
		{$2::$3}
;

comma_cmos_switch_instance_list :
	{[]}
	| COMMA cmos_switch_instance comma_cmos_switch_instance_list
		{$2::$3}
;

comma_enable_gate_instance_list :
	{[]}
	| COMMA enable_gate_instance comma_enable_gate_instance_list 
		{$2::$3}
;

comma_mos_switch_instance_list :
	{[]}
	| COMMA mos_switch_instance comma_mos_switch_instance_list
		{$2::$3}
;

comma_n_input_gate_instance_list :
	{[]}
	| COMMA n_input_gate_instance comma_n_input_gate_instance_list 
		{$2::$3}
;


delay2_opt :
	{T_delay2_NOSPEC}
	| delay2 {$1}
;

pulldown_strength_opt :
	{T_pulldown_strength_NOSPEC}
	| pulldown_strength {$1}
;

pullup_strength_opt :
	{T_pullup_strength_NOSPEC}
	| pullup_strength {$1}
;

cmos_switch_instance :
	name_of_gate_instance_opt LPARENT output_terminal COMMA input_terminal COMMA ncontrol_terminal COMMA pcontrol_terminal RPARENT
		{T_cmos_switch_instance($1,$3,$5,$7,$9)}
;


name_of_gate_instance_opt :
	{T_name_of_gate_instance_NOSPEC}
	| name_of_gate_instance {$1}
;

enable_gate_instance :
	name_of_gate_instance_opt LPARENT output_terminal COMMA input_terminal COMMA enable_terminal RPARENT
		{T_enable_gate_instance($1,$3,$5,$7)}
;

mos_switch_instance : 
	name_of_gate_instance_opt LPARENT output_terminal COMMA input_terminal COMMA enable_terminal RPARENT
		{T_mos_switch_instance($1,$3,$5,$7)}
;

n_input_gate_instance : 
	name_of_gate_instance_opt LPARENT output_terminal COMMA input_terminal comma_input_terminal_list RPARENT
		{T_n_input_gate_instance($1,$3,$5,$6)}
;

n_output_gate_instance :
	name_of_gate_instance_opt LPARENT output_terminal comma_output_terminal_list COMMA input_terminal RPARENT
		{T_n_output_gate_instance($1,$3,$4,$6)}
;

comma_output_terminal_list :
	{[]}
	| COMMA output_terminal comma_output_terminal_list
		{$2::$3}
;

pass_switch_instance :
	name_of_gate_instance_opt LPARENT inout_terminal COMMA inout_terminal RPARENT
		{T_pass_switch_instance($1,$3,$5)}
;

pass_enable_switch_instance :
	name_of_gate_instance_opt LPARENT inout_terminal COMMA inout_terminal COMMA enable_terminal RPARENT
		{T_pass_enable_switch_instance($1,$3,$5,$7)}
;


pull_gate_instance :
	name_of_gate_instance_opt LPARENT output_terminal RPARENT
		{T_pull_gate_instance($1,$3)}
;

name_of_gate_instance :
	gate_instance_identifier LSQUARE range RSQUARE
		{T_name_of_gate_instance($1,$3)}
;

/*A.3.2 Primitive strengths*/

pulldown_strength :
	LPARENT strength0 COMMA strength1 RPARENT
		{T_pulldown_strength01($2,$4)}
	| LPARENT strength1 COMMA strength0 RPARENT
		{T_pulldown_strength10($2,$4)}
	| LPARENT strength0 RPARENT
		{T_pulldown_strength0($2)}
;

pullup_strength :
	LPARENT strength0 COMMA strength1 RPARENT
		{T_pullup_strength01($2,$4)}
	| LPARENT strength1 COMMA strength0 RPARENT
		{T_pullup_strength10($2,$4)}
	| LPARENT strength1 RPARENT
		{T_pullup_strength1($2)}
;


/*A.3.3 Primitive terminals*/
enable_terminal : expression {$1} ;
inout_terminal : net_lvalue {$1} ;
input_terminal : expression {$1} ;
ncontrol_terminal : expression {$1} ;
output_terminal : net_lvalue {$1} ;
pcontrol_terminal : expression {$1};



/*A.3.4 Primitive gate and switch types*/

cmos_switchtype :
	KEY_CMOS   {T_cmos_switchtype_CMOS}
	| KEY_RCMOS {T_cmos_switchtype_RCMOS}
;

enable_gatetype :
		KEY_BUFIF0 	{T_enable_gatetype__BUFIF0}
	| KEY_BUFIF1 	{T_enable_gatetype__BUFIF1}
	| KEY_NOTIF0 	{T_enable_gatetype__NOTIF0}
	| KEY_NOTIF1	{T_enable_gatetype__NOTIF1}
;

mos_switchtype : 
		KEY_NMOS 	{T_mos_switchtype_NMOS }	
	| KEY_PMOS 	{T_mos_switchtype_PMOS }
	| KEY_RNMOS	{T_mos_switchtype_RNMOS} 
	| KEY_RPMOS	{T_mos_switchtype_RPMOS}
;

n_input_gatetype :
   	KEY_AND  {T_n_input_gatetype_AND }  
	| KEY_NAND {T_n_input_gatetype_NAND}
	| KEY_OR 	 {T_n_input_gatetype_OR 	}
	| KEY_NOR  {T_n_input_gatetype_NOR }
	| KEY_XOR  {T_n_input_gatetype_XOR }
	| KEY_XNOR {T_n_input_gatetype_XNOR} 
;

n_output_gatetype :
	KEY_BUF  {T_n_output_gatetype_BUF}
	| KEY_NOT {T_n_output_gatetype_NOT}
;

pass_en_switchtype :
	  KEY_TRANIF0 {T_pass_en_switchtype_TRANIF0 } 
	| KEY_TRANIF1 {T_pass_en_switchtype_TRANIF1 }   
	| KEY_RTRANIF1{T_pass_en_switchtype_RTRANIF1}  
	| KEY_RTRANIF0{T_pass_en_switchtype_RTRANIF0} 
;
pass_switchtype :
	  KEY_TRAN  {T_pass_switchtype_TRAN } 
	| KEY_RTRAN {T_pass_switchtype_RTRAN} 
;



/*A.4 Module instantiation and generate construct
A.4.1 Module instantiation*/

module_instantiation :
	module_identifier parameter_value_assignment_opt module_instance comma_module_instance_list SEMICOLON
		{T_module_instantiation($1,$2,$3::$4)}
;

comma_module_instance_list :
	{[]}
	| COMMA module_instance  comma_module_instance_list
		{$2::$3}
;

parameter_value_assignment_opt :
	{T_parameter_value_assignment_NOSPEC}
	| parameter_value_assignment {$1}
;

parameter_value_assignment :
	JING LPARENT list_of_parameter_assignments RPARENT
		{$3}
;

list_of_parameter_assignments :
	ordered_parameter_assignment comma_ordered_parameter_assignment_list
		{T_parameter_value_assignment_order($1::$2)} 
	| named_parameter_assignment comma_named_parameter_assignment_list
		{T_parameter_value_assignment_named($1::$2)}
;

comma_ordered_parameter_assignment_list :
	{[]}
	| COMMA ordered_parameter_assignment comma_ordered_parameter_assignment_list
		{$2::$3}
;

comma_named_parameter_assignment_list :
	{[]}
	| COMMA named_parameter_assignment comma_named_parameter_assignment_list 
		{$2::$3}
;

ordered_parameter_assignment :
	expression {$1}
;

named_parameter_assignment :
	PERIOD parameter_identifier LPARENT mintypmax_expression_opt RPARENT
		{T_named_parameter_assignment($2,$4)}
;

mintypmax_expression_opt :
	{T_mintypmax_expression_NOSPEC}
	| mintypmax_expression {$1}
;

module_instance :
	name_of_module_instance LPARENT list_of_port_connections_opt RPARENT
		{T_module_instance($1,$3)}
;

list_of_port_connections_opt :
	{T_list_of_port_connections_NOSPEC}
	| list_of_port_connections {$1}
;

name_of_module_instance :
	module_instance_identifier range_opt
		{T_name_of_module_instance($1,$2)}
;

list_of_port_connections :
	ordered_port_connection comma_ordered_port_connection_list
		{T_list_of_port_connections_ordered($1::$2)}
	| named_port_connection comma_named_port_connection_list
		{T_list_of_port_connections_named($1::$2)}
;

comma_ordered_port_connection_list :
	{[]}
	| COMMA ordered_port_connection comma_ordered_port_connection_list
		{$2::$3}
;

comma_named_port_connection_list :
	{[]}
	| COMMA named_port_connection comma_named_port_connection_list
		{$2::$3}
;

ordered_port_connection :
	attribute_instance_list expression_opt
		{T_ordered_port_connection($1,$2)}
;

expression_opt :
	{T_expression_NOSPEC}
	| expression {$1}
;

named_port_connection :
	attribute_instance_list PERIOD port_identifier LPARENT expression_opt RPARENT
		{T_named_port_connection($1,$3,$5)}
;


/*A.4.2 Generate construct*/
generate_region :
	KEY_GENERATE module_or_generate_item_list KEY_ENDGENERATE
		{T_generate_region($2)}
;

module_or_generate_item_list :
	{[]}
	| module_or_generate_item module_or_generate_item_list {$1::$2}
;

genvar_declaration :
	KEY_GENVAR list_of_genvar_identifiers SEMICOLON
		{T_genvar_declaration($2)}
;

list_of_genvar_identifiers :
	genvar_identifier comma_genvar_identifier_list
		{$1::$2}
;

comma_genvar_identifier_list :
	{[]}
	| COMMA genvar_identifier comma_genvar_identifier_list 
		{$2::$3}
;

loop_generate_construct :
	KEY_FOR LPARENT genvar_initialization SEMICOLON expression SEMICOLON genvar_iteration RPARENT generate_block
		{T_loop_generate_construct($3,$5,$7,$9)}
;

genvar_initialization :
	genvar_identifier EQU1 expression
		{T_genvar_initialization($1,$3)}
;


genvar_iteration :
	genvar_identifier EQU1 expression
		{T_genvar_iteration($1,$3)}
;



conditional_generate_construct :
	if_generate_construct
		{T_conditional_generate_construct_if($1)}
	| case_generate_construct
		{T_conditional_generate_construct_case($1)}
;


if_generate_construct :
	KEY_IF LPARENT expression RPARENT generate_block_or_null
	else_generate_block_or_null_opt
		{T_if_generate_construct($3,$5,$6)}
;

else_generate_block_or_null_opt :
	{T_generate_block_NOSPEC}
	| KEY_ELSE generate_block_or_null
		{$2}
;


case_generate_construct :
	KEY_CASE LPARENT expression RPARENT
	case_generate_item case_generate_item_list KEY_ENDCASE
		{T_case_generate_construct($3,$5::$6)}
;

case_generate_item_list :
	{[]}
	| case_generate_item case_generate_item_list
		{$1::$2}
;

case_generate_item :
	expression comma_expression_list COLON generate_block_or_null
		{T_case_generate_item_case($1::$2,$4)}
	| KEY_DEFAULT colon_opt  generate_block_or_null
		{T_case_generate_item_default($3)}
;

colon_opt :
	{0}
	| COLON {0}
;

generate_block :
	module_or_generate_item
		{T_generate_block_mgi($1)}
	| KEY_BEGIN colon_generate_block_identifier_opt module_or_generate_item_list KEY_END
		{T_generate_block_begin($2,$3)}
;

colon_generate_block_identifier_opt :
	{T_identifier_NOSPEC}
	| COLON generate_block_identifier
		{$2}
;

generate_block_or_null :
	generate_block
		{$1}
	| SEMICOLON
		{T_generate_block_NOSPEC}
;


/*A.5 UDP declaration and instantiation
A.5.1 UDP declaration*/

udp_declaration :
	attribute_instance_list KEY_PRIMITIVE udp_identifier LPARENT udp_port_list RPARENT SEMICOLON
	udp_port_declaration udp_port_declaration_list
	udp_body
	KEY_ENDPRIMITIVE
		{T_udp_declaration_1($1,$3,$5,$8::$9,$10)}
| attribute_instance_list KEY_PRIMITIVE udp_identifier LPARENT udp_declaration_port_list RPARENT SEMICOLON
	udp_body
	KEY_ENDPRIMITIVE
		{T_udp_declaration_2($1,$3,$5,$8)}
;


udp_port_declaration_list :
	{[]}
	| udp_port_declaration udp_port_declaration_list
		{$1::$2}
;

/*A.5.2 UDP ports*/

udp_port_list :
	output_port_identifier COMMA input_port_identifier comma_input_port_identifier_list
		{T_udp_port_list($1,$3::$4)}
;

comma_input_port_identifier_list :
	{[]}
	| COMMA input_port_identifier comma_input_port_identifier_list
		{$2::$3}
;

udp_declaration_port_list :
	udp_output_declaration COMMA udp_input_declaration comma_udp_input_declaration_list
		{T_udp_declaration_port_list($1,$3::$4)}
;

comma_udp_input_declaration_list :
	{[]}
	| COMMA udp_input_declaration comma_udp_input_declaration_list
		{$2::$3}
;


udp_port_declaration :
	udp_output_declaration SEMICOLON
		{T_udp_port_declaration_out($1)}
	| udp_input_declaration SEMICOLON
		{T_udp_port_declaration_input($1)}
	| udp_reg_declaration SEMICOLON
		{T_udp_port_declaration_reg($1)}
;

udp_output_declaration :
	attribute_instance_list KEY_OUTPUT port_identifier
		{T_udp_output_declaration_output($1,$3)}
	| attribute_instance_list KEY_OUTPUT KEY_REG port_identifier equ1_expression_opt
		{T_udp_output_declaration_reg($1,$4,$5)}
;

udp_input_declaration : 
	attribute_instance_list KEY_INPUT list_of_port_identifiers
		{T_udp_input_declaration($1,$3)}
;

udp_reg_declaration :
	attribute_instance_list  KEY_REG variable_identifier
		{T_udp_reg_declaration($1,$3)}
;

/*A.5.3 UDP body*/

udp_body : 
	combinational_body 
		{T_udp_body_comb($1)}
	| sequential_body
		{T_udp_body_seq($1)}
;


combinational_body :
	KEY_TABLE combinational_entry combinational_entry_list KEY_ENDTABLE
		{$2::$3}
;

combinational_entry_list :
	{[]}
	| combinational_entry combinational_entry_list
		{$1::$2}
;

combinational_entry :
	level_input_list COLON output_symbol SEMICOLON
		{T_combinational_entry($1,$3)}
;

sequential_body :
	udp_initial_statement_opt KEY_TABLE sequential_entry sequential_entry_list KEY_ENDTABLE
		{T_sequential_body($1,$3::$4)}
;

udp_initial_statement_opt :
	{T_udp_initial_statement_NOSPEC}
	| udp_initial_statement
		{$1}
;


sequential_entry_list :
	{[]}
	| sequential_entry sequential_entry_list
		{$1::$2}
;

udp_initial_statement :
	KEY_INITIAL output_port_identifier EQU1 init_val SEMICOLON
		{T_udp_initial_statement($2,$4)}
;



/*init_val ::= 1'b0 | 1'b1 | 1'bx | 1'bX | 1'B0 | 1'B1 | 1'Bx | 1'BX | 1 | 0*/
/*actually lex only return number*/
init_val :
	BINARY_NUMBER  
		{T_init_val_bin(get1 $1, get2 $1, get3 $1)}
	| UNSIGNED_NUMBER
		{T_init_val_unsigned(get1 $1, get2 $1, get3 $1)}
;

sequential_entry :
	seq_input_list COLON current_state COLON next_state SEMICOLON
		{T_sequential_entry($1,$3,$5)}
;

seq_input_list :
	level_input_list 
		{T_seq_input_list_level($1)}
	| edge_input_list
		{T_seq_input_list_edge($1)}
;

level_input_list :
	level_symbol level_symbol_list
		{$1::$2}
;

level_symbol_list :
	{[]}
	| level_symbol level_symbol_list
		{$1::$2}
;

edge_input_list :
	level_symbol_list edge_indicator level_symbol_list
		{T_edge_input_list($1,$2,$3)}
;

edge_indicator :
	LPARENT level_symbol level_symbol RPARENT 
		{T_edge_indicator_level($2,$3)}
	| edge_symbol
		{T_edge_indicator_edge($1)}
;

/*current_state : level_symbol
next_state ::= output_symbol | -
output_symbol ::= 0 | 1 | x | X
level_symbol ::= 0 | 1 | x | X | ? | b | B
edge_symbol ::= r | R | f | F | p | P | n | N | *
*/
/*lexer only return UNSIGNED_NUMBER, SIMPLE_IDENTIFIER and * and -*/

edge_symbol :
	SIMPLE_IDENTIFIER	{T_edge_symbol_SIMID(get1 $1, get2 $1, get3 $1)}
	| OP2_MULTIPLE	{T_edge_symbol_MUL(get1 $1, get2 $1)}
;

level_symbol :
	UNSIGNED_NUMBER 
	 {T_level_symbol_UNSIGNED_NUMBER(get1 $1, get2 $1, get3 $1)}
	| SIMPLE_IDENTIFIER  {T_level_symbol_SIMID(get1 $1, get2 $1, get3 $1)}
	| OP2_QUESTION {T_level_symbol_QUESTION(get1 $1, get2 $1)}
;

output_symbol :
	UNSIGNED_NUMBER 
	 {T_output_symbol_UNSIGNED_NUMBER(get1 $1, get2 $1, get3 $1)}
	| SIMPLE_IDENTIFIER  {T_output_symbol_SIMID(get1 $1, get2 $1, get3 $1)}
;

next_state :
	UNSIGNED_NUMBER 
	 {T_next_state_UNSIGNED_NUMBER(get1 $1, get2 $1, get3 $1)}
	| SIMPLE_IDENTIFIER  {T_next_state_SIMID(get1 $1, get2 $1, get3 $1)}
	| OP2_SUB  {T_next_state_SUB(get1 $1, get2 $1)}
;

current_state :
	UNSIGNED_NUMBER 
	 {T_current_state_UNSIGNED_NUMBER(get1 $1, get2 $1, get3 $1)}
	| SIMPLE_IDENTIFIER  
		{T_current_state_SIMID(get1 $1, get2 $1, get3 $1)}
	| OP2_QUESTION 
		{T_current_state_OP2_QUESTION(get1 $1, get2 $1)}
;
	




/*A.5.4 UDP instantiation*/
udp_instantiation :
	udp_identifier drive_strength_opt delay2_opt
		udp_instance comma_udp_instance_list  ;
		{T_udp_instantiation($1,$2,$3,$4::$5)}
;

comma_udp_instance_list :
	{[]}
	| COMMA udp_instance comma_udp_instance_list
		{$2::$3}
;

udp_instance :
	name_of_udp_instance_opt LPARENT output_terminal COMMA input_terminal comma_input_terminal_list RPARENT
	{T_udp_instance($1,$3,$5::$6)}
;

name_of_udp_instance_opt :
	{T_name_of_udp_instance_NOSPEC}
	| name_of_udp_instance
			{$1}
;

comma_input_terminal_list :
	{[]}
	| COMMA input_terminal comma_input_terminal_list
		{$2::$3}
;

name_of_udp_instance :
	udp_instance_identifier range_opt
		{T_name_of_udp_instance($1,$2)}
;

/*A.6 Behavioral statements
A.6.1 Continuous assignment statements*/


continuous_assign :
	KEY_ASSIGN drive_strength_opt delay3_opt list_of_net_assignments SEMICOLON
		{T_continuous_assign($2,$3,$4)}
;

list_of_net_assignments :
	net_assignment comma_net_assignment_list
		{$1::$2}
;

comma_net_assignment_list :
	{[]}
	| COMMA net_assignment comma_net_assignment_list
		{$2::$3}
;


net_assignment :
	net_lvalue EQU1 expression
		{T_net_assignment($1,$3)}
;

/*A.6.2 Procedural blocks and assignments*/

initial_construct :
	KEY_INITIAL statement
		{T_initial_construct($2)}
;

always_construct :
	KEY_ALWAYS statement
		{T_always_construct($2)}
;

blocking_assignment :
	variable_lvalue EQU1 delay_or_event_control_opt expression
		{T_blocking_assignment($1,$3,$4)}
;

delay_or_event_control_opt :
	{T_delay_or_event_control_NOSPEC}
	| delay_or_event_control
		{$1}
;

nonblocking_assignment :
	variable_lvalue OP2_LE delay_or_event_control_opt expression
		{T_nonblocking_assignment($1,$3,$4)}
;

procedural_continuous_assignments :
	KEY_ASSIGN variable_assignment
		{T_procedural_continuous_assignments_assign($2)}
	| KEY_DEASSIGN variable_lvalue
		{T_procedural_continuous_assignments_deassign($2)}
	| KEY_FORCE variable_assignment
		{T_procedural_continuous_assignments_force1($2)}
	| KEY_FORCE net_assignment
		{T_procedural_continuous_assignments_force2($2)}
	| KEY_RELEASE variable_lvalue
		{T_procedural_continuous_assignments_release1($2)}
	| KEY_RELEASE net_lvalue
		{T_procedural_continuous_assignments_release2($2)}
;

variable_assignment :
	variable_lvalue EQU1 expression
		{T_variable_assignment($1,$3)}
;


/*A.6.3 Parallel and sequential blocks*/

par_block :
	KEY_FORK comma_block_identifier_block_item_declaration_list_opt
	statement_list
	KEY_JOIN
		{T_par_block($3)}
;

comma_block_identifier_block_item_declaration_list_opt :
	{0}
	| COMMA block_identifier block_item_declaration_list
		{0}
;

statement_list :
	{[]}
	| statement statement_list
		{$1::$2}
;

seq_block :
	KEY_BEGIN comma_block_identifier_block_item_declaration_list_opt 
	statement_list
	KEY_END
		{T_seq_block($3)}
;

/*A.6.4 Statements*/

statement :
		attribute_instance_list blocking_assignment SEMICOLON
			{T_statement_blocking_assignment($1,$2)}
	| attribute_instance_list case_statement
			{T_statement_case_statement($1,$2)}
	| attribute_instance_list conditional_statement
			{T_statement_conditional_statement($1,$2)}
	| attribute_instance_list disable_statement
			{T_statement_disable_statement($1,$2)}
	| attribute_instance_list event_trigger
			{T_statement_event_trigger($1,$2)}
	| attribute_instance_list loop_statement
			{T_statement_loop_statement($1,$2)}
	| attribute_instance_list nonblocking_assignment SEMICOLON
			{T_statement_nonblocking_assignment($1,$2)}
	| attribute_instance_list par_block
			{T_statement_par_block($1,$2)}
	| attribute_instance_list procedural_continuous_assignments SEMICOLON
			{T_statement_procedural_continuous_assignments($1,$2)}
	| attribute_instance_list procedural_timing_control_statement
			{T_statement_procedural_timing_control_statement($1,$2)}
	| attribute_instance_list seq_block
			{T_statement_seq_block($1,$2)}
	| attribute_instance_list system_task_enable
			{T_statement_system_task_enable($1,$2)}
	| attribute_instance_list task_enable
			{T_statement_task_enable($1,$2)}
	| attribute_instance_list wait_statement
			{T_statement_wait_statement($1,$2)}



statement_or_null :
	statement
		{$1}
	| attribute_instance_list SEMICOLON
		{T_statement_NOSPEC}
;

function_statement :
	statement
		{$1}
;

/*A.6.5 Timing control statements*/

delay_control :
	JING delay_value
		{T_delay_control_delay_value($2)}
	| JING LPARENT mintypmax_expression RPARENT
		{T_delay_control_mintypmax_expression($3)}
;

delay_or_event_control :
	delay_control
		{T_delay_or_event_control_delay_control($1)}
	| event_control
		{T_delay_or_event_control_event_control($1)}
	| KEY_REPEAT LPARENT expression RPARENT event_control
		{T_delay_or_event_control_3($3,$5)}
;


disable_statement :
	KEY_DISABLE hierarchical_task_identifier SEMICOLON
		{T_disable_statement_task($2)}
	| KEY_DISABLE hierarchical_block_identifier SEMICOLON
		{T_disable_statement_block($2)}
;


event_control :
	AT hierarchical_event_identifier
		{T_event_control_eventid($2)}
	| AT LPARENT event_expression RPARENT
		{T_event_control_event_exp($3)}
	| AT OP2_MULTIPLE
		{T_event_control_start}
	| AT LPARENT OP2_MULTIPLE RPARENT
		{T_event_control_start}
;

event_trigger :
	IMPLY hierarchical_event_identifier square_expression_square_list SEMICOLON
		{T_event_trigger($2,$3)}
;

square_expression_square_list :
	{[]}
	| square_expression_square_list square_expression_square 
		{$1@[$2]}
;

square_expression_square :
	LSQUARE expression RSQUARE
		{$2}
;

event_expression :
	expression
		{T_event_expression_exp($1)}
	| KEY_POSEDGE expression
		{T_event_expression_pos($2)}
	| KEY_NEGEDGE expression
		{T_event_expression_neg($2)}
	| event_expression KEY_OR event_expression
		{T_event_expression_or($1,$3)}
	| event_expression COMMA event_expression
		{T_event_expression_or($1,$3)}
;


procedural_timing_control :
	delay_control
		{T_procedural_timing_control_delay($1)}
	| event_control
		{T_procedural_timing_control_event($1)}
;


procedural_timing_control_statement :
	procedural_timing_control statement_or_null
		{T_procedural_timing_control_statement($1,$2)}
;

wait_statement :
	KEY_WAIT LPARENT expression RPARENT statement_or_null
		{T_wait_statement($3,$5)}
;

/*A.6.6 Conditional statements*/
conditional_statement :
	KEY_IF LPARENT expression RPARENT
	statement_or_null else_statement_or_null_opt
		{T_conditional_statement_ifelse($3,$5,$6)}
/*	| KEY_IF LPARENT expression RPARENT statement_or_null
		else_if_lp_expression_rp_statement_or_null_list
		else_statement_or_null_opt
		{T_conditional_statement_ifelseif($3,$5,$6,$7)}*/
;

else_statement_or_null_opt :
	{T_statement_NOSPEC}
	| KEY_ELSE statement_or_null
		{$2}
;


else_if_lp_expression_rp_statement_or_null_list :
	{[]}
	| else_if_lp_expression_rp_statement_or_null else_if_lp_expression_rp_statement_or_null_list
		{$1::$2}
;


else_if_lp_expression_rp_statement_or_null :
	KEY_ELSE KEY_IF LPARENT expression RPARENT statement_or_null
		{T_elseif($4,$6)}
;




/*A.6.7 Case statements*/
case_statement :
	KEY_CASE LPARENT expression RPARENT
	case_item case_item_list
	KEY_ENDCASE
			{T_case_statement_case($3,$5::$6)}
	| KEY_CASEZ LPARENT expression RPARENT
		case_item case_item_list
		KEY_ENDCASE
			{T_case_statement_casez($3,$5::$6)}
	| KEY_CASEX LPARENT expression RPARENT
		case_item case_item_list
		KEY_ENDCASE
			{T_case_statement_casex($3,$5::$6)}
;

case_item_list :
	{[]}
	| case_item case_item_list
			{$1::$2}
;

case_item :
	expression comma_expression_list COLON statement_or_null
		{T_case_item($1::$2,$4)}
	| KEY_DEFAULT colon_opt statement_or_null
		{T_case_item_default($3)}
;


comma_expression_list :
	{[]}
	| COMMA expression comma_expression_list
			{$2::$3}
;

/*A.6.8 Looping statements*/
loop_statement :
	KEY_FOREVER statement
		{T_loop_statement_forever($2)}
	| KEY_REPEAT LPARENT expression RPARENT statement
		{T_loop_statement_repeat($3,$5)}
	| KEY_WHILE LPARENT expression RPARENT statement
		{T_loop_statement_while($3,$5)}
	| KEY_FOR LPARENT variable_assignment SEMICOLON expression SEMICOLON variable_assignment RPARENT statement
		{T_loop_statement_for($3,$5,$7,$9)}
;




/*A.6.9 Task enable statements*/
system_task_enable :
	system_function_identifier lp_expression_opt_comma_expression_list_rp_opt SEMICOLON
		{T_system_task_enable($1,$2)}
;

lp_expression_opt_comma_expression_list_rp_opt :
	{[]}
	| lp_expression_opt_comma_expression_list_rp {$1}
;


lp_expression_opt_comma_expression_list_rp :
	LPARENT expression comma_expression_list RPARENT
		{$2::$3}
;


task_enable :
	hierarchical_task_identifier lp_expression_opt_comma_expression_list_rp_opt SEMICOLON
		{T_task_enable($1,$2)}
;



/*A.7 Specify section
A.7.1 Specify block declaration*/
/*specify_block :
	KEY_SPECIFY specify_item_list KEY_ENDSPECIFY
		{T_specify_block($2)}
;

specify_item_list :
	{[]}
	| specify_item specify_item_list
		{$1::$2}
;


specify_item :
	specparam_declaration
		{T_specify_item_specparam($1)}
	| pulsestyle_declaration
		{T_specify_item_pulsestyle($1)}
	| showcancelled_declaration
		{T_specify_item_showcancelled($1)}
	| path_declaration
		{T_specify_item_path($1)}
	| system_timing_check
		{T_specify_item_system($1)}
;


pulsestyle_declaration :
	KEY_PULSESTYLE_ONEVENT list_of_path_outputs SEMICOLON
		{T_pulsestyle_declaration_oneevent($2)}
	| KEY_PULSESTYLE_ONDETECT list_of_path_outputs SEMICOLON
		{T_pulsestyle_declaration_onedetect($2)}
;



showcancelled_declaration :
	KEY_SHOWCANCELLED list_of_path_outputs SEMICOLON
		{T_showcancelled_declaration_show($2)}
	| KEY_NOSHOWCANCELLED list_of_path_outputs SEMICOLON
		{T_showcancelled_declaration_noshow($2)}
;


*/
/*A.7.2 Specify path declarations*/
/*path_declaration :
	simple_path_declaration SEMICOLON
		{T_path_declaration_simple($1)}
	| edge_sensitive_path_declaration SEMICOLON
		{T_path_declaration_edge($1)}
	| state_dependent_path_declaration SEMICOLON
		{T_path_declaration_state($1)}
;


simple_path_declaration :
	parallel_path_description EQU1 path_delay_value
		{T_simple_path_declaration_parallel($1,$3)}
	| full_path_description EQU1 path_delay_value
		{T_simple_path_declaration_full($1,$3)}
;



parallel_path_description :
	LPARENT specify_input_terminal_descriptor polarity_operator_opt IMPLY2 specify_output_terminal_descriptor RPARENT
		{T_parallel_path_description($2,$3,$5)}
;

polarity_operator_opt :
	{T_polarity_operator_NOSPEC}
	| polarity_operator {$1}
;

full_path_description :
	LPARENT list_of_path_inputs  polarity_operator_opt IMPLYSTART list_of_path_outputs RPARENT
		{T_full_path_description($2,$3,$5)}
;


list_of_path_inputs :
	specify_input_terminal_descriptor comma_specify_input_terminal_descriptor_list
		{$1::$2}
;

comma_specify_input_terminal_descriptor_list :
	{[]}
	| COMMA specify_input_terminal_descriptor comma_specify_input_terminal_descriptor_list
		{$2::$3}
;


list_of_path_outputs :
	specify_output_terminal_descriptor comma_specify_output_terminal_descriptor_list
		{$1::$2}
;

comma_specify_output_terminal_descriptor_list :
	{[]}
	| COMMA specify_output_terminal_descriptor comma_specify_output_terminal_descriptor_list
		{$2::$3}
;

*/
/*A.7.3 Specify block terminals*/
/*specify_input_terminal_descriptor :
	input_identifier rsq_range_expression_rsq_opt
		{T_specify_input_terminal_descriptor($1,$2)}
;

rsq_range_expression_rsq_opt	:
	{T_range_expression_NOSPEC}
	| LSQUARE range_expression RSQUARE
		{$2}
;

specify_output_terminal_descriptor :
	output_identifier rsq_range_expression_rsq_opt
		{T_specify_output_terminal_descriptor($1,$2)}
;

input_identifier :
	identifier {$1}
;



output_identifier :
	identifier {$1}
;

*/
/*A.7.4 Specify path delays*/
/*path_delay_value :
	list_of_path_delay_expressions
		{$1}
	| LPARENT list_of_path_delay_expressions RPARENT
		{$2}
;



list_of_path_delay_expressions :
	mintypmax_expression
		{T_list_of_mintypmax_expressions_1($1)}
	| mintypmax_expression COMMA mintypmax_expression
		{T_list_of_mintypmax_expressions_2($1,$3)}
	| mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression
		{T_list_of_mintypmax_expressions_3($1,$3,$5)}
	| mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression COMMA	mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression
		{T_list_of_mintypmax_expressions_6($1,$3,$5,$7,$9,$11)}
	| mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression COMMA	mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression COMMA 	mintypmax_expression COMMA mintypmax_expression COMMA mintypmax_expression
		{T_list_of_mintypmax_expressions_12($1,$3,$5,$7,$9,$11,$13,$15,$17,$19,$21,$23)}
;

edge_sensitive_path_declaration :
	parallel_edge_sensitive_path_description EQU1 path_delay_value
		{T_edge_sensitive_path_declaration_parallel($1,$3)}
	| full_edge_sensitive_path_description EQU1 path_delay_value
		{T_edge_sensitive_path_declaration_full($1,$3)}
;


parallel_edge_sensitive_path_description :
LPARENT edge_identifier_opt  specify_input_terminal_descriptor IMPLY2
LPARENT specify_output_terminal_descriptor polarity_operator_opt COLON data_source_expression RPARENT RPARENT
		{T_parallel_edge_sensitive_path_description($2,$3,$6,$7,$9)}
;

edge_identifier_opt :
	{T_edge_identifier_NOSPEC}
	| edge_identifier {$1}
;

full_edge_sensitive_path_description :
	LPARENT edge_identifier_opt list_of_path_inputs IMPLYSTART
LPARENT list_of_path_outputs polarity_operator_opt COLON data_source_expression RPARENT RPARENT
		{T_full_edge_sensitive_path_description($2,$3,$6,$7,$9)}
;

data_source_expression :
	expression
	{$1}
;


edge_identifier :
	KEY_POSEDGE  {T_edge_identifier_POS}
	| KEY_NEGEDGE {T_edge_identifier_NEG}
;


state_dependent_path_declaration :
	KEY_IF LPARENT module_path_expression RPARENT simple_path_declaration
		{T_state_dependent_path_declaration_simple($3,$5)}
	| KEY_IF LPARENT module_path_expression RPARENT edge_sensitive_path_declaration
		{T_state_dependent_path_declaration_edge($3,$5)}
	| KEY_IFNONE simple_path_declaration
		{T_state_dependent_path_declaration_ifnone($2)}
;


polarity_operator :
	OP2_ADD  {T_polarity_operator_ADD}
	| OP2_SUB {T_polarity_operator_SUB}
;

*/
/*A.7.5 System timing checks
A.7.5.1 System timing check commands*/
/* no time to do*/
/*system_timing_check :
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
*/

/*A.7.5.2 System timing check command arguments*/
/*
checktime_condition ::= mintypmax_expression
controlled_reference_event ::= controlled_timing_check_event
data_event ::= timing_check_event
delayed_data ::=
terminal_identifier
| terminal_identifier [ mintypmax_expression ]
delayed_reference ::=
terminal_identifier
| terminal_identifier [ mintypmax_expression ]
end_edge_offset ::= mintypmax_expression
event_based_flag ::= expression
notifier ::= variable_identifier
reference_event ::= timing_check_event
remain_active_flag ::= expression
stamptime_condition ::= mintypmax_expression
start_edge_offset ::= mintypmax_expression
threshold ::= expression
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
scalar_timing_check_condition ::=
expression
| ~ expression
| expression == scalar_constant
| expression === scalar_constant
| expression != scalar_constant
| expression !== scalar_constant
scalar_constant ::=
1'b0 | 1'b1 | 1'B0 | 1'B1 | 'b0 | 'b1 | 'B0 | 'B1 | 1 | 0


*/



/*A.8 Expressions
A.8.1 Concatenations*/
concatenation :
	LHUA expression comma_expression_list RHUA
		{T_concatenation($2::$3)}
;

/*module_path_concatenation : 
	LHUA module_path_expression comma_module_path_expression_list RHUA
		{T_module_path_concatenation($2::$3)}
;

comma_module_path_expression_list :
	{[]}
	| COMMA module_path_expression comma_module_path_expression_list
		{$2::$3}
;


module_path_multiple_concatenation :
	LHUA expression module_path_concatenation RHUA
		{T_module_path_multiple_concatenation($2,$3)}
;
*/
multiple_concatenation :
	LHUA  expression concatenation RHUA
		{T_multiple_concatenation($2,$3)}
;


/*A.8.2 Function calls*/

function_call :
	hierarchical_function_identifier attribute_instance_list
LPARENT expression comma_expression_list RPARENT
		{T_function_call($1,$2,$4::$5)}
;

system_function_call :
	system_function_identifier
lp_expression_comma_expression_list_rp_op
		{T_system_function_call($1,$2)}
;


lp_expression_comma_expression_list_rp_op :
	{[]}
	| LPARENT expression comma_expression_list RPARENT
		{$2::$3}
;


/*A.8.3 Expressions*/
base_expression :
	expression {$1}
;

conditional_expression :
	expression OP2_QUESTION attribute_instance_list expression COLON expression
		{T_conditional_expression($1,$3,$4,$6)}
;

dimension_expression :
	expression
		{$1}
;

expression :
	primary
		{T_expression_prim($1)}
	| OP2_ADD  attribute_instance_list primary %prec OP1_ADD  {T_expression_op1(T_unary_operator_ADD,$2,$3)}
	| OP2_SUB  attribute_instance_list primary %prec OP1_SUB  {T_expression_op1(T_unary_operator_SUB,$2,$3)}
	| OP2_AND  attribute_instance_list primary %prec OP1_AND  {T_expression_op1(T_unary_operator_REDUCE_AND ,$2,$3)}
	| OP2_OR   attribute_instance_list primary %prec OP1_OR   {T_expression_op1(T_unary_operator_REDUCE_OR  ,$2,$3)}
	| OP2_XOR  attribute_instance_list primary %prec OP1_XOR  {T_expression_op1(T_unary_operator_REDUCE_XOR ,$2,$3)}
	| OP2_XNOR attribute_instance_list primary %prec OP1_XNOR {T_expression_op1(T_unary_operator_REDUCE_XNOR,$2,$3)}
	| OP1_LOGIC_NEG   attribute_instance_list primary {T_expression_op1(T_unary_operator_LOGIC_NEG  ,$2,$3)}
	| OP1_BITWISE_NEG attribute_instance_list primary {T_expression_op1(T_unary_operator_BITWISE_NEG,$2,$3)}
	| OP1_REDUCE_NAND attribute_instance_list primary {T_expression_op1(T_unary_operator_REDUCE_NAND,$2,$3)}
	| OP1_REDUCE_NOR  attribute_instance_list primary {T_expression_op1(T_unary_operator_REDUCE_NOR ,$2,$3)}
	| expression OP2_MULTIPLE              attribute_instance_list expression {T_expression_op2($1,T_binary_operator_MUL                  ,$3,$4)}
	| expression OP2_DIV                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_DIV                  ,$3,$4)}
	| expression OP2_MOD                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_MOD                  ,$3,$4)}
	| expression OP2_EQU2                  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_EQU2                 ,$3,$4)}
	| expression OP2_NEQ2                  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_NEQ2                 ,$3,$4)}
	| expression OP2_EQU3                  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_EQU3                 ,$3,$4)}
	| expression OP2_NEQ3                  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_NEQ3                 ,$3,$4)}
	| expression OP2_POWER                 attribute_instance_list expression {T_expression_op2($1,T_binary_operator_POWER                ,$3,$4)}
	| expression OP2_LT                    attribute_instance_list expression {T_expression_op2($1,T_binary_operator_LT                   ,$3,$4)}
	| expression OP2_LE                    attribute_instance_list expression {T_expression_op2($1,T_binary_operator_LE                   ,$3,$4)}
	| expression OP2_GT                    attribute_instance_list expression {T_expression_op2($1,T_binary_operator_GT                   ,$3,$4)}
	| expression OP2_GE                    attribute_instance_list expression {T_expression_op2($1,T_binary_operator_GE                   ,$3,$4)}
	| expression OP2_LOGICAL_RIGHTSHIFT    attribute_instance_list expression {T_expression_op2($1,T_binary_operator_LOGICAL_RIGHTSHIFT   ,$3,$4)}
	| expression OP2_LOGICAL_LEFTSHIFT     attribute_instance_list expression {T_expression_op2($1,T_binary_operator_LOGICAL_LEFTSHIFT    ,$3,$4)}
	| expression OP2_ARITHMETIC_RIGHTSHIFT attribute_instance_list expression {T_expression_op2($1,T_binary_operator_ARITHMETIC_RIGHTSHIFT,$3,$4)}
	| expression OP2_ARITHMETIC_LEFTSHIFT  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_ARITHMETIC_LEFTSHIFT ,$3,$4)}
	| expression OP2_ADD                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_ADD                  ,$3,$4)}
	| expression OP2_SUB                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_SUB                  ,$3,$4)}
	| expression OP2_AND                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_AND                  ,$3,$4)}
	| expression OP2_OR                    attribute_instance_list expression {T_expression_op2($1,T_binary_operator_OR                   ,$3,$4)}
	| expression OP2_AND2                  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_AND2                 ,$3,$4)}
	| expression OP2_OR2                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_OR2                  ,$3,$4)}
	| expression OP2_XOR                   attribute_instance_list expression {T_expression_op2($1,T_binary_operator_XOR                  ,$3,$4)}
	| expression OP2_XNOR                  attribute_instance_list expression {T_expression_op2($1,T_binary_operator_XNOR                 ,$3,$4)}
	| conditional_expression
		{T_expression_condition($1)}
;


mintypmax_expression :
	expression
		{T_mintypmax_expression_1($1)}
	| expression COLON expression COLON expression
		{T_mintypmax_expression_3($1,$3,$5)}
;

/*module_path_conditional_expression :
	module_path_expression OP2_QUESTION attribute_instance_list
	module_path_expression COLON module_path_expression
		{T_module_path_conditional_expression($1,$3,$4,$6)}
;


module_path_expression :
	module_path_primary
		{T_module_path_expression_prim($1)}
	| OP2_AND  attribute_instance_list module_path_primary %prec OP1_AND {T_module_path_expression_op1(T_unary_operator_REDUCE_AND ,$2,$3)}
	| OP2_OR   attribute_instance_list module_path_primary %prec OP1_OR  {T_module_path_expression_op1(T_unary_operator_REDUCE_OR  ,$2,$3)}
	| OP2_XOR  attribute_instance_list module_path_primary %prec OP1_XOR {T_module_path_expression_op1(T_unary_operator_REDUCE_XOR ,$2,$3)}
	| OP2_XNOR attribute_instance_list module_path_primary %prec OP1_XNOR{T_module_path_expression_op1(T_unary_operator_REDUCE_XNOR,$2,$3)}
	| OP1_LOGIC_NEG   attribute_instance_list module_path_primary {T_module_path_expression_op1(T_unary_operator_LOGIC_NEG  ,$2,$3)}
	| OP1_BITWISE_NEG attribute_instance_list module_path_primary {T_module_path_expression_op1(T_unary_operator_BITWISE_NEG,$2,$3)}
	| OP1_REDUCE_NAND attribute_instance_list module_path_primary {T_module_path_expression_op1(T_unary_operator_REDUCE_NAND       ,$2,$3)}
	| OP1_REDUCE_NOR  attribute_instance_list module_path_primary {T_module_path_expression_op1(T_unary_operator_REDUCE_NOR        ,$2,$3)}
	| module_path_expression OP2_EQU2 attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_EQU2,$3,$4)}
	| module_path_expression OP2_NEQ2 attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_NEQ2,$3,$4)}
	| module_path_expression OP2_AND2 attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_AND2,$3,$4)}
	| module_path_expression OP2_OR2  attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_OR2 ,$3,$4)}
	| module_path_expression OP2_AND  attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_AND1,$3,$4)}
	| module_path_expression OP2_OR   attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_OR1 ,$3,$4)}
	| module_path_expression OP2_XOR  attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_XOR ,$3,$4)}
	| module_path_expression OP2_XNOR attribute_instance_list module_path_expression {T_module_path_expression_op2($1,T_binary_module_path_operator_XNOR,$3,$4)}
	| module_path_conditional_expression
		{T_module_path_expression_sel($1)}
;


module_path_mintypmax_expression :
	module_path_expression
		{T_module_path_mintypmax_expression_1($1)}
	| module_path_expression COLON module_path_expression COLON module_path_expression
		{T_module_path_mintypmax_expression_3($1,$3,$5)}
;
*/

range_expression :
	expression
		{T_range_expression_1($1)}
	| expression COLON expression
		{T_range_expression_2($1,$3)}
	| base_expression ADDRANGE width_expression
		{T_range_expression_addrange($1,$3)}
	| base_expression SUBRANGE width_expression
		{T_range_expression_subrange($1,$3)}
;


width_expression :
	expression
		{$1}
;

/*A.8.4 Primaries*/

/*
module_path_primary :
	number
		{T_module_path_primary_num($1)}
	| identifier
		{T_module_path_primary_id($1)}
	| module_path_concatenation
		{T_module_path_primary_concat($1)}
	| module_path_multiple_concatenation
		{T_module_path_primary_mul_concat($1)}
	| function_call
		{T_module_path_primary_func($1)}
	| system_function_call
		{T_module_path_primary_sysfunc($1)}
	| LPARENT module_path_mintypmax_expression RPARENT
		{T_module_path_primary_mintypmax($2)}
;
*/
primary :
	number
		{T_primary_num($1)}
	| hierarchical_identifier 
		{T_primary_id($1)}
	| hierarchical_identifier  lsq_expression_rsq_list LSQUARE range_expression RSQUARE
		{T_primary_idexp($1,$2,$4)}
	| concatenation
		{T_primary_concat($1)}
	| multiple_concatenation
		{T_primary_mulcon($1)}
	| function_call
		{T_primary_func($1)}
	| system_function_call
		{T_primary_sysfunc($1)}
	| LPARENT mintypmax_expression RPARENT
		{T_primary_mintypmax($2)}
	| string
		{T_primary_string($1)}
;


lsq_expression_rsq_list :
	{[]}
	| lsq_expression_rsq_list square_expression_square
		{$1@[$2]}
;


/*A.8.5 Expression left-side values*/
net_lvalue :
	hierarchical_net_identifier
		{T_net_lvalue_id($1)}
	| hierarchical_net_identifier lsq_expression_rsq_list LSQUARE range_expression RSQUARE
		{T_net_lvalue_idexp($1,$2,$4)}
	| LHUA net_lvalue comma_net_lvalue_list RHUA
		{T_net_lvalue_lvlist($2::$3)}
;


comma_net_lvalue_list :
	{[]}
	| COMMA net_lvalue comma_net_lvalue_list
		{$2::$3}
;

variable_lvalue :
	hierarchical_variable_identifier 
		{T_variable_lvalue_id($1)}
	| hierarchical_variable_identifier lsq_expression_rsq_list LSQUARE range_expression RSQUARE
		{T_variable_lvalue_idexp($1,$2,$4)}
	| LHUA variable_lvalue comma_variable_lvalue_list  RHUA
		{T_variable_lvalue_vlvlist($2::$3)}
;		

comma_variable_lvalue_list :
	{[]}
	| COMMA variable_lvalue comma_variable_lvalue_list
		{$2::$3}
;



/*A.8.6 Operators*/


/*A.8.7 Numbers*/
number :
	UNSIGNED_NUMBER {T_number_UNSIGNED_NUMBER(get1 $1, get2 $1, get3 $1)};
	| UNSIGNED_NUMBER_size {T_number_UNSIGNED_NUMBER_size(get1 $1, get2 $1, get3 $1)}
	| OCTAL_NUMBER {T_number_OCTAL_NUMBER(get1 $1, get2 $1, get3 $1)}
	| BINARY_NUMBER {T_number_BINARY_NUMBER(get1 $1, get2 $1, get3 $1)}
	| HEX_NUMBER {T_number_HEX_NUMBER(get1 $1, get2 $1, get3 $1)}
	| REAL_NUMBER {T_number_REAL_NUMBER(get1 $1, get2 $1, get3 $1)}

/*A.8.8 Strings*/
string : STRING {T_string(get1 $1, get2 $1, get3 $1)};


/*A.9 General
A.9.1 Attributes*/

attribute_instance : LPARENTSTART attr_spec  comma_attr_spec_list RPARENTSTART
	{T_attribute_instance($2::$3)}
;

comma_attr_spec_list :
	{[]}
	| COMMA attr_spec comma_attr_spec_list
		{$2::$3}
;

attr_spec :
	attr_name 
		{T_attr_spec($1,T_expression_NOSPEC)}
	| attr_name  EQU1 expression 
		{T_attr_spec($1,$3)}
;

attr_name :
	identifier {$1}
;



/*A.9.2 Comments*/
comment :
	COMMENT {$1}
;

/*A.9.3 Identifiers*/
block_identifier : identifier {$1};
cell_identifier : identifier {$1};
config_identifier : identifier {$1};
event_identifier : identifier {$1};
function_identifier : identifier {$1};
gate_instance_identifier : identifier {$1};
generate_block_identifier : identifier {$1};
genvar_identifier : identifier {$1};
hierarchical_block_identifier : hierarchical_identifier {$1};
hierarchical_event_identifier : hierarchical_identifier {$1};
hierarchical_function_identifier : hierarchical_identifier {$1};


hierarchical_identifier : 
	identifier_lsq_expression_rsq_opt_list  identifier
		{T_hierarchical_identifier($1,$2)}
;
identifier_lsq_expression_rsq_opt_list :
	{[]}
	| identifier_lsq_expression_rsq_opt_list identifier_lsq_expression_rsq_opt 
		{$1@[$2]}
;

identifier_lsq_expression_rsq_opt :
	identifier PERIOD
		{T_identifier_lsq_expression_rsq($1,T_expression_NOSPEC)}
	| identifier LSQUARE expression RSQUARE PERIOD
		{T_identifier_lsq_expression_rsq($1,$3)}
;

hierarchical_net_identifier : hierarchical_identifier {$1};
hierarchical_parameter_identifier : hierarchical_identifier {$1};
hierarchical_variable_identifier : hierarchical_identifier {$1};
hierarchical_task_identifier : hierarchical_identifier {$1};

identifier :
	SIMPLE_IDENTIFIER {T_identifier(get1 $1, get2 $1, get3 $1)}
	| ESCAPED_IDENTIFIER {T_identifier(get1 $1, get2 $1, get3 $1)}
;

/*inout_port_identifier : identifier {$1};*/
input_port_identifier : identifier {$1};
instance_identifier : identifier {$1};
library_identifier : identifier {$1};
module_identifier : identifier {$1};
module_instance_identifier : identifier {$1};
net_identifier : identifier {$1};
output_port_identifier : identifier {$1};
parameter_identifier : identifier {$1};
port_identifier : identifier {$1};
real_identifier : identifier {$1};
/*specparam_identifier : identifier {$1};*/


system_function_identifier :
	SYSTEM_TASK_FUNCTION_IDENTIFIER {T_system_function_identifier(get1 $1 , get2 $1 , get3 $1)}
;


task_identifier : identifier {$1};
/*terminal_identifier : identifier {$1};*/
/*text_macro_identifier : identifier {$1};*/
topmodule_identifier : identifier {$1};
udp_identifier : identifier {$1};
udp_instance_identifier : identifier {$1};
variable_identifier : identifier {$1};



%%

(*trailer*)

