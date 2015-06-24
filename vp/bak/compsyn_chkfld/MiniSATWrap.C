#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <alloc.h>
#include "Solver.h"

Solver *solver = new Solver();

static void convert_literals(value l, vec<Lit> &r) {
  while(Int_val(l) != 0) {
    Lit lit = toLit(Int_val(Field(l, 0)));
    r.push(lit);
    l = Field(l, 1);
  }
}

extern "C" value minisat_reset(value unit) {
  if(solver!=NULL) {
    delete solver;
  }
  solver = new Solver();

  return Val_unit;
}

extern "C" value minisat_reset_proof(value unit) {
  if(solver!=NULL) {
		if((solver->proof)!=NULL) {
			(solver->proof)->clear_proof();
		  delete solver->proof;
		}
    delete solver;
  }
  solver = new Solver();
  solver->proof = new Proof();

  return Val_unit;
}

extern "C"   value minisat_save_proof(value unit) {
    CAMLparam0();
    CAMLlocal1( ml_data );
  vec<long>& vi=(solver->proof)->save("minisat_save_proof");
  int sz=vi.size();
  ml_data = caml_alloc (sz,0);
  for (int i=0;i<sz;i++) {
//  printf("C %d\n",vi[i]);
	if (vi[i]>65536*(65536/8))   {//there are 3 2 to be devied, one for sign, one for Val_int, and one for esc_int
		printf("FATAL : too large clause index %lu\n",vi[i]);
		exit(0);
	}
  	Store_field( ml_data, i, Val_int((int)(vi[i])) );
  }
//  printf("C size %d sz_int %d %d %d %d \n",sz,sizeof(int),vi[0],vi[1],vi[2]) ;

  CAMLreturn( ml_data );

}

extern "C" value minisat_clear_proof(value unit) {
  (solver->proof)->clear_proof();
	//2014/11/17 Shen : may be we need to regenerate the proof altogether, not just the ssyChecker
	//NOOOOOO, if we generate the proof again, then the root clause will not be in it
//	delete solver->proof;
//	solver->proof = new Proof();
  return Val_unit;
}

extern "C" value minisat_new_var(value unit) {
  Var var = solver->newVar();
  return Val_int(var);
}

extern "C" value minisat_mass_new_var(value v) {
  int max_idx = Int_val(v);
  int i;
  Var var=0;
  for(i=0;i<=max_idx;i++)
	  var = solver->newVar();
  return Val_int(var);
}

extern "C" value minisat_pos_lit(value v) {
  Var var = Int_val(v);
  Lit lit(var, false);
  return Val_int(index(lit));
}

extern "C" value minisat_neg_lit(value v) {
  Var var = Int_val(v);
  Lit lit(var, true);
  return Val_int(index(lit));
}

extern "C" value minisat_add_clause(value c) {
  vec<Lit> clause;
  convert_literals(c, clause);
  solver->addClause(clause);

  return Val_unit;
}

extern "C" value minisat_simplify_db(value unit) {
  solver->simplifyDB();

  return Val_unit;
}

extern "C" value minisat_solve(value unit) {
  value r;

  if(solver->solve()) {
    r = Val_int(0);
  } else {
    r = Val_int(1);
  }

  return r;
}

extern "C" value minisat_solve_with_assumption(value a) {
  vec<Lit> assumption;
  convert_literals(a, assumption);
  value r;

  if(solver->solve(assumption)) {
    r = Val_int(0);
  } else {
    r = Val_int(1);
  }

  return r;
}

extern "C" value minisat_value_of(value v) {
  Var var = Int_val(v);
  lbool val = solver->model[var];
  value r;

  if(val == l_False) {
    r = Val_int(0);
  } else if(val == l_True) {
    r = Val_int(1);
  } else if (val == l_Undef) {
    r = Val_int(2);
  } else {
    assert(0);
  }

  return r;
}
