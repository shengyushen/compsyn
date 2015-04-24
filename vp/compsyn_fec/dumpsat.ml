open Printf
open Misc
open Clauseman
open Typedefcommon
open MiniSATcommondef

(*the following are all for one SAT solver only*)
let proc_int var = begin
	if (var > 0) then  var+var
	else if (var<0) then (-var-var+1)
	else begin
		printf "FATAL : 0 literal\n";
		exit 0
	end
end
;;

let proc_cls cls = begin
	List.map proc_int cls
end
;;

let procSetMaxVar max_index = begin
	MiniSAT.mass_new_var max_index;
  ()
end
;;


let procClauseandAdd_internal clause_list = begin
	let max_index=get_largest_varindex_inclslst clause_list
	in begin
		procSetMaxVar max_index;
		(*add all cls*)
		let proc_addcls cls = begin
			match cls with
			(intlst,_) -> begin
				let clscreated=	proc_cls intlst
				in 
				MiniSAT.add_clause clscreated
			end
		end
		in
		List.iter proc_addcls  clause_list
	end
end
;;

let procClauseandAdd clause_list = begin
	MiniSAT.reset ();
	procClauseandAdd_internal clause_list
end
;;

let procClauseandAddProof clause_list = begin
	MiniSAT.reset_proof ();
	procClauseandAdd_internal clause_list
end
;;
let dump_sat clause_list = begin
			procClauseandAdd clause_list;
			
			(*solve it*)
			(*dbg_print "before MiniSAT.solve";*)
			 match MiniSAT.solve () with
			| UNSAT -> begin
				(*dbg_print "after MiniSAT.solve";*)
				UNSATISFIABLE
			end
			| SAT   -> begin
				(*dbg_print "after MiniSAT.solve";*)
				SATISFIABLE
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

let reset = begin
	MiniSAT.reset ();
end
;;

let satAssumption assumptionList = begin
  printf "        before solve_with_assumption\n";
	flush stdout ;
	let covertedAssList=proc_cls assumptionList in
	let res=MiniSAT.solve_with_assumption covertedAssList in begin	
  printf "        after solve_with_assumption\n";
	flush stdout ;
		match res with
		| UNSAT -> begin
			(*dbg_print "after MiniSAT.solve_with_assumption";*)
			UNSATISFIABLE
		end
		| SAT   -> begin
			(*dbg_print "after MiniSAT.solve_with_assumption";*)
			SATISFIABLE
		end
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
