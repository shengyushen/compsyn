#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <alloc.h>
#include "Solver.h"

using namespace std;

vec<Solver *> solverVector;

static void multisat_convert_literals(value l, vec<Lit> &r) {
  while(Int_val(l) != 0) {
    Lit lit = toLit(Int_val(Field(l, 0)));
    r.push(lit);
    l = Field(l, 1);
  }
}

static void check_size(int idx)  {
	//check the value of idx within range
  int sz=solverVector.size();
  assert(idx<sz);
}

extern "C" value multisat_closeSolver(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
  
  if(solver!=NULL) {
		if((solver->proof)!=NULL) {
			(solver->proof)->clear_proof();
		  delete solver->proof;
		}
    delete solver;
    solverVector[idx]=NULL;
  }
	printf("multisat_closeSolver %d\n",idx);
	fflush(stdout);
	//shrinking the vector
  for (int i = (solverVector.size())-1; i >=0; i--){
	  if(solverVector[i]!=NULL) {
		  break;
		} else {
		  solverVector.pop();
		}
	}

  return Val_unit;
}

extern "C" value multisat_allocSolver(value unit) {
  Solver * newsolver=new Solver();
	solverVector.push(newsolver);
	int pos=(solverVector.size())-1;
	printf("multisat_allocSolver %d\n",pos);
	fflush(stdout);
  return Val_int(pos);
}

extern "C" value multisat_allocProof(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
  assert(solver!=NULL);
	assert((solver->proof)==NULL);

  solver->proof = new Proof();
	solverVector[idx]=solver;

  return Val_unit;
}

extern "C" value multisat_closeProof(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
  assert(solver!=NULL);
	assert((solver->proof)!=NULL);
  
	(solver->proof)->clear_proof();
	delete (solver->proof);
  solver->proof = new Proof();

  return Val_unit;
}

extern "C"   value multisat_save_proof(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);
	assert((solver->proof) !=NULL);

    CAMLparam0();
    CAMLlocal1( ml_data );
  vec<long>& vi=(solver->proof)->save("multisat_save_proof");
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

extern "C" value multisat_clear_proof(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  (solver->proof)->clear_proof();
	//2014/11/17 Shen : may be we need to regenerate the proof altogether, not just the ssyChecker
	//NOOOOOO, if we generate the proof again, then the root clause will not be in it
//	delete solver->proof;
//	solver->proof = new Proof();
  return Val_unit;
}

extern "C" value multisat_new_var(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  Var var = solver->newVar();
  return Val_int(var);
}

extern "C" value multisat_mass_new_var(value solverIdx,value v) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  int max_idx = Int_val(v);
  int i;
  Var var=0;
  for(i=0;i<=max_idx;i++)
	  var = solver->newVar();
  return Val_int(var);
}

extern "C" value multisat_pos_lit(value solverIdx, value v) {
  Var var = Int_val(v);
  Lit lit(var, false);
  return Val_int(index(lit));
}

extern "C" value multisat_neg_lit( value solverIdx,value v) {
  Var var = Int_val(v);
  Lit lit(var, true);
  return Val_int(index(lit));
}

extern "C" value multisat_add_clause(value solverIdx,value c) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  vec<Lit> clause;
  multisat_convert_literals(c, clause);
  solver->addClause(clause);

  return Val_unit;
}

extern "C" value multisat_simplify_db(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  solver->simplifyDB();

  return Val_unit;
}

extern "C" value multisat_solve(value solverIdx) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  value r;

  if(solver->solve()) {
    r = Val_int(0);
  } else {
    r = Val_int(1);
  }

  return r;
}

extern "C" value multisat_solve_with_assumption(value solverIdx, value a) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

  vec<Lit> assumption;
  multisat_convert_literals(a, assumption);
  value r;

  if(solver->solve(assumption)) {
    r = Val_int(0);
  } else {
    r = Val_int(1);
  }

  return r;
}

extern "C" value multisat_value_of(value solverIdx, value v) {
  int idx = Int_val(solverIdx);
	check_size(idx);
	Solver * solver = solverVector[idx];
	assert(solver !=NULL);

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

extern "C" value multisat_checkClosed(value unit) {
  for (int i = 0; i < solverVector.size(); i++){
	  if(solverVector[i]!=NULL) {
  	  printf("multisat_checkClosed %d in not NULL\n",i);
    	fflush(stdout);
			assert(false);
		}
	}
  return Val_unit;
}
