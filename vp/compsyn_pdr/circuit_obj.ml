open Print_v
open Typedef
open Statement

class hierachcal_name = fun strlst1 ->
object (self)
	val strlst : (string list ) = strlst1
	method print vchout = Printf.fprintf vchout "%s" (self#getname)
	method getname =  String.concat "/" strlst
	method getid = strlst
end

type triger_expression = Triger_expression of expression*event_expression

type tobj = 
	Tobj_parameter_declaration of expression
	| Tobj_input_declaration of range
	| Tobj_output_declaration of range
	| Tobj_net_declaration    of range
	| Tobj_reg_declaration   of range
	| Tobj_dff_declaration   of range (*this come from Tobj_reg_declaration subtyping, and add its clock*)
	(*| Tobj_continuous_assign   of continuous_assign*)  (*this will be transfer to output or wire*)
	(*| Tobj_inout_declaration    of range*(string list)*)
	| Tobj_pred_declaration    of expression (*they are 1 bit net type,but hold special predicate for control flow abstraction*)
	| Tobj_regarray_declaration   of range*((int*expression) list)
	| Tobj_latch_declaration   of range*expression
	| Tobj_latcharray_declaration   of range*((int*expression) list)
	| Tobj_dffarray_declaration   of range*((int*(triger_expression list)) list) (*this come from Tobj_regarray_declaration subtyping, and add its clock*)
	(*| Tobj_time_declaration   of register_variables list*)
	| Tobj_integer_declaration   of expression
	| Tobj_real_declaration   of expression
	| Tobj_module_instantiation of module_item
	(*| Tobj_net_fromMI  of string*string*range*)	(*string is the instance name and port name, range is index*)
	(*| Tobj_event_declaration   of string list*)
	(*| Tobj_gate_declaration of string*drive_strength*delay*(gate_instance list)*)
	(*| Tobj_module_instantiation   of string*drive_strength*(expression list)*(module_instance list)*)
	(*| Tobj_parameter_override   of param_assignment list*)
	(*| Tobj_specify_block   of specify_item list*)
	(*| Tobj_initial_statement   of statement*)
	(*| Tobj_always_statement   of statement this will be transformed into reg*)
	(*| Tobj_task   of string*(module_item list)*statement*)
	(*| Tobj_function_avoid_amb   of range_or_type*string*(module_item list)*statement*)

class circuit_obj = fun obj1 hn1 ->
object (self)
	val obj : tobj = obj1
	val hn : hierachcal_name = hn1
	
	method get_obj = obj
	method get_hn = hn

	method get_width = begin
		match obj with
		Tobj_parameter_declaration(_) -> begin
			Printf.printf "fatal error:should not get width from Tobj_parameter_declaration \n";
			exit 1
		end
		| Tobj_input_declaration(rng) -> get_rng_width rng
		| Tobj_output_declaration(rng) -> get_rng_width rng
		| Tobj_net_declaration(rng) -> get_rng_width rng
		| Tobj_pred_declaration(_) -> 1
		| Tobj_reg_declaration(rng) -> get_rng_width rng
		| Tobj_regarray_declaration(rng,_) -> get_rng_width rng
		| Tobj_latch_declaration(rng,_) -> get_rng_width rng
		| Tobj_latcharray_declaration(rng,_) -> get_rng_width rng
		| Tobj_dff_declaration(rng) -> get_rng_width rng
		| Tobj_dffarray_declaration(rng,_) -> get_rng_width rng
		| Tobj_integer_declaration(_) -> 32
		| Tobj_real_declaration(_) -> begin
			Printf.printf "fatal error:should not get width from Tobj_real_declaration \n";
			exit 1
		end
		| Tobj_module_instantiation(_) -> begin
			Printf.printf "fatal error:should not get width from Tobj_module_instantiation \n";
			exit 1
		end
	end
	(*
	method print vchout = begin
		match 
	end*)
end
