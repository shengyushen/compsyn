
type prfptr = string
type var = int
type lit = int
type value = int (* F | T | X *)
type solution = SAT | UNSAT
type solverIndex = int

let string_of_value (v: value): string =
  match v with
  | 0 -> "false"
  | 1 -> "true"
  | 2 -> "unknown"
  | _ -> "error"
  (*
  | F -> "false"
  | T -> "true"
  | X -> "unknown"
  *)
external allocSolver           : unit -> solverIndex                           = "multisat_allocSolver"
external closeSolver           : solverIndex -> unit                           = "multisat_closeSolver"
external allocProof            : solverIndex -> unit                           = "multisat_allocProof"
external closeProof            : solverIndex -> unit                           = "multisat_closeProof"
external save_proof            : solverIndex -> (int array)                    = "multisat_save_proof"
external clear_proof           : solverIndex -> unit                           = "multisat_clear_proof"
external new_var               : solverIndex -> var                            = "multisat_new_var"
external mass_new_var          : solverIndex -> var -> var                     = "multisat_mass_new_var"
external pos_lit               : solverIndex -> var -> lit                     = "multisat_pos_lit"
external neg_lit               : solverIndex -> var -> lit                     = "multisat_neg_lit"
external add_clause            : solverIndex -> lit list -> unit               = "multisat_add_clause"
external simplify_db           : solverIndex -> unit                           = "multisat_simplify_db"
external solve                 : solverIndex -> solution                       = "multisat_solve"
external solve_with_assumption : solverIndex -> lit list -> solution           = "multisat_solve_with_assumption"
external value_of              : solverIndex -> var -> value                   = "multisat_value_of"
external checkClosed           : unit -> unit                                  = "multisat_checkClosed"
