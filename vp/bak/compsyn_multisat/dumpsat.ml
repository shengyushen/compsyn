open Printf
open Misc
open Clauseman
open Typedef

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


let procClauseandAdd solverIdx clause_list = begin
	let max_index=get_largest_varindex_inclslst clause_list
	in begin
	  MultiMiniSAT.mass_new_var solverIdx max_index;
		(*add all cls*)
		let proc_addcls cls = begin
			match cls with
			(intlst,_) -> begin
				let clscreated=	proc_cls intlst
				in 
				MultiMiniSAT.add_clause solverIdx clscreated
			end
		end
		in
		List.iter proc_addcls  clause_list
	end
end
;;

let incrementalAddClauseList solverIdx clause_list maxiii= begin
	let max_index=get_largest_varindex_inclslst clause_list
	and curridx=ref 0 in begin
		(*printf "max_index %d maxiii %d\n" max_index maxiii;
		flush stdout ;*)
	  assert ((max_index+1)==maxiii);
		while((MultiMiniSAT.new_var solverIdx)<maxiii) do
		  curridx:=0
		done;

		(*add all cls*)
		let proc_addcls cls = begin
			match cls with
			(intlst,_) -> begin
				let clscreated=	proc_cls intlst
				in 
				MultiMiniSAT.add_clause solverIdx clscreated
			end
		end
		in
		List.iter proc_addcls  clause_list
	end
end
;;

let satSolve solverIdx  = begin
	(*solve it*)
	(*dbg_print "before MultiMiniSAT.solve";*)
	 match MultiMiniSAT.solve solverIdx with
	| UNSAT -> begin
		(*dbg_print "after MultiMiniSAT.solve";*)
		UNSATISFIABLE
	end
	| SAT   -> begin
		(*dbg_print "after MultiMiniSAT.solve";*)
		SATISFIABLE
	end
end
;;


let dump_sat solverIdx clause_list = begin
	procClauseandAdd solverIdx clause_list;
	satSolve solverIdx
end
;;


let satAssumption solverIdx assumptionList = begin
  (*printf "        before solve_with_assumption\n";
	flush stdout ;*)
	let covertedAssList=proc_cls assumptionList in
	let res=MultiMiniSAT.solve_with_assumption solverIdx covertedAssList in begin	
  (*printf "        after solve_with_assumption\n";
	flush stdout ;*)
		match res with
		| UNSAT -> begin
			(*dbg_print "after MultiMiniSAT.solve_with_assumption";*)
			UNSATISFIABLE
		end
		| SAT   -> begin
			(*dbg_print "after MultiMiniSAT.solve_with_assumption";*)
			SATISFIABLE
		end
	end
end
;;

let get_assignment solverIdx idx = begin
	assert (idx > 0) ;
	let v=MultiMiniSAT.value_of solverIdx idx
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


(*no need for pre-allocated solverIdx*)
let dump_sat_withclear clause_list = begin
  let solverIdx = MultiMiniSAT.allocSolver () in 
	let res=dump_sat solverIdx clause_list
	in begin
		MultiMiniSAT.closeSolver solverIdx;
		res
	end
end
;;
