
type prfptr = string
type var = int
type lit = int
type value = int (* F | T | X *)
type solution = SAT | UNSAT


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
