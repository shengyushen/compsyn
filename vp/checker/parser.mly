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
%token  <Lexing.position*Lexing.position*string> KEY_PATHPULSE


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

use_clause :
	KEY_USE library_identifier_period_opt_cell_identifier colon_config_opt
		{T_use_clause($1,$2)}
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
	{false}
	| KEY_SIGNED {true}
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

specparam_declaration :
	KEY_SPECPARAM range_opt list_of_specparam_assignments SEMICOLON
		{T_specparam_declaration($2,$3)}
;

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

input_declaration :
	KEY_INPUT net_type_opt signed_opt  range_opt list_of_port_identifiers
		{T_input_declaration($2,$3,$4,$5)}

output_declaration :
	KEY_OUTPUT net_type_opt signed_opt range_opt list_of_port_identifiers
		{T_output_declaration_net($2,$3,$4,$5)}
	| KEY_OUTPUT KEY_REG signed_opt range_opt list_of_variable_port_identifiers
		{T_output_declaration_reg($3,$4,$5)}
	| KEY_OUTPUT output_variable_type list_of_variable_port_identifiers
		{T_output_declaration_var($2,$3)}
		


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
		{T_net_declaration_trireg_4($2,$3,$4,$5,$6)}

delay3_opt :
	{T_delay3_NOSPEC}
	| delay3 {$1}

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
	| trior 			{T_net_type__KEY_TRIOR}
	| tri0 				{T_net_type__KEY_TRI0}
	| tri1				{T_net_type__KEY_TRI1}
	| uwire 			{T_net_type__KEY_UWIRE}
	| wire 				{T_net_type__KEY_WIRE}
	| wand 				{T_net_type__KEY_WAND}
	| wor					{T_net_type__KEY_WOR}
;

output_variable_type :
	KEY_INTEGER | KEY_TIME
real_type :
	real_identifier dimension_list
		{T_real_type_noass($1,$2)}
	| real_identifier EQU1 constant_expression
		{T_real_type_ass($1,$3)}
;


variable_type :
	variable_identifier dimension_list
		{T_variable_type_noass($1,$2)}
	| variable_identifier EQU1 constant_expression
		{T_variable_type_ass($1,$3)}
;

/*A.2.2.2 Strengths*/

drive_strength :
	LPARENT strength0 COMMA strength1 RPARENT
		{T_drive_strength($1,$2)}
	| LPARENT strength1 COMMA strength0 RPARENT
		{T_drive_strength($1,$2)}
	| LPARENT strength0 COMMA KEY_HIGHZ1 RPARENT
		{T_drive_strength($1,$2)}
	| LPARENT strength1 COMMA KEY_HIGHZ0 RPARENT
		{T_drive_strength($1,$2)}
	| LPARENT KEY_HIGHZ0 COMMA strength1 RPARENT
		{T_drive_strength($1,$2)}
	| LPARENT KEY_HIGHZ1 COMMA strength0 RPARENT
		{T_drive_strength($1,$2)}
;



strength0 :
	KEY_SUPPLY0		{$1}
	| KEY_STRONG0		{$1}
	| KEY_PULL0			{$1}
	| KEY_WEAK0 {$1}
;
strength1 :
	KEY_SUPPLY1		{$1}
	| KEY_STRONG1		{$1}
	| KEY_PULL1			{$1}
	| KEY_WEAK1 {$1}
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
		{$T_delay2_minmax2($3,$5)}
;


delay_value :
	unsigned_number
	| real_number
	| identifier
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

list_of_param_assignments :
	param_assignment comma_param_assignment_list
		{$1::$2}
;

comma_param_assignment_list :
	{[]}
	| COMMA param_assignment comma_param_assignment_list
		{$2::$3}

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

list_of_specparam_assignments :
	specparam_assignment comma_specparam_assignment_list
		{}
;

comma_specparam_assignment_list :
	{[]}
	| COMMA specparam_assignment comma_specparam_assignment_list
		{$2::$3}
;

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
	port_identifier_equ1_constant_expression_opt
	comma_port_identifier_equ1_constant_expression_opt_list
		{$1::$2}
;

port_identifier_equ1_constant_expression_opt :
	port_identifier equ1_constant_expression_opt
		{T_port_identifier_equ1_constant_expression_opt($1,$2)}

equ1_constant_expression_opt :
	{T_constant_expression_NOSPEC}
	| EQU1 constant_expression {$2}
;

comma_port_identifier_equ1_constant_expression_opt_list :
	{[]}
	| COMMA port_identifier_equ1_constant_expression_opt comma_port_identifier_equ1_constant_expression_opt_list
		{$2::$3}
;

	

/*A.2.4 Declaration assignments*/
defparam_assignment :
	hierarchical_parameter_identifier EQU1 constant_mintypmax_expression
		{T_defparam_assignment($1,$3)}
;

net_decl_assignment :
	net_identifier EQU1 expression
		{T_net_decl_assignment($1,$3)}
;

param_assignment :
	parameter_identifier EQU1 constant_mintypmax_expression
		{T_param_assignment($1,$3)}
;

specparam_assignment :
	specparam_identifier EQU1 constant_mintypmax_expression
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
	{T_constant_mintypmax_expression_NOSPEC}
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
	constant_mintypmax_expression
		{$1}
;


/*A.2.5 Declaration ranges*/
dimension :
	LSQUARE	dimension_constant_expression COLON dimension_constant_expression RSQUARE
		{T_dimension($2,$4)}
;

range :
	LSQUARE msb_constant_expression COLON lsb_constant_expression RSQUARE
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

automatic_opt :
	{T_automatic_false}
	| KEY_AUTOMATIC {T_automatic_true}
;

function_range_or_type_opt :
	{T_function_range_or_type_NOSPEC}
	| function_range_or_type {$1}

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
		
comma_attribute_instance_list_tf_input_declaration_list :
	{[]}
	| COMMA attribute_instance_list_tf_input_declaration comma_attribute_instance_list_tf_input_declaration_list
		{$2::$3}
;

function_range_or_type :
	{T_function_range_or_type_NOSPEC}
	|	KEY_SIGNED {T_function_range_or_type(T_signed_TRUE,T_range_NOSPEC)}
	| range				{T_function_range_or_type(T_signed_FALSE,range)}
	|	KEY_SIGNED range {T_function_range_or_type(T_signed_TRUE,range)}
	| KEY_INTEGER {T_function_range_or_type_INTEGER}
	| real				{T_function_range_or_type_REAL}
	| realtime		{T_function_range_or_type_REALTIME}
	| time				{T_function_range_or_type_TIME}
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

task_port_list :
	task_port_item comma_task_port_item_list
		{$1::$2}
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
		{T_cmos_switch_instance $1,$3,$5,$7,$9}
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

comma_input_terminal_list :
	{[]}
	| COMMA input_terminal comma_input_terminal_list
		{$2::$3}
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

parameter_value_assignment_opt :
	{T_parameter_value_assignment_NOSPEC}
	| parameter_value_assignment {$1}

parameter_value_assignment :
	JING LPARENT list_of_parameter_assignments RPARENT
		{$1}
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

name_of_module_instance :
	module_instance_identifier range_opt
		{T_name_of_module_instance($1,$2)}
;

list_of_port_connections :
	ordered_port_connection comma_ordered_port_connection_list
		T_list_of_port_connections_ordered($1::$2)
	| named_port_connection comma_named_port_connection_list
		T_list_of_port_connections_named($1::$2)
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
		{T_generate_region($1)}

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
	KEY_FOR LPARENT genvar_initialization SEMICOLON genvar_expression SEMICOLON genvar_iteration RPARENT generate_block
		{}
;



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

