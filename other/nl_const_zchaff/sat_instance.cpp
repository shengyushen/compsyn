#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstdio>

#include <set>
#include <map>
#include <list>
#include <vector>
#include <dirent.h>
#include "SAT.h"
#include <assert.h>
#include <string.h>

#include "zchaff_solver.h"
#include "sat_instance.h"

using namespace std;

SAT_instance::SAT_instance() {
	final_index_oneinst=0;
	dly = 0;
	len = 0;
	prefix = 0;
	forward = 0;
	start_time=get_cpu_time();
}

void SAT_instance::read_cnf(char * filename,char * timeout_value,int & init_varnum,set<vector <int> > & init_clauseset)
{
//    cout <<"read cnf "<<endl;
    char line_buffer[MAX_LINE_LENGTH];
    char word_buffer[MAX_WORD_LENGTH];
    set<int> clause_vars;
    set<int> clause_lits;
    int line_num = 0;
    
    if(opendir(filename)){
        cerr << "Can't open input file, it's a directory" << endl;
	exit(1);
    }
    
    ifstream inp (filename, ios::in);
    if (!inp) {
	cerr << "Can't open input filehaha" << endl;
	exit(1);
    }
    

    while (inp.getline(line_buffer, MAX_LINE_LENGTH)) {
	++ line_num;
	if ( 0 == strncmp(line_buffer,"c for_rev_cz final_index_oneinst",strlen("c for_rev_cz final_index_oneinst")) ) {
		sscanf (line_buffer, "c for_rev_cz final_index_oneinst %d", &final_index_oneinst);
	}
	else if ( 0 == strncmp(line_buffer,"c for_rev_cz dly",strlen("c for_rev_cz dly")) ) {
		sscanf (line_buffer, "c for_rev_cz dly %d", &dly);
	}
	else if ( 0 == strncmp(line_buffer,"c for_rev_cz len",strlen("c for_rev_cz len")) ) {
		sscanf (line_buffer, "c for_rev_cz len %d", &len);
	}
	else if ( 0 == strncmp(line_buffer,"c for_rev_cz prefix",strlen("c for_rev_cz prefix")) ) {
		sscanf (line_buffer, "c for_rev_cz prefix %d", &prefix);
	}
	else if ( 0 == strncmp(line_buffer,"c for_rev_cz forward",strlen("c for_rev_cz forward")) ) {
		sscanf (line_buffer, "c for_rev_cz forward %d", &forward);
	}
	else if ( 0 == strncmp(line_buffer,"c for_rev_cz input",strlen("c for_rev_cz input")) ) {
		char ssy[80];
		int left,right;
		sscanf (line_buffer, "c for_rev_cz input %s %d %d", ssy,&left,&right);
		inname_2dualsyn_notflatidx_lst.insert(ssy);

	    	struct inout4rev_cz i1;
		i1.name=ssy;
		i1.left=left;
		i1.right=right;
	    	in_name_leftright_set.insert(i1);
	}
	else if ( 0 == strncmp(line_buffer,"c for_rev_cz output",strlen("c for_rev_cz output")) ) {
		char ssy[80];
		int left,right;
		sscanf (line_buffer, "c for_rev_cz output %s %d %d", ssy,&left,&right);
		outname_2dualsyn_notflatidx_lst.insert(ssy);
	
	    	struct inout4rev_cz i1;
		i1.name=ssy;
		i1.left=left;
		i1.right=right;
    		out_name_leftright_set.insert(i1);
	}
	else if ( 0 == strncmp(line_buffer,"c one instance mapping",strlen("c one instance mapping")) ) {
		char ssy[80];
		int tgt,src,left,right;
		sscanf (line_buffer, "c one instance mapping %s %d %d %d %d", ssy,&src,&tgt,&left,&right);
		assert (src>0) ;
		if(left==-1) { // no range
			assert(right==-1);
			if(tgt==-1) { //normal reg
				tgt_name2idx[ssy]=src;
				tgt_idx2name[src]=ssy;
				src_name2idx[ssy]=src;
				src_idx2name[src]=ssy;
			} else { //dff
				tgt_name2idx[ssy]=tgt;
				tgt_idx2name[tgt]=ssy;
				src_name2idx[ssy]=src;
				src_idx2name[src]=ssy;
			}
			if (inname_2dualsyn_notflatidx_lst.find(string(ssy))!=inname_2dualsyn_notflatidx_lst.end()) //found in inname_2dualsyn_notflatidx_lst
			{
				inname_2dualsyn_flatidx_lst.insert(ssy);
			}
			if(outname_2dualsyn_notflatidx_lst.find(string(ssy))!=outname_2dualsyn_notflatidx_lst.end())//found in outname_2dualsyn_notflatidx_lst
			{
				outname_2dualsyn_flatidx_lst.insert(ssy);
			}
		} else {// has range
			assert(right!=-1);
			
			int tgt_idx=tgt;
			int src_idx=src;
			for(int i=left;((left>right)?(i>=right):(i<=right));((left>right)?(i--):(i++))) {
				//cerr << ssy << " "<< i << endl;
				char sdf[80];
				sprintf(sdf,"%s[%d]",ssy,i);
				if(tgt==-1) {//normal reg
					tgt_name2idx[sdf]=src_idx;
					tgt_idx2name[src_idx]=sdf;
					src_name2idx[sdf]=src_idx;
					src_idx2name[src_idx]=sdf;
				} else {//dff
					assert(tgt-src==abs(left-right)+1);
					tgt_name2idx[sdf]=tgt_idx;
					tgt_idx2name[tgt_idx]=sdf;
					src_name2idx[sdf]=src_idx;
					src_idx2name[src_idx]=sdf;
				}
				tgt_idx++;
				src_idx++;
				if (inname_2dualsyn_notflatidx_lst.find(string(ssy))!=inname_2dualsyn_notflatidx_lst.end()) //found in inname_2dualsyn_notflatidx_lst
				{
					inname_2dualsyn_flatidx_lst.insert(sdf);
				}
				if(outname_2dualsyn_notflatidx_lst.find(string(ssy))!=outname_2dualsyn_notflatidx_lst.end())//found in outname_2dualsyn_notflatidx_lst
				{
					outname_2dualsyn_flatidx_lst.insert(sdf);
				}
			}
		}
		
	}
	else if (line_buffer[0] == 'c') { 
	    continue; 
	}
	else if (line_buffer[0] == 'p') {
	    int var_num;
	    int cl_num;

	    int arg = sscanf (line_buffer, "p cnf %d %d", &var_num, &cl_num);
	    if( arg < 2 ) {
		cerr << "Unable to read number of variables and clauses"
		     << "at line " << line_num << endl;
		exit(3);
	    }
	    //SAT_SetNumVariables(mng, var_num); //first element not used.
	    init_varnum=var_num;
	}
	else {                             // Clause definition or continuation
	    char *lp = line_buffer;
	    do {
		char *wp = word_buffer;
		while (*lp && ((*lp == ' ') || (*lp == '\t'))) {
		    lp++;
		}
		while (*lp && (*lp != ' ') && (*lp != '\t') && (*lp != '\n')) {
		    *(wp++) = *(lp++);
		}
		*wp = '\0';                                 // terminate string

		if (strlen(word_buffer) != 0) {     // check if number is there
		    int var_idx = atoi (word_buffer);
		    int sign = 0;

		    if( var_idx != 0) {
			if( var_idx < 0)  { var_idx = -var_idx; sign = 1; }//sign ==1 means -
			clause_vars.insert(var_idx);
			clause_lits.insert( (var_idx << 1) + sign);
		    } 	
		    else {
			//add this clause
			if (clause_vars.size() != 0 && (clause_vars.size() == clause_lits.size())) { //yeah, can add this clause
			    vector <int> temp;
			    for (set<int>::iterator itr = clause_lits.begin();
				 itr != clause_lits.end(); ++itr)
				temp.push_back (*itr);
			    //SAT_AddClause(mng, & temp.begin()[0], temp.size() );
			    init_clauseset.insert(temp);
			}
			else {} //it contain var of both polarity, so is automatically satisfied, just skip it
			clause_lits.clear();
			clause_vars.clear();
		    }
		}
	    }
	    while (*lp);
	}
    }
    if (!inp.eof()) {
	cerr << "Input line " << line_num <<  " too long. Unable to continue..." << endl;
	exit(2);
    }

//    assert (clause_vars.size() == 0); 	//some benchmark has no 0 in the last clause
    if (clause_lits.size() && clause_vars.size()==clause_lits.size() ) {
	vector <int> temp;
	for (set<int>::iterator itr = clause_lits.begin();
	     itr != clause_lits.end(); ++itr)
	    temp.push_back (*itr);
	//SAT_AddClause(mng, & temp.begin()[0], temp.size() );
	init_clauseset.insert(temp);
    }
    clause_lits.clear();
    clause_vars.clear();
//    cout <<"done read cnf"<<endl;
	sscanf(timeout_value,"%d",&timeout_nl_const);
}


void SAT_instance::add_cls_vector(SAT_Manager mng1,vector<int> temp,int gid)
{
	SAT_AddClause(mng1, & temp.begin()[0], temp.size(),gid);
}

bool SAT_instance::is_var_in_cls(int totest,vector<int> cls) 
{
	for(vector<int>::iterator itr=cls.begin();itr!=cls.end();itr++)
	{
		int lit=*itr;
		int varidx=lit>>1;
		if(varidx==totest) return true;
	}
	return false;
}

void SAT_instance::check_simpilfy_instance(int totry,set<int> POTDEC_reduce,int  init_varnum,set<vector <int> > init_clauseset,set<vector <int> > init_clauseset_simp)
{
	cout<<endl<<"start check_simpilfy_instance size "<<init_clauseset.size()<<endl;
	//first init the sat solver
	SAT_Manager mng=SAT_InitManager();
	SAT_SetNumVariables(mng, init_varnum*2);//we need two copies of clause sets
	
	//to store the origin clause set
	int clgrp_orig=SAT_AllocClauseGroupID(mng);
	for(set< vector<int> >::iterator itr=init_clauseset_simp.begin();itr!=init_clauseset_simp.end();++itr) {
		vector<int> temp=*itr;
		add_cls_vector(mng, temp,clgrp_orig);
	}

	int clgrp_copy=SAT_AllocClauseGroupID(mng);//to store the copied clause set
	for(set< vector<int> >::iterator itr=init_clauseset.begin();itr!=init_clauseset.end();++itr) {
		vector<int> temp=*itr;
		vector<int> cpy_tmp;
		for(vector<int>::iterator itr_tmp=temp.begin();itr_tmp!=temp.end();itr_tmp++) {
			int lit=(*itr_tmp);
			int newlit=lit+(init_varnum*2);
			cpy_tmp.push_back(newlit);
		}
		add_cls_vector(mng, cpy_tmp,clgrp_copy);
	}

	//the equ
	int clgrp_equ=SAT_AllocClauseGroupID(mng);
	for(set<int>::iterator itr=POTDEC_reduce.begin();itr!=POTDEC_reduce.end();itr++) {
		vector<int> temp;
		int var2=(*itr)<<1;

		int pos1=pos(var2);
		int neg2=neg(var2+init_varnum*2);
		temp.push_back(pos1);
		temp.push_back(neg2);
		add_cls_vector(mng, temp,clgrp_equ);
		
		temp.clear();
		int neg1=neg(var2);
		int pos2=pos(var2+init_varnum*2);
		temp.push_back(neg1);
		temp.push_back(pos2);
		add_cls_vector(mng, temp,clgrp_equ);
	}
	
	//the inequ
		vector<int> temp;

		int pos1=pos(totry<<1);
		int pos2=pos((totry<<1)+(init_varnum*2));
		temp.push_back(pos1);
		temp.push_back(pos2);
		add_cls_vector(mng, temp,clgrp_equ);
		
		temp.clear();
		int neg1=neg(totry<<1);
		int neg2=neg((totry<<1)+(init_varnum*2));
		temp.push_back(neg1);
		temp.push_back(neg2);
		add_cls_vector(mng, temp,clgrp_equ);
	
	int * result_pointer;
	int   result_size;
	int satres=SAT_Solve(mng);
	assert(satres==UNSATISFIABLE || satres==SATISFIABLE);
	assert(satres==UNSATISFIABLE);
	
	//delete the mng
	SAT_ReleaseManager(mng);
	cout<<endl<<"end check_simpilfy_instance "<<init_clauseset_simp.size()<<endl;
}

void SAT_instance::simpilfy_instance(int totry,set<int> POTDEC_reduce,int  init_varnum,set<vector <int> > init_clauseset,set<vector <int> > & init_clauseset_simp)
{
	cout<<endl<<"start simpilfy_instance size "<<init_clauseset.size()<<endl;
	//first init the sat solver
	SAT_Manager mng;
	set< vector<int> > empty;
	initial_sat_solver(mng,empty,init_varnum*2);
	
	//to store the origin clause set
	int clgrp_orig=SAT_AllocClauseGroupID(mng);
	for(set< vector<int> >::iterator itr=init_clauseset.begin();itr!=init_clauseset.end();++itr) {
		vector<int> temp=*itr;
		add_cls_vector(mng, temp,clgrp_orig);
	}

	int clgrp_copy=SAT_AllocClauseGroupID(mng);//to store the copied clause set
	for(set< vector<int> >::iterator itr=init_clauseset.begin();itr!=init_clauseset.end();++itr) {
		vector<int> temp=*itr;
		vector<int> cpy_tmp;
		for(vector<int>::iterator itr_tmp=temp.begin();itr_tmp!=temp.end();itr_tmp++) {
			int lit=(*itr_tmp);
			int newlit=lit+(init_varnum*2);
			cpy_tmp.push_back(newlit);
		}
		add_cls_vector(mng, cpy_tmp,clgrp_copy);
	}

	//the equ
	int clgrp_equ=SAT_AllocClauseGroupID(mng);
	for(set<int>::iterator itr=POTDEC_reduce.begin();itr!=POTDEC_reduce.end();itr++) {
		vector<int> temp;
		int var2=(*itr)<<1;

		int pos1=pos(var2);
		int neg2=neg(var2+init_varnum*2);
		temp.push_back(pos1);
		temp.push_back(neg2);
		add_cls_vector(mng, temp,clgrp_equ);
		
		temp.clear();
		int neg1=neg(var2);
		int pos2=pos(var2+init_varnum*2);
		temp.push_back(neg1);
		temp.push_back(pos2);
		add_cls_vector(mng, temp,clgrp_equ);
	}
	
	//the inequ
		vector<int> temp;

		int pos1=pos(totry<<1);
		int pos2=pos((totry<<1)+(init_varnum*2));
		temp.push_back(pos1);
		temp.push_back(pos2);
		add_cls_vector(mng, temp,clgrp_equ);
		
		temp.clear();
		int neg1=neg(totry<<1);
		int neg2=neg((totry<<1)+(init_varnum*2));
		temp.push_back(neg1);
		temp.push_back(neg2);
		add_cls_vector(mng, temp,clgrp_equ);
	
	int * result_pointer;
	int   result_size;
	int satres=SAT_Solve_ssy_unsat(mng,clgrp_orig,&result_pointer,&result_size,-1);
	assert(satres==UNSATISFIABLE || satres==SATISFIABLE);
	assert(satres==UNSATISFIABLE);
	
	init_clauseset_simp.clear();
	vector<int> clstt;
	for(int i=0;i<result_size;i++) {
		if(result_pointer[i]!=0) 
			clstt.push_back(result_pointer[i]);
		else {
			init_clauseset_simp.insert(clstt);
			clstt.clear();
		}
	}
	
	/*for(set< vector<int> >::iterator itr=init_clauseset_simp.begin();itr!=init_clauseset_simp.end();itr++) {
		vector<int> clll=*itr;
		cout<<"   out solver ";
		for(vector<int>::iterator itrcl=clll.begin();itrcl!=clll.end();itrcl++) {
			int lit=*itrcl;
			cout<<lit<<" ";
		}
		cout<<endl;
	}*/
	
	//delete the mng
	SAT_ReleaseManager(mng);
	cout<<endl<<"end simpilfy_instance "<<init_clauseset_simp.size()<<endl;
}

void SAT_instance::initial_sat_solver(SAT_Manager & mng_2init,set< vector<int> > init_clauseset_2init,int init_varnum_2init)
{
	//first init the sat solver
	mng_2init=SAT_InitManager();
	
	//push clauses and variables into mng 
	SAT_SetNumVariables(mng_2init, init_varnum_2init);
	//assert(init_clauseset_2init.empty()!=true);
	for(set< vector<int> >::iterator itr=init_clauseset_2init.begin();itr!=init_clauseset_2init.end();++itr) {
		vector<int> temp=*itr;
		add_cls_vector(mng_2init, temp);
	}
}

void SAT_instance::deletel_sat_solver(SAT_Manager & mng_2del)
{
	SAT_ReleaseManager(mng_2del);
}

/*void SAT_instance::find_anchor_point_set(set<int> & anchor_point_set)
{
	anchor_point_set.clear();

	char filename[]="anchor_list";

	if(opendir(filename)){
		cerr << "Can't open input file, it's a directory" << endl;
		exit(1);
	}
    
	ifstream inp (filename, ios::in);
	if (!inp) {
		cerr << "Can't open input file" << endl;
		exit(1);
	}
    
	char line_buffer[MAX_LINE_LENGTH];
	int v;
	//now return the data
	while(inp.getline(line_buffer, MAX_LINE_LENGTH)) {
		sscanf (line_buffer, "%d", &v);
		anchor_point_set.insert(v);
	}
	
	return ;
}*/

void SAT_instance::my_set_union(set<int> s1,set<int> s2,set<int> & res)
{
	for(set<int>::iterator itr1=s1.begin();itr1!=s1.end();++itr1) {
		assert(res.find(*itr1)==res.end()); //this should not in it
		res.insert(*itr1);
	}
	for(set<int>::iterator itr2=s2.begin();itr2!=s2.end();++itr2) {
		assert(res.find(*itr2)==res.end()); //this should not in it
		res.insert(*itr2);
	}
}

void SAT_instance::my_set_intersect(set<int> s1,set<int> s2,set<int> & res)
{
	for(set<int>::iterator itr1=s1.begin();itr1!=s1.end();++itr1) {
		if(s2.find(*itr1)!=s2.end())
			res.insert(*itr1);
	}
}

void SAT_instance::my_set_sub(set<int> s1,set<int> s2,set<int> & res)
{
	for(set<int>::iterator itr1=s1.begin();itr1!=s1.end();++itr1) {
		if(s2.find(*itr1)==s2.end())
			res.insert(*itr1);
	}
}

void SAT_instance::my_set_permutation(set<int> s1,set<int> s2,set<int> & res)
{
	for(set<int>::iterator itr1=s1.begin();itr1!=s1.end();++itr1) {
		assert(res.find(*itr1)==res.end()); //this should not in it
		if(s2.find(*itr1)==s2.end())
			res.insert(*itr1);
	}
}

void SAT_instance::my_set_permutation_elem(set<int> s1,int s2,set<int> & res)
{
	set<int> newTOTRYSRC;
	set<int> tmp;
	tmp.insert(s2);
	my_set_permutation(s1,tmp,newTOTRYSRC);
	res.clear();
	res=newTOTRYSRC;
	newTOTRYSRC.clear();
}


void SAT_instance::backward_gates_extraction(int init_varnum,set<vector <int> > init_clauseset) 
{
    ofstream resulting_dual_head;
    ofstream resulting_dual;
    ofstream resulting_dual_wire;
    resulting_dual_head.open("resulting_dual_cnf_head.v");
    resulting_dual.open("resulting_dual_cnf_body.v");
    resulting_dual_wire.open("resulting_dual_cnf_wire.v");
    
    print_dual_head(resulting_dual_head,resulting_dual);
    
    map<int, set<int> > dependent;
    ifstream dependent_in ("dependent", ios::in);
    if (!dependent_in) {
	cerr << "Can't open input file dependent"<< endl;
	exit(1);
    }
    char line_buffer[MAX_LINE_LENGTH];
    //read in the depedent file
    while(dependent_in.getline(line_buffer, MAX_LINE_LENGTH)) {
    	int dst;
	set<int> srcset;
	sscanf (line_buffer, "%d ========  ", &dst);
	int src;
	cout<<dst<<endl;

	char * cp=line_buffer;
	//skip dst
	while(*cp!=' ') cp++;
	//skip blank
	while(*cp==' ') cp++;
	//skip ========
	while(*cp=='=') cp++;
	//skip blank
	while(*cp==' ') cp++;
	while(*cp!='\n' && *cp!='\r' && *cp!='\0') {
		sscanf (cp, "%d", &src);
		srcset.insert(src);
		
		//skip current number
		while(*cp!=' ') {
			if(*cp=='\n' || *cp=='\r' || *cp=='\0') break;
			cp++;
		}
		//skip blank
		while(*cp==' ') cp++;
	}
	dependent.insert(pair<int , set<int> > (dst,srcset));
    }
	//display the depedent file content
	for(map<int, set<int> >::iterator itr=dependent.begin();itr!=dependent.end();itr++) {
		int dst=(*itr).first;
		set<int> src=(*itr).second;
		
		cout <<dst<<" ======== ";
		for(set<int>::iterator it1=src.begin();it1!=src.end();it1++) {
			cout << " " << *it1 ;
		}
		cout<<endl;
	}

	for(map<int, set<int> >::iterator itr=dependent.begin();itr!=dependent.end();itr++) {
		int totry=(*itr).first;
		set<int> POTDEC_reduce=(*itr).second;
		
		cout <<totry<<" XXXX ";
		for(set<int>::iterator it1=POTDEC_reduce.begin();it1!=POTDEC_reduce.end();it1++) {
			cout << " " << *it1 ;
		}
		//try to find out the solution
		if(print_dual(totry,POTDEC_reduce,resulting_dual,resulting_dual_wire,init_varnum,init_clauseset)==0) {
			cout << " fail" ;
		}
		cout<<endl;
		
		cout<<"run time "<<get_cpu_time()-start_time<<endl;
	}

    print_dual_tail(resulting_dual);

	resulting_dual_head.close();
	resulting_dual.close();
	resulting_dual_wire.close();

	system("cat resulting_dual_cnf_head.v resulting_dual_cnf_wire.v resulting_dual_cnf_body.v > resulting_dual_cnf.v");
}


void SAT_instance::print_dual_head (ofstream & resulting_dual_head,ofstream & resulting_dual) 
{
	//I only support len==1 case,
	//and I also suspect that it is enough for all case
	//when I consider the forward search issue
	assert(len==1);
	resulting_dual_head<<"module resulting_dual("<<endl;
	for(set<inout4rev_cz>::iterator itr=in_name_leftright_set.begin();itr!=in_name_leftright_set.end();++itr) {
		resulting_dual_head<<"   "<< (*itr).name <<" , " <<endl;
	}
	for(set<inout4rev_cz>::iterator itr=out_name_leftright_set.begin();itr!=out_name_leftright_set.end();++itr) {
		resulting_dual_head<<"   "<< (*itr).name <<" , " <<endl;
	}
	resulting_dual_head<<"   clk"<< endl;
	resulting_dual_head<<");"<<endl;
	
	for(set<inout4rev_cz>::iterator itr=in_name_leftright_set.begin();itr!=in_name_leftright_set.end();++itr) {
		if((*itr).left==-1) {
			assert((*itr).right==-1);
			resulting_dual_head<<"  output "<< (*itr).name <<" ; "<<endl;
		} else {
			resulting_dual_head<<"  output ["<<(*itr).left<<":"<<(*itr).right<<"] "<< (*itr).name <<" ; "<<endl;
		}
	}
	for(set<inout4rev_cz>::iterator itr=out_name_leftright_set.begin();itr!=out_name_leftright_set.end();++itr) {
		if((*itr).left==-1) {
			assert((*itr).right==-1);
			resulting_dual_head<<"  input "<< (*itr).name <<" ; "<<endl;
			resulting_dual_head<<"  wire  "<< (*itr).name <<"_shengyushen_last_0 ; "<<endl;
		} else {
			resulting_dual_head<<"  input  ["<<(*itr).left<<":"<<(*itr).right<<"] "<< (*itr).name <<" ; "<<endl;
			resulting_dual_head<<"  wire   ["<<(*itr).left<<":"<<(*itr).right<<"] "<< (*itr).name <<"_shengyushen_last_0 ; "<<endl;
		}
	}
	resulting_dual<<"  input  clk ; "<<endl;
	
	//printing regs
	/*for(int i=1;i<final_index_oneinst*(prefix+dly+len);i++) {
		resulting_dual<<"   reg v"<<i<<" ; "<<endl;
	}*/
	for(set<string>::iterator itr=inname_2dualsyn_flatidx_lst.begin();itr!=inname_2dualsyn_flatidx_lst.end();++itr) {
		resulting_dual_head<<"  wire v" <<src_name2idx[*itr]+prefix*final_index_oneinst<<" ; "<<endl;
	}
	for(set<string>::iterator itr=outname_2dualsyn_flatidx_lst.begin();itr!=outname_2dualsyn_flatidx_lst.end();++itr) {
		resulting_dual_head<<"  wire v"<<src_name2idx[*itr]+final_index_oneinst*(prefix+dly+len-1)<<" ; "<<endl;
	}
	
	//print the forward search registers
	for(int ii=1;ii<=forward;ii++) {
		for(set<inout4rev_cz>::iterator itr=out_name_leftright_set.begin();itr!=out_name_leftright_set.end();++itr) {
			//from forward ii-1 to forward ii
			if((*itr).left==-1) {
				assert((*itr).right==-1);
				resulting_dual_head<<"  reg "<< (*itr).name <<"_shengyushen_last_"<<ii<<" ; "<<endl;
			} else {
				resulting_dual_head<<"  reg  ["<<(*itr).left<<":"<<(*itr).right<<"] "<< (*itr).name <<"_shengyushen_last_"<<ii<<" ; "<<endl;
			}
		
			//from forward to v*
			int cycle=prefix + dly - ii;
			if((*itr).left==-1) {
				assert((*itr).right==-1);
				resulting_dual_head<<"  wire v"<< src_name2idx[(*itr).name]+ cycle*final_index_oneinst <<" ; "<<endl;
			} else {
				if(((*itr).left)>((*itr).right)) {
					for(int tt=((*itr).left);tt>=((*itr).right);tt--) {
						char sdf[80];
						sprintf(sdf,"%s[%d]",(*itr).name.c_str(),tt);
						
						resulting_dual_head<<"  wire v"<< src_name2idx[sdf]+ cycle*final_index_oneinst <<" ; "<<endl;
					}
				} else {
					for(int tt=((*itr).left);tt<=((*itr).right);tt++) {
						char sdf[80];
						sprintf(sdf,"%s[%d]",(*itr).name.c_str(),tt);
						
						resulting_dual_head<<"  wire v"<< src_name2idx[sdf]+ cycle*final_index_oneinst <<" ; "<<endl;
					}
				}
				
			}
		}
	}
	//print the assignment of input wire
	resulting_dual<<endl<<"  //the assignment of input wire"<<endl;
	for(set<inout4rev_cz>::iterator itr=out_name_leftright_set.begin();itr!=out_name_leftright_set.end();++itr) {
		if((*itr).left==-1) {
			assert((*itr).right==-1);
			resulting_dual<<"  assign  "<< (*itr).name <<"_shengyushen_last_0 =" << (*itr).name <<" ; "<<endl;
		} else {
			int minlr=min((*itr).left,(*itr).right);
			int maxlr=max((*itr).left,(*itr).right);
			for(int ii=minlr;ii<=maxlr;ii++) {
				resulting_dual<<"  assign "<< (*itr).name <<"_shengyushen_last_0["<<ii<<"] ="<< (*itr).name <<"["<<ii<<"] ; "<<endl;
			}
		}
	}
	
	//print the assignment of registers
	resulting_dual<<endl<<"  //the assignment of regs"<<endl;
	for(int ii=1;ii<=forward;ii++) {
		for(set<inout4rev_cz>::iterator itr=out_name_leftright_set.begin();itr!=out_name_leftright_set.end();++itr) {
			resulting_dual<<"  always @(posedge clk) begin"<<endl;
			int minlr=min((*itr).left,(*itr).right);
			int maxlr=max((*itr).left,(*itr).right);
			for(int iii=minlr;iii<=maxlr;iii++) {
				resulting_dual<<"           "<< (*itr).name <<"_shengyushen_last_"<<ii<<"["<<iii<<"] <= "<< (*itr).name <<"_shengyushen_last_"<<(ii-1) <<"["<<iii<<"] ; "<<endl;
			}
			resulting_dual<<"  end"<<endl;
			
			//from forward to v*
			int cycle=prefix + dly - ii;
			if((*itr).left==-1) {
				assert((*itr).right==-1);
				resulting_dual<<"  assign     v"<< src_name2idx[(*itr).name]+ cycle*final_index_oneinst <<" = "<< (*itr).name <<"_shengyushen_last_"<<ii<<" ; "<<endl;
			} else {
				if(((*itr).left)>((*itr).right)) {
					for(int tt=((*itr).left);tt>=((*itr).right);tt--) {
						char sdf[80];
						sprintf(sdf,"%s[%d]",(*itr).name.c_str(),tt);
						
						resulting_dual<<"  assign      v"<< src_name2idx[sdf]+ cycle*final_index_oneinst <<" = "<< (*itr).name <<"_shengyushen_last_"<<ii<<"["<< tt <<"] ; "<<endl;
					}
				} else {
					for(int tt=((*itr).left);tt<=((*itr).right);tt++) {
						char sdf[80];
						sprintf(sdf,"%s[%d]",(*itr).name.c_str(),tt);
						
						resulting_dual<<"   assign     v"<< src_name2idx[sdf]+ cycle*final_index_oneinst <<" = "<< (*itr).name <<"_shengyushen_last_"<<ii<<"["<< tt <<"] ; "<<endl;
					}
				}
				
			}
		}
	}
}	


void SAT_instance::ReduceSolution_1by1_UNSAT(set<int> POTDEC_reduce,set< vector<int> > init_clauseset_simp,int init_varnum,int totry,map<int,int> idx2value,set<int> & remain_reduce)
{
			set<int> remain=POTDEC_reduce;
			while(remain.empty()!=true) {
				//moving following segment up to before while
				//will make it incorrect, so what is the wrong??
				////////////////////////////////////////////////
				//initial sat solver
				SAT_Manager mng_reduce;
				assert(init_clauseset_simp.size()!=0);
				assert(init_varnum!=0);
				initial_sat_solver(mng_reduce,init_clauseset_simp,init_varnum);
						
				//totry == 0
				{
					vector<int> restmp;
					restmp.push_back(neg(totry<<1));
					assert(restmp.size()==1);
					//cout<<" totry"<<totry<< " "<<neg(totry<<1)<<endl;
					add_cls_vector(mng_reduce, restmp);
				}

				assert(remain.size()+remain_reduce.size()!=0);
				//the item to be test
				int totest_remove=*(remain.begin());
				remain.erase(remain.begin());
				
				int gidxx=SAT_AllocClauseGroupID(mng_reduce);
				//adding the value
				for(set<int>::iterator itr=remain.begin();itr!=remain.end();itr++) {
					int idx=*itr;
					int v=idx2value[idx];
					assert(v==0||v==1);
					vector<int> restmp1;
					int lit=(v==0)?(neg(idx<<1)):(pos(idx<<1));
					restmp1.push_back(lit);
					add_cls_vector(mng_reduce, restmp1,gidxx);
					//cout<<" remain "<<idx<<" "<<v<<" "<<lit<<endl;
				}
				for(set<int>::iterator itr=remain_reduce.begin();itr!=remain_reduce.end();itr++) {
					int idx=*itr;
					int v=idx2value[idx];
					assert(v==0||v==1);
					vector<int> restmp1;
					int lit=(v==0)?(neg(idx<<1)):(pos(idx<<1));
					restmp1.push_back(lit);
					add_cls_vector(mng_reduce, restmp1,gidxx);
					//cout<<" remain_reduce "<<idx<<" "<<v<<" "<<lit<<endl;
				}
				
				SAT_Reset(mng_reduce);
				//cout<<"before SAT_Solve "<<get_cpu_time()-current_time<<endl;
				//int satres1=SAT_Solve(mng_reduce);
				int * result_pointer;
				int   result_size;
				int satres1=SAT_Solve_ssy(mng_reduce,gidxx,&result_pointer,&result_size,totry);
				//cout<<"after  SAT_Solve "<<get_cpu_time()-current_time<<endl;
				if(satres1==SATISFIABLE) {
					//totest_remove can not be removed, add it back
					remain_reduce.insert(totest_remove);
					//cout<<"   not removed "<<totest_remove<<endl;
				} else {
					assert(satres1==UNSATISFIABLE);
					//cout<<"   removed "<<totest_remove<<endl;
					
					set< vector<int> > clauseset;
					vector<int> clstt;
					for(int i=0;i<result_size;i++) {
						if(result_pointer[i]!=0) 
							clstt.push_back(result_pointer[i]);
						else {
							clauseset.insert(clstt);
							clstt.clear();
						}
					}
				
					set<int> new_remain;
					for(set< vector<int> >::iterator itr=clauseset.begin();itr!=clauseset.end();itr++) {
						vector<int> cl=*itr;
						assert(cl.size()==1);
						int lit=*(cl.begin());
						int varidx=lit>>1;
						if(remain_reduce.find(varidx)==remain_reduce.end()) {
							if(remain.find(varidx)!=remain.end()) {
								new_remain.insert(varidx);
							} else {
								assert(varidx==totest_remove);
							}
								
						}
					}
					clauseset.clear();
					remain.clear();
					remain=new_remain;
					new_remain.clear();
				}
				
				//SAT_DeleteClauseGroup(mng_reduce,gidxx);
				deletel_sat_solver(mng_reduce);
			}
}

int SAT_instance::ReduceSolution_xor(set<int> POTDEC_reduce,set< vector<int> > init_clauseset_simp,int init_varnum,int totry,map<int,int> & idx2value,set<int> & remain_reduce,list<xor_operation> & xor_ops)
{
	set<int> remain=POTDEC_reduce;
	int number_of_var=init_varnum;
	int increase_var_number=0;
	int change=0;
	cout<<"init number_of_var "<<number_of_var<<endl;
	number_of_var++;
	int new_xor_res=number_of_var;
	
	while(remain.empty()!=true) {
		cout<<"remain size "<<remain.size()<<endl;
		change=0;
		//the item to be test
		int totest_remove=*(remain.begin());
		remain.erase(remain.begin());
		cout<<" totest_remove "<<totest_remove<<endl;
		
		//we assume that the POTDEC_reduce is already reduced by kravi style procedure
		for(set<int>::iterator itr=remain.begin();itr!=remain.end();itr++) {
			int idx=*itr;
			if(idx!=totest_remove) {
				cout<<"    idx "<<idx<<endl;
				//test if idx and totest_remove exclusive to each other
				////////////////////////////////////////////////
				//initial sat solver
				SAT_Manager mng_reduce;
				assert(init_clauseset_simp.size()!=0);
				assert(init_varnum!=0);
				initial_sat_solver(mng_reduce,init_clauseset_simp,number_of_var);
				
				//totry == 0
				{
					vector<int> restmp;
					restmp.push_back(neg(totry<<1));
					assert(restmp.size()==1);
					cout<<" totry "<<totry<< " "<<neg(totry<<1)<<endl;
					add_cls_vector(mng_reduce, restmp);
				}
				assert(remain.size()+remain_reduce.size()!=0);
		
				int gidxx=SAT_AllocClauseGroupID(mng_reduce);
				
				//add assignment of all relevant vars . except totest_remove and idx
				for(set<int>::iterator itr_111=remain.begin();itr_111!=remain.end();itr_111++) {
					int idx_111=*itr_111;
					if(idx_111==idx || idx_111==totest_remove) continue;
					cout<<" remain "<<idx_111<<" "<<idx2value[idx_111]<<endl;
					add_const_constraint(mng_reduce,idx_111,idx2value,gidxx);
				}
				for(set<int>::iterator itr_111=remain_reduce.begin();itr_111!=remain_reduce.end();itr_111++) {
					int idx_111=*itr_111;
					if(idx_111==idx || idx_111==totest_remove) continue;
					cout<<" remain_reduce "<<idx_111<<" "<<idx2value[idx_111]<<endl;
					add_const_constraint(mng_reduce,idx_111,idx2value,gidxx);
				}
				
				//add the xors in xor_ops
				for(list<xor_operation>::iterator itr_111=xor_ops.begin();itr_111!=xor_ops.end();itr_111++) {
					int rev1=(*itr_111).op1;
					int rev2=(*itr_111).op2;
					int res=(*itr_111).res;
					
					cout<<" xor_ops "<<rev1<<" "<<idx2value[rev1]<<" "<<rev2<<" "<<idx2value[rev2]<<" "<<res<<" "<<idx2value[res]<<endl;
					xor2(mng_reduce,rev1<<1,rev2<<1,res<<1,gidxx);
					//we dont need this
					//add_xor_result_constraint(mng_reduce,rev1,rev2,res,idx2value,gidxx);
				}
				
				//add the xor of totest_remove and idx
				xor2(mng_reduce,totest_remove<<1,idx<<1,new_xor_res<<1,gidxx);
				int value_new_xor_res=add_xor_result_constraint(mng_reduce,totest_remove,idx,new_xor_res,idx2value,gidxx);
				
				SAT_Reset(mng_reduce);
				int satres1=SAT_Solve(mng_reduce);
				//cout<<"after  SAT_Solve "<<get_cpu_time()-current_time<<endl;
				if(satres1==SATISFIABLE) {
					//xor of totest_remove and idx can't determine the object
					// so we cant replace totest_remove and idx with their xor
					//remain_reduce.insert(totest_remove);
					cout<<"   SATISFIABLE "<<endl;
					deletel_sat_solver(mng_reduce);
				} else {
					assert(satres1==UNSATISFIABLE);
					cout<<"   UNSATISFIABLE "<<endl;
					// ok to replace totest_remove and idx with their xor
					idx2value.insert(pair<int,int>(new_xor_res,value_new_xor_res));
					remain.insert(new_xor_res);
					remain.erase(itr);
					
					struct xor_operation xorop;
					xorop.op1=totest_remove;
					xorop.op2=idx;
					xorop.res=new_xor_res;
					xor_ops.push_back(xorop);
					
					cout<<" xor merge ";
					int value=idx2value[totest_remove];
					if(value==0) cout<<"-";
					cout<<totest_remove<<" and " ;
					value=idx2value[idx];
					if(value==0) cout<<"-";
					cout<< idx<<" to ";
					value=idx2value[new_xor_res];
					if(value==0) cout<<"-";
					cout<<new_xor_res<<endl;

					new_xor_res++;
					number_of_var++;
					increase_var_number++;
					
					deletel_sat_solver(mng_reduce);
					change=1;
					
					
					break;
				}
		
			}
		}
		
		if(change==0) {
			//totest_remove can't be xored with others
			remain_reduce.insert(totest_remove);
		}
	}
	
	return increase_var_number;
}

void SAT_instance::ReduceSolution_1by1(set<int> POTDEC_reduce,set< vector<int> > init_clauseset_simp,int init_varnum,int totry,map<int,int> idx2value,set<int> & remain_reduce)
{
	set<int> remain=POTDEC_reduce;
	while(remain.empty()!=true) {
		//moving following segment up to before while
		//will make it incorrect, so what is the wrong??
		////////////////////////////////////////////////
		//initial sat solver
		SAT_Manager mng_reduce;
		assert(init_clauseset_simp.size()!=0);
		assert(init_varnum!=0);
		initial_sat_solver(mng_reduce,init_clauseset_simp,init_varnum);
				
		//totry == 0
		{
			vector<int> restmp;
			restmp.push_back(neg(totry<<1));
			assert(restmp.size()==1);
			//cout<<" totry"<<totry<< " "<<neg(totry<<1)<<endl;
			add_cls_vector(mng_reduce, restmp);
		}
		assert(remain.size()+remain_reduce.size()!=0);
		//the item to be test
		int totest_remove=*(remain.begin());
		remain.erase(remain.begin());
				
		int gidxx=SAT_AllocClauseGroupID(mng_reduce);
		//adding the value
		for(set<int>::iterator itr=remain.begin();itr!=remain.end();itr++) {
			int idx=*itr;
			int v=idx2value[idx];
			assert(v==0||v==1);
			vector<int> restmp1;
			int lit=(v==0)?(neg(idx<<1)):(pos(idx<<1));
			restmp1.push_back(lit);
			add_cls_vector(mng_reduce, restmp1,gidxx);
			//cout<<" remain "<<idx<<" "<<v<<" "<<lit<<endl;
		}
		for(set<int>::iterator itr=remain_reduce.begin();itr!=remain_reduce.end();itr++) {
			int idx=*itr;
			int v=idx2value[idx];
			assert(v==0||v==1);
			vector<int> restmp1;
			int lit=(v==0)?(neg(idx<<1)):(pos(idx<<1));
			restmp1.push_back(lit);
			add_cls_vector(mng_reduce, restmp1,gidxx);
			//cout<<" remain_reduce "<<idx<<" "<<v<<" "<<lit<<endl;
		}
				
		SAT_Reset(mng_reduce);
		//cout<<"before SAT_Solve "<<get_cpu_time()-current_time<<endl;
		int satres1=SAT_Solve(mng_reduce);
		//cout<<"after  SAT_Solve "<<get_cpu_time()-current_time<<endl;
		if(satres1==SATISFIABLE) {
			//totest_remove can not be removed, add it back
			remain_reduce.insert(totest_remove);
			//cout<<"   not removed "<<totest_remove<<endl;
		} else {
			assert(satres1==UNSATISFIABLE);
			//cout<<"   removed "<<totest_remove<<endl;
		}
		
		//SAT_DeleteClauseGroup(mng_reduce,gidxx);
		deletel_sat_solver(mng_reduce);
	}
}

void SAT_instance::ReduceSolution_UnsatCore(set<int> POTDEC_reduce,set< vector<int> > init_clauseset_simp,int init_varnum,int totry,map<int,int> idx2value,set<int> & remain_reduce)
{
			set<int> remain=POTDEC_reduce;
			//reduce by UNSAT core extraction
			while(1){
				//initial sat solver
				SAT_Manager mng_reduce;
				assert(init_clauseset_simp.size()!=0);
				assert(init_varnum!=0);
				initial_sat_solver(mng_reduce,init_clauseset_simp,init_varnum);

				//totry == 0
				{
					vector<int> restmp;
					restmp.push_back(neg(totry<<1));
					assert(restmp.size()==1);
					//cout<<" totry"<<totry<< " "<<neg(totry<<1)<<endl;
					add_cls_vector(mng_reduce, restmp);
				}

				int gidxx=SAT_AllocClauseGroupID(mng_reduce);
				assert(remain.size()!=0);
				//cout<<"remain size "<<remain.size()<<endl;
				//adding the value
				for(set<int>::iterator itr=remain.begin();itr!=remain.end();itr++) {
					int idx=*itr;
					int v=idx2value[idx];
					assert(v==0||v==1);
					vector<int> restmp1;
					int lit=(v==0)?(neg(idx<<1)):(pos(idx<<1));
					restmp1.push_back(lit);
					add_cls_vector(mng_reduce, restmp1,gidxx);
					//cout<<" remain "<<idx<<" "<<v<<" "<<lit<<endl;
				}

				SAT_Reset(mng_reduce);
				//cout<<"before SAT_Solve "<<get_cpu_time()-current_time<<endl;

				int * result_pointer;
				int   result_size;
				int satres1=SAT_Solve_ssy_unsat(mng_reduce,gidxx,&result_pointer,&result_size,totry);
				assert(satres1==UNSATISFIABLE);
				
				//convert array of ints that seperated by 0 into multiple clauses
				{
					set< vector<int> > clauseset;
					vector<int> clstt;
					for(int i=0;i<result_size;i++) {
						if(result_pointer[i]!=0) 
							clstt.push_back(result_pointer[i]);
						else {
							clauseset.insert(clstt);
							clstt.clear();
						}
					}
				
					for(set< vector<int> >::iterator itr=clauseset.begin();itr!=clauseset.end();itr++) {
						vector<int> cl=*itr;
						assert(cl.size()==1);
						int lit=*(cl.begin());
						int varidx=lit>>1;
						remain_reduce.insert(varidx);
						assert(remain.find(varidx)!=remain.end());
					}
					clauseset.clear();
				}
				
				if(remain.size()==remain_reduce.size()) {
					deletel_sat_solver(mng_reduce);
					break;
				} else {
					assert(remain.size()>remain_reduce.size());
					remain.clear();
					remain=remain_reduce;
					remain_reduce.clear();
				}
				
				//SAT_DeleteClauseGroup(mng_reduce,gidxx);
				deletel_sat_solver(mng_reduce);
			}
}

int SAT_instance::print_dual (int totry,set<int> POTDEC_reduce,ofstream & resulting_dual,ofstream & resulting_dual_wire,int  init_varnum,set<vector <int> > init_clauseset) 
{
	double current_time=get_cpu_time();
	int init_varnum_save=init_varnum;
	
	set< vector<int> > init_clauseset_simp;
	//the following two statement can only use one
	simpilfy_instance(      totry,POTDEC_reduce,init_varnum,init_clauseset,init_clauseset_simp);
	cout<<"after simpilfy_instance "<<get_cpu_time()-current_time<<endl;
	//init_clauseset_simp=init_clauseset;

	//cout<<"after simpilfy_instance "<<get_cpu_time()-current_time<<endl;
	//it seems that we can't run the simpilfy_instance more than once
	/*{
		set< vector<int> > init_clauseset_orig=init_clauseset;
		while(true) {
			simpilfy_instance(      totry,POTDEC_reduce,init_varnum,init_clauseset_orig,init_clauseset_simp);
			cerr<<"init_clauseset_simp size "<<init_clauseset_simp.size()<<endl;
			if(init_clauseset_orig.size()>init_clauseset_simp.size()) {
				init_clauseset_orig=init_clauseset_simp;
			} else {
				assert(init_clauseset_orig.size()==init_clauseset_simp.size());
				break;
			}
		}
	}*/
	//check_simpilfy_instance(totry,POTDEC_reduce,init_varnum,init_clauseset,init_clauseset_simp);
	SAT_Manager mng;
	//here we must use init_clauseset instead of init_clauseset_simp
	//because the latter one is lack of some neccessary constrain, 
	//to rule out improper solutions
	assert(init_clauseset.size()!=0);
	assert(init_varnum!=0);
	initial_sat_solver(mng,init_clauseset,init_varnum);

	{
		vector<int> res;
		//totry == 1
		res.push_back(pos(totry<<1));
		assert(res.size()==1);
		add_cls_vector(mng, res);
		res.clear();
	}

	list<xor_operation> xor_ops_all;
	set< vector<int> > blkcls_set;
	bool const0=true;
	while(1) {
		SAT_Reset(mng);
		int satres=SAT_Solve(mng);
		cout<<"after SAT_Solve "<<get_cpu_time()-current_time<<endl;
		if(satres==UNSATISFIABLE) {//no more cases
			break;
		} else {
			assert(satres==SATISFIABLE);
			
			//find the values
			map<int,int> idx2value;
			for(set<int>::iterator itr=POTDEC_reduce.begin();itr!=POTDEC_reduce.end();itr++) {
				int varid=*itr;
				int v=SAT_GetVarAsgnment(mng, varid);
				assert(v==0||v==1);
				//cout<<"    "<<varid<<" = "<<v<<endl;
				idx2value.insert(pair<int,int>(varid,v));
			}

			set<int> remain_reduce;

			ReduceSolution_1by1_UNSAT(POTDEC_reduce,init_clauseset_simp,init_varnum,totry,idx2value,remain_reduce);

			cout<<" after ReduceSolution_1by1 "<<get_cpu_time()-current_time<<endl;
			for(set<int>::iterator itr=remain_reduce.begin();itr!=remain_reduce.end();itr++) {
				int varid=*itr;
				int v=SAT_GetVarAsgnment(mng, varid);
				assert(v==0||v==1);
				cout<<" ";
				if(v==0) cout<<"-";
				cout<<varid;
			}
			cout<<endl;
			
			if(remain_reduce.empty()==false) {

				set<int> remain_reduce2;
				list<xor_operation> xor_ops;
				int increase_var_number=ReduceSolution_xor(remain_reduce,init_clauseset_simp,init_varnum,totry,idx2value,remain_reduce2,xor_ops);
				cout<<" after ReduceSolution_xor "<<get_cpu_time()-current_time<<endl;
				//alloc var for those new xor result
				for(int i=0;i<increase_var_number;i++) {
					int varid=SAT_AddVariable(mng);
					init_varnum++;
					assert(varid==init_varnum);
					cout<<" varid "<<varid<<" init_varnum "<<init_varnum<<endl;
				}
			
				{
					remain_reduce=remain_reduce2;
					assert(remain_reduce.empty()==false);

					//xor constraints
					for(list<xor_operation>::iterator itr=xor_ops.begin();itr!=xor_ops.end();itr++) {
						struct xor_operation xop=*itr;
						int op1=xop.op1;
						int op2=xop.op2;
						int res=xop.res;
						cout<<" xor constraint "<<op1<<" "<<op2<<" "<<res<<" totry "<<totry<<endl;
						xor2(mng,op1<<1,op2<<1,res<<1,0);
					
						//add them to xor_ops_all
						xor_ops_all.push_back(xop);
					}
				
					//blocking clause
					cout<<endl;
					vector<int> newblk_cls;
					for(set<int>::iterator itr=remain_reduce.begin();itr!=remain_reduce.end();itr++) {
						int varid=*itr;
						int v=idx2value[varid];
						assert(v==0||v==1);
						newblk_cls.push_back((varid<<1)+v);
						if(v==0) {
							cout<<" -"<<varid;
						} else {
							assert(v==1);
							cout<<" "<<varid;
						}
					}
					cout<<endl;
					remain_reduce.clear();
					add_cls_vector(mng, newblk_cls);
					blkcls_set.insert(newblk_cls);
			
					cout<<"get one solution "<<get_cpu_time()-current_time<<endl;
				}
				
			} else {//totry must be 1 now
				assert(xor_ops_all.empty());
				assert(blkcls_set.empty());
				//it must be the first solution
				const0=false;
				break;
			}
				
			/*if(get_cpu_time()-current_time>timeout_nl_const) {
				deletel_sat_solver(mng);
				return 0;
			}*/
		}
	}
	
	deletel_sat_solver(mng);


	//now print the circuits
	if(blkcls_set.empty()) {
		assert(xor_ops_all.empty());
		//this may be const 0 or 1
		if(const0==true) {
			resulting_dual_wire<<"   wire "<<"const0_"<<totry<<"=1'b0;"<<endl;
			resulting_dual << " assign   v"<<totry<<"="<<"const0_"<<totry<<";"<<endl<<endl;
		}else{
			resulting_dual_wire<<"   wire "<<"const1_"<<totry<<"=1'b1;"<<endl;
			resulting_dual << " assign   v"<<totry<<"="<<"const1_"<<totry<<";"<<endl<<endl;
		}
	
	}else {
	
		//first print the list of additional wire for xor
		for(list<xor_operation>::iterator itr=xor_ops_all.begin();itr!=xor_ops_all.end();itr++) {
			struct xor_operation xop=*itr;
			int res=xop.res;
			resulting_dual_wire<<"   wire "<<"v"<<res<<"_localxor_v"<<totry<<";"<<endl;
		}
	
		//next prepare the list of signals to be used in always statement
		/*set<int> sensitive_set;
		for(set< vector<int> >::iterator itr=blkcls_set.begin();itr!=blkcls_set.end();itr++) {
			vector<int> blkcls=*itr;
			for(vector<int>::iterator itr1=blkcls.begin();itr1!=blkcls.end();itr1++) {
				int var=(*itr1)>>1;
				if(var!=totry)
					sensitive_set.insert(var);
			}
		}
		//print the sensitive list
		resulting_dual << "always @ (";
		for(set<int>::iterator itr=sensitive_set.begin();itr!=sensitive_set.end();++itr) {
			set<int>::iterator itr1=itr;
			itr1++;

			if((*itr)>init_varnum_save) 
				resulting_dual << " v"<<*itr<<"_localxor_v"<<totry;
			else 
				resulting_dual << " v"<<*itr;

			resulting_dual <<" ";
			if(itr1!=sensitive_set.end())
				resulting_dual <<" or ";
		}
		resulting_dual << " ) begin"<<endl;*/

		//print the block clause that represent the assignements that lead to totry=1

		resulting_dual<<"  assign      v"<<totry<<" = ";
		bool first_case=true;
		for(set<vector<int> >::iterator itr=blkcls_set.begin();itr!=blkcls_set.end();itr++) {
			vector<int> blkcls=*itr;
			if(first_case==true) {
				first_case=false;
				resulting_dual<<"    (";
			}else {
				resulting_dual<<"   |  ( ";
			}

			for(vector<int>::iterator itr1=blkcls.begin();itr1!=blkcls.end();itr1++) {
				int lit=*itr1;
				int var=lit>>1;
				int value=lit-var*2;
				
				if(value==0) resulting_dual<<" !";
			
				if(var>init_varnum_save) 
					resulting_dual << "v"<<var<<"_localxor_v"<<totry;
				else 
					resulting_dual << "v"<<var;
				
				
				vector<int>::iterator itr2=itr1;
				itr2++;
				if(itr2==blkcls.end())
					resulting_dual<<" ";
				else
					resulting_dual<<" & ";
			
			}
		
			resulting_dual<<" ) ";
		}
		resulting_dual<<" ; "<<endl;

	
		/*resulting_dual<<"   )"<<endl;
		resulting_dual<<"        v"<<totry<<"<=1'b1;"<<endl;
		resulting_dual<<"   else"<<endl;
		resulting_dual<<"        v"<<totry<<"<=1'b0;"<<endl;
		resulting_dual << "end"<<endl<<endl;*/
	
		//I still need to output the xor list
		for(list<xor_operation>::iterator itr=xor_ops_all.begin();itr!=xor_ops_all.end();itr++) {
			struct xor_operation xop=*itr;
			int op1=xop.op1;
			int op2=xop.op2;
			int res=xop.res;
			resulting_dual<<"assign v"<<res<<"_localxor_v"<<totry<<" = ";
		
			if(op1>init_varnum_save) 
				resulting_dual << " v"<<op1<<"_localxor_v"<<totry;
			else 
				resulting_dual << " v"<<op1;
		
			resulting_dual<<" ^ ";

			if(op2>init_varnum_save) 
				resulting_dual << " v"<<op2<<"_localxor_v"<<totry;
			else 
				resulting_dual << " v"<<op2;
		
			resulting_dual<<" ;"<<endl;
		
		
		}
	}
	
	return 1;
}


void SAT_instance::print_dual_tail (ofstream & resulting_dual) 
{
	for(set<string>::iterator itr=inname_2dualsyn_flatidx_lst.begin();itr!=inname_2dualsyn_flatidx_lst.end();++itr) {
		resulting_dual<<"  assign "<< *itr<< " = v" <<src_name2idx[*itr]+prefix*final_index_oneinst<<" ; "<<endl;
	}
	for(set<string>::iterator itr=outname_2dualsyn_flatidx_lst.begin();itr!=outname_2dualsyn_flatidx_lst.end();++itr) {
		resulting_dual<<"  assign   v"<<src_name2idx[*itr]+final_index_oneinst*(prefix+dly+len-1)<<" = "<< *itr <<" ; "<<endl;
	}
	
	resulting_dual<<"endmodule"<<endl;
	resulting_dual.close();
}

int SAT_instance::solve_ssy(int  init_varnum,set<vector <int> > init_clauseset)
{
    //assert(final_index_oneinst*(dly+len)*2-1==num_variables());
    cout << "dly "<<dly<<endl;
    cout << "len "<<len<<endl;
    cout << "prefix "<<prefix<<endl;
    cout << "forward "<<forward<<endl;
    //generate the I and O set for multiple instance in single copy
    for(set<string>::iterator itr= inname_2dualsyn_flatidx_lst.begin();itr!= inname_2dualsyn_flatidx_lst.end();++itr) {
	for(int ii=prefix;ii<prefix+len;ii++)
		I.insert(src_name2idx[*itr]+ii*final_index_oneinst);
    }
    for(set<string>::iterator itr=outname_2dualsyn_flatidx_lst.begin();itr!=outname_2dualsyn_flatidx_lst.end();++itr) {
	for(int ii=prefix+dly-forward;ii<prefix+dly+len;ii++)
		O.insert(src_name2idx[*itr]+ii*final_index_oneinst);
    }

    for(set<int>::iterator itr=I.begin();itr!=I.end();++itr) {
	cout<< "IIII " << *itr << endl;
    }
    for(set<int>::iterator itr=O.begin();itr!=O.end();++itr) {
	cout<< "OOOO " << *itr << endl;
    }

    //find all point that uniquly decided by O
    /*set<int> anchor_point_set;
    find_anchor_point_set(anchor_point_set);
    cout << "final anchor set size : " << anchor_point_set.size() <<endl;
*/
    //from I search backward to decide stage by stage , the definition of each date
    backward_gates_extraction(init_varnum,init_clauseset);
    
    return 1;
}

int SAT_instance::add_const_constraint(SAT_Manager mng_reduce,int var1,map<int,int> idx2value,int gid) {
	int v_111=idx2value[var1];
	assert(v_111==0||v_111==1);
	vector<int> restmp1_111;
	int lit_111=(v_111==0)?(neg(var1<<1)):(pos(var1<<1));
	restmp1_111.push_back(lit_111);
	add_cls_vector(mng_reduce, restmp1_111,gid);
}

int SAT_instance::add_xor_result_constraint(SAT_Manager mng_reduce,int var1,int var2,int res_var,map<int,int> idx2value,int gid) {
	int value1=idx2value[var1];
	assert(value1==0 || value1==1);
	int value2=idx2value[var2];
	assert(value2==0 || value2==1);

	if(value1==value2) {//their xor should be 0
		vector<int> restmp;
		restmp.push_back(neg(res_var<<1));
		assert(restmp.size()==1);
		cout<<" add_xor_result_constraint res_var "<<res_var<< " "<<neg(res_var<<1)<<endl;
		add_cls_vector(mng_reduce, restmp,gid);
		return 0;
	} else {
		vector<int> restmp;
		restmp.push_back(pos(res_var<<1));
		assert(restmp.size()==1);
		cout<<" add_xor_result_constraint res_var "<<res_var<< " "<<pos(res_var<<1)<<endl;
		add_cls_vector(mng_reduce, restmp,gid);
		return 1;
	}
}




//when  using these function, you must <<1 on all vars
    void SAT_instance::xor2 (SAT_Manager mng,int a, int b, int o, int gid=0)
	{
    	assert((a>>1)!=(b>>1));
    	assert((a>>1)!=(o>>1));
	    // a xor b = o <==> (a' + b' + o')
	    //                  (a + b + o' )
	    //                  (a' + b + o)
	    // 	                (a + b' + o)
	    vector <int> lits;

	    lits.clear();
	    lits.push_back(neg(a));
	    lits.push_back(neg(b));
	    lits.push_back(neg(o));
	    SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);

	    lits.clear();
	    lits.push_back(pos(a));
	    lits.push_back(pos(b));
	    lits.push_back(neg(o));
	    SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);

	    lits.clear();
	    lits.push_back(neg(a));
	    lits.push_back(pos(b));
	    lits.push_back(pos(o));
	    SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);

	    lits.clear();
	    lits.push_back(pos(a));
	    lits.push_back(neg(b));
	    lits.push_back(pos(o));
	    SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
	}

    void SAT_instance::or_n (SAT_Manager mng,int * inputs, int num_input, int o, int gid=0)
	{
	    vector <int> lits;
	    int i;
	    for (i=0; i< num_input; ++i) {
		lits.clear();
		lits.push_back(neg(inputs[i]));
		lits.push_back(pos(o));
		SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
	    }
	    lits.clear();
	    for (i=0; i< num_input; ++i)
		lits.push_back(pos(inputs[i]));
	    lits.push_back(neg(o));
	    SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
	    
	}
    
    void SAT_instance::equ2(SAT_Manager mng,int a, int b, int gid=0)
    {
    	assert((a>>1)!=(b>>1));
    	vector <int> lits;
	
	lits.clear();
	lits.push_back(pos(a));
	lits.push_back(neg(b));
	SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
	
	lits.clear();
	lits.push_back(neg(a));
	lits.push_back(pos(b));
	SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
    }

    void SAT_instance::ine2(SAT_Manager mng,int a, int b, int gid=0)
    {
    	assert((a>>1)!=(b>>1));
    	vector <int> lits;
	
	lits.clear();
	lits.push_back(pos(a));
	lits.push_back(pos(b));
	SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
	
	lits.clear();
	lits.push_back(neg(a));
	lits.push_back(neg(b));
	SAT_AddClause(mng,ptr(lits.begin()), lits.size(), gid);
    }

    int * SAT_instance::ptr(vector<int>::iterator itr) {
	return &(*itr);
    }
    int SAT_instance::pos(int i) 
	{ 
	    return i;
	}
    int SAT_instance::neg(int i) 
	{
//		cerr <<"neg " << i << " " << (i^0x1)<<endl;
	    return i^0x1;
	}

