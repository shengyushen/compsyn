#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstdio>
#include <vector>
#include <set>

using namespace std;

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>

#include "../MiniSat114_enhance/Solver.h"
#include "minisat_addon.h"


double get_cpu_time()
{
  double res;
  struct rusage usage;

  getrusage(RUSAGE_SELF, &usage);

  res = usage.ru_utime.tv_usec + usage.ru_stime.tv_usec;
  res *= 1e-6;
  res += usage.ru_utime.tv_sec + usage.ru_stime.tv_sec; 
	
  return res;
}

bool findin_set(int tobefind,const set<int>& vv) {
	for(set <int> ::iterator itr=vv.begin();itr!=vv.end();++itr) {
		if((*itr)==tobefind) return true;
	}
	return false;
}

int lowbound_set(const set<int>& vv) {
	assert(vv.empty()==false);
	bool found=false;
	int lowbound=0;
	for(set <int> ::iterator itr=vv.begin();itr!=vv.end();++itr) {
		if(found==false || lowbound>(*itr)) {
			found=true;
			lowbound=(*itr);
		}
	}
	assert(found==true);
	return lowbound;
}

int upbound_set(const set<int>& vv) {
	assert(vv.empty()==false);
	bool found=false;
	int upbound=0;
	for(set <int> ::iterator itr=vv.begin();itr!=vv.end();++itr) {
		if(found==false || upbound<(*itr)) {
			found=true;
			upbound=(*itr);
		}
	}
	assert(found==true);
	return upbound;
}

bool findin_vector(int tobefind,vector<int> vv) {
	for(vector <int> ::iterator itr=vv.begin();itr!=vv.end();++itr) {
		if((*itr)==tobefind) return true;
	}
	return false;
}

void resolve(vector<int> & leftcls,vector<int>& rightcls,int pivotidx) {

	//searching for pivotidx in leftcls, make sure their is only one
	int number_left=0;//number of pivotidx
	vector <int> ::iterator pos_left;
	bool Positive_left;
	for(vector <int> ::iterator itr=leftcls.begin();itr!=leftcls.end();++itr) {
		if(abs(*itr)==pivotidx) {
			number_left++;
			pos_left=itr;
			assert((*itr)!=0);
			if(*itr>0) Positive_left=true;
			else Positive_left=false;
		}
	}
	if(number_left!=1) {
		cout<<"number_left "<<number_left<<endl;
		print_cls(cout,leftcls);
		assert(0);
	}
	leftcls.erase(pos_left);

	//searching for pivotidx in rightcls, make sure their is only one
	int number_right=0;//number of pivotidx
	vector <int> ::iterator pos_right;
	bool Positive_right;
	for(vector <int> ::iterator itr=rightcls.begin();itr!=rightcls.end();++itr) {
		if(abs(*itr)==pivotidx) {
			number_right++;
			pos_right=itr;
			assert((*itr)!=0);
			if(*itr>0) Positive_right=true;
			else Positive_right=false;
		}
	}
	if(number_right!=1) {
		cout<<"number_right "<<number_right<<endl;
		print_cls(cout,rightcls);
		assert(0);
	}
	rightcls.erase(pos_right);

	//make sure their polar are not the same
	if(Positive_right==Positive_left) {
		cout<<"same polar with pivot "<<pivotidx<<endl;
		print_cls(cout,leftcls);
		print_cls(cout,rightcls);
		assert(0);
	}
	for(vector <int> ::iterator itr=rightcls.begin();itr!=rightcls.end();++itr) {
		if(findin_vector(*itr,leftcls)==false)	leftcls.push_back(*itr);
	}

}

bool isAcls(vector<int> & cls,int maxidx) {
	for(vector <int> ::iterator itr=cls.begin();itr!=cls.end();++itr) {
		if(abs(*itr)>maxidx) return false;
	}
	return true;
}

void filterB(vector<int>& cls,set<int>& POTDEC_reduce,vector<int> & res) {
	for(vector <int> ::iterator itr=cls.begin();itr!=cls.end();++itr) {
		if(findin_set(abs((*itr)),POTDEC_reduce)==true) {
			res.push_back(*itr);
		}
	}
	return;
}

bool isBvar(int varidx,set<int>& POTDEC_reduce,int maxidx) {
	assert(varidx>0);
	if(varidx>maxidx) return true;
	else if(findin_set(varidx,POTDEC_reduce)==true) return true;
	else return false;
}

void print_cls(ostream & ost,vector<int> cls2prt) {
	for(vector<int>::iterator itr=cls2prt.begin();itr!=cls2prt.end();++itr) {
		ost<<*itr<<" ";
	}
	ost<<endl;
	return;
}

void print_set(ostream & ost,set<int> cls2prt) {
	for(set<int>::iterator itr=cls2prt.begin();itr!=cls2prt.end();++itr) {
		ost<<*itr<<" ";
	}
	ost<<endl;
	return;
}


void SAT_SetNumVariables(SAT_Manager mng, int init_varnum) 
{
	assert(init_varnum>0);
	//add one more index such that the zchaff setting dont conflict with minisat
	for (int i = 0; i <= init_varnum; i++) mng->newVar();
}

int SAT_Solve(SAT_Manager mng)
{
	mng->solve();
	return (mng->okay()) ? SATISFIABLE : UNSATISFIABLE;
}


int SAT_GetVarAsgnment(SAT_Manager mng, int varid)
{
	lbool curvalue=(mng->model)[varid];
	int v;
	if(l_True==curvalue) v=1;
	else if(l_False==curvalue) v=0;
	else {
		assert(0);
	}
	assert(v==0||v==1);
	return v;
}

void SAT_AddClause(SAT_Manager mng,vector <int>& lits, int gid)
{
	assert(gid==0);
	mng->addClause(lits);
}


