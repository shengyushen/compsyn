open Printf
open Misc
open Clauseman
open Typedefcommon
open MiniSATcommondef

(*the following are all for one SAT solver only*)
let dump_sat clause_list = begin
		MiniSAT.reset ();
		let max_index=get_largest_varindex_inclslst clause_list
		in begin
			MiniSAT.mass_new_var max_index;
			
			(*add all cls*)
			let proc_int var = begin
				if (var > 0) then  var+var
				else if (var<0) then (-var-var+1)
				else begin
					printf "FATAL : 0 literal\n";
					exit 0
				end
			end
			in
			let proc_cls cls = begin
				match cls with
				(intlst,_) -> begin
					let clscreated=	List.map proc_int intlst
					in
					MiniSAT.add_clause clscreated
				end
			end
			in
			List.iter proc_cls  clause_list
			;
			
			(*solve it*)
			dbg_print "before MiniSAT.solve";
			 match MiniSAT.solve () with
			| UNSAT -> begin
				dbg_print "after MiniSAT.solve";
				UNSATISFIABLE
			end
			| SAT   -> begin
				dbg_print "after MiniSAT.solve";
				SATISFIABLE
			end
		end
end
;;

let dump_sat_withclear clause_list = begin
	let res=dump_sat clause_list
	in begin
		MiniSAT.reset ();
		res
	end
end
;;

let get_assignment idx = begin
	assert (idx > 0) ;
	let v=MiniSAT.value_of idx
	in begin
		match v with
		0 -> (idx,false)
		| 1 -> (idx,true)
		| _ -> begin
			printf "invalid var index : %d\n" idx ;
			flush stdout ;
			assert false
		end
	end
end
;;

let get_assignment_lit idx = begin
	assert (idx > 0) ;
	let v=MiniSAT.value_of idx
	in begin
		match v with
		0 -> (-idx)
		| 1 -> idx
		| _ -> begin
			printf "invalid var index : %d\n" idx ;
			flush stdout ;
			assert false
		end
	end
end
;;
