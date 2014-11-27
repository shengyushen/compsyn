type result = SATISFIABLE | UNSATISFIABLE 
type result_uniq = RES_UNIQ | RES_NONU | RES_UNK
type proofitem = Tproofitem_0B of int list
		| Tproofitem_1A of int list
		| Tproofitem_chain of int*((int*int) list)*(int list)  (*learned cls id,  clsA   (varB*clsB) list   learned cls*)

type iterpCircuit = TiterpCircuit_true
		| TiterpCircuit_false
		| TiterpCircuit_refcls of int
		| TiterpCircuit_refvar of int
		| TiterpCircuit_and of iterpCircuit list
		| TiterpCircuit_or of iterpCircuit list
		| TiterpCircuit_none
		| TiterpCircuit_printed of int
