#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstdio>

#include <set>
#include <map>
#include <list>
#include <vector>
#include <string>

using namespace std;

#include <dirent.h>
#include "../MiniSat114_enhance/Solver.h"
#include "minisat_addon.h"
#include <assert.h>
#include <string.h>

#include "sat_instance.h"


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
				if( var_idx < 0)  {
					var_idx = -var_idx; 
					sign = 1; 
				}//sign ==1 means -
				clause_vars.insert(var_idx);
				clause_lits.insert( (var_idx << 1) + sign);
		   	} else {
			//add this clause
				if (clause_vars.size() != 0 && (clause_vars.size() == clause_lits.size())) { //yeah, can add this clause
					vector <int> temp;
					for (set<int>::iterator itr = clause_lits.begin();itr != clause_lits.end(); ++itr)
						temp.push_back (*itr);

					init_clauseset.insert(temp);
				} else {
					if(clause_vars.size() == 0)	{
						assert(0);
					} else {
						cout<<"clause_lits"<<endl;
						for (set<int>::iterator itr = clause_lits.begin();itr != clause_lits.end(); ++itr) {
							cout<<(*itr)<<" ";
						}
						cout<<endl<<"clause_vars"<<endl;
						for (set<int>::iterator itr = clause_vars.begin();itr != clause_vars.end(); ++itr) {
							cout<<(*itr)<<" ";
						}
						cout<<endl;
						//exit(2);
					}
					
				} //it contain var of both polarity, so is automatically satisfied, just skip it
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

	init_clauseset.insert(temp);
    }
    clause_lits.clear();
    clause_vars.clear();
//    cout <<"done read cnf"<<endl;
	sscanf(timeout_value,"%d",&timeout_nl_const);
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

void SAT_instance::initial_sat_solver(SAT_Manager & mng_2init,set< vector<int> > init_clauseset_2init,int init_varnum_2init)
{
	//first init the sat solver
	mng_2init=new Solver;
	
	//push clauses and variables into mng 
	SAT_SetNumVariables(mng_2init, init_varnum_2init);
	//assert(init_clauseset_2init.empty()!=true);
	for(set< vector<int> >::iterator itr=init_clauseset_2init.begin();itr!=init_clauseset_2init.end();++itr) {
		vector<int> temp=*itr;
		mng_2init->addClause(temp);
	}
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
	//cout<<dst<<endl;

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
/*	for(map<int, set<int> >::iterator itr=dependent.begin();itr!=dependent.end();itr++) {
		int dst=(*itr).first;
		set<int> src=(*itr).second;
		
		cout <<dst<<" ======== ";
		for(set<int>::iterator it1=src.begin();it1!=src.end();it1++) {
			cout << " " << *it1 ;
		}
		cout<<endl;
	}
*/
	SAT_Manager mng=new Solver;
	mng->proof = new Proof();
	SAT_SetNumVariables(mng,init_varnum*2+20);

	//adding the set of original clauses
	for(set<vector <int> >::iterator itr=init_clauseset.begin();itr!=init_clauseset.end();++itr) {
		//vector <int> current_cls=*itr;
		mng->addClause(*itr);
	}

	//generate the shifted cls for only once
	set<vector <int> > init_clauseset_shifted;
	set<int> POTDEC_reduce=(dependent.begin())->second;
	int lowbound=lowbound_set(POTDEC_reduce);
	int upbound=upbound_set(POTDEC_reduce);
	assert(upbound>=lowbound);
	//adding the set of shifted clauses
	// the amount of shift is init_varnum+1
	for(set<vector <int> >::iterator itr=init_clauseset.begin();itr!=init_clauseset.end();++itr) {
		vector <int> current_cls=*itr;

		for(int i=0;i<current_cls.size();i++) {
			int lit=current_cls[i];
			int varidx=lit>>1;
			assert(varidx>0);

			if(varidx>=lowbound && varidx<=upbound) {
				if(findin_set(varidx,POTDEC_reduce)==false) current_cls[i]=lit+(init_varnum+1)*2;
			}
			else current_cls[i]=lit+(init_varnum+1)*2;
		}
		init_clauseset_shifted.insert(current_cls);
	}

	//adding the set of shifted clauses
	for(set<vector <int> >::iterator itr=init_clauseset_shifted.begin();itr!=init_clauseset_shifted.end();++itr) {
		//vector <int> current_cls=*itr;
		mng->addClause(*itr);
	}

	for(map<int, set<int> >::iterator itr=dependent.begin();itr!=dependent.end();itr++) {
		int totry=(*itr).first;
		
		cout <<"characterizing "<<totry<<endl;
		//try to find out the solution
		print_dual(mng,totry,POTDEC_reduce,resulting_dual,resulting_dual_wire,init_varnum);
		
		cout<<"run time "<<get_cpu_time()-start_time<<endl;
	}
	delete mng->proof;
	delete mng;

	print_dual_tail(resulting_dual);
	
	resulting_dual_head.close();
	resulting_dual.close();
	resulting_dual_wire.close();

	system("cat resulting_dual_cnf_head.v resulting_dual_cnf_wire.v resulting_dual_cnf_body.v > resulting_dual_cnf.v");
}

int SAT_instance::print_dual (SAT_Manager mng,int totry,set<int> &POTDEC_reduce,ofstream & resulting_dual,ofstream & resulting_dual_wire,int  init_varnum) 
{
	//totry : the input variable to be characterized
	//POTDEC_reduce : sets of output variables to be character function input
	//resulting_dual : the output stream of verilog
	//init_varnum : the number of variables

	//set totry to 1 
	Lit totrylit(totry,false);
	//set shifted totry to 0
	Lit totrylit_shift((totry+init_varnum+1),true);

	vec<Lit> assump;
	assump.push(totrylit);
	assump.push(totrylit_shift);

	bool res=mng->solve(assump);//it must be unsat
	if(res==true) {
		cerr << "invalid assumption" << endl;
		exit(2);
	}

	//extract proof trace
	vec<long>& sdf=(mng->proof)->save("proofname_notused.log");

	//convert proof trace to proof structure
	int i=0;
	vector< struct ProofItem > vproof1;
	while(true) {
		//this means never reach end here
		assert(i<(sdf.size()-1));
		struct ProofItem proof;
		proof.value_type=PROOF_FORMULA;
		if(sdf[i]==3) {
			proof.type=ROOT;
			//start of root
			while(true) {
				i++;
				assert(sdf[i]!=1);
				//assert(sdf[i]!=-1);
				if(i==(sdf.size()-1) || sdf[i]==0) {
					assert(sdf[i]==0);
					vproof1.push_back(proof);
					break;
				} else {
					long var=(sdf[i] & (unsigned long)(-1))/2;
					assert(var!=0);
					int ivar=(int)var;
					proof.cls.push_back(ivar);
				}
			}
			assert(sdf[i]==0);
			if(i==(sdf.size()-1)) break; //end of all
			else i++;//end of root
		} else if(sdf[i]==5) {
			//start of chain
			proof.type=CHAIN;
			i++;
			int clsid=(sdf[i] & (unsigned long)(-1))/2;
			proof.v_ante.push_back(clsid);
			
			while(true) {
				i++;
				assert(sdf[i]!=1);
				//assert(sdf[i]!=-1);
				if(i==(sdf.size()-1) || sdf[i]==0) {
					assert(sdf[i]==0);
					vproof1.push_back(proof);
					break;
				}
				clsid=(sdf[i] & (unsigned long)(-1))/2;
				proof.v_pivot.push_back(clsid);

				i++;
				assert(i<(sdf.size()-1) && sdf[i]!=0);
				clsid=(sdf[i] & (unsigned long)(-1))/2;
				proof.v_ante.push_back(clsid);
			}
			assert(sdf[i]==0);
			if(i==(sdf.size()-1)) break; //end of all
			else i++;//end of chain

		} else {
			assert(0);
		}
		
	}

	//check_proof(vproof1,-totry,totry+init_varnum+1);
#if 1
	vector< struct ProofItem > & vproof2= vproof1;
	//expanding to avoid multi-resolve
	vector< struct ProofItem > vproof;
	vector <int> vproof2shiftto;
	int current_shift=0;
	int position_vproof2=0;
	for(vector< struct ProofItem >::iterator itr=vproof2.begin();itr!=vproof2.end();++itr) {
		struct ProofItem & prfitm=*itr;
		if(prfitm.type==CHAIN)  {
			vector <int>& v_ante=prfitm.v_ante;
			vector <int>& v_pivot=prfitm.v_pivot;
			assert(v_ante.size()==v_pivot.size()+1);
			
			int clsid=*(v_ante.begin());
			assert(clsid>=0 && clsid<vproof.size());
			int clsid_new=vproof2shiftto[clsid];

			vector<int>::iterator itr_anteid=v_ante.begin();
			itr_anteid++;//right ante cls

			vector<int>::iterator itr_pivot=v_pivot.begin();

			for(;itr_anteid!=v_ante.end();itr_anteid++) {
				struct ProofItem newproofitm;
				newproofitm.type=CHAIN;
				newproofitm.value_type=PROOF_FORMULA;
				newproofitm.v_ante.push_back(clsid_new);

				int rightclsid=*itr_anteid;
				assert(rightclsid>=0 && rightclsid<vproof.size());
				int rightclsid_new=vproof2shiftto[rightclsid];
				newproofitm.v_ante.push_back(rightclsid_new);

				int pivotidx=*itr_pivot;
				assert(pivotidx>0 && 2*init_varnum+10>=pivotidx);
				newproofitm.v_pivot.push_back(pivotidx);
				
				vproof.push_back(newproofitm);
				clsid_new=position_vproof2+current_shift;
				if(clsid_new!=vproof.size()-1) {
					cout<<"clsid_new "<<clsid_new<<" "<<vproof.size()<<endl;
					assert(0);
				}
				current_shift++;

				itr_pivot++;
			}
			current_shift--;
			vproof2shiftto.push_back(position_vproof2+current_shift);

		} else {
			assert(prfitm.type==ROOT);//no need to deal with this
			vproof.push_back(prfitm);
			vproof2shiftto.push_back(position_vproof2+current_shift);
		}
		position_vproof2++;
	}
	assert(vproof2shiftto.size()==vproof2.size());
	assert(vproof2shiftto.size()==position_vproof2);
	assert(vproof.size()==position_vproof2+current_shift);

	vproof2.clear();
	vproof2shiftto.clear();

	//check_proof(vproof,-totry,totry+init_varnum+1);

	//printing out the result
	int position=1;
	//skip the unused NULL emlement in the first element
	assert(vproof[0].cls.size()==0 && vproof[0].type==ROOT);
	vector< struct ProofItem >::iterator itr=vproof.begin();
	itr++;
	for(;itr!=vproof.end();++itr) {
		struct ProofItem & prfitm=*itr;

		vector<int> cls=prfitm.cls;
		if(prfitm.type==CHAIN)  {
			vector <int>& v_ante=prfitm.v_ante;
			vector <int>& v_pivot=prfitm.v_pivot;
			//only two resolve
			assert(v_pivot.size()==1);
			assert(v_ante.size()==2);
				int leftclsid=*(v_ante.begin());
				assert(leftclsid>0 && leftclsid<vproof.size());
				int rightclsid=*(v_ante.begin()+1);
				assert(rightclsid>0 && rightclsid<vproof.size());
				int pivotidx=*(v_pivot.begin());
				assert(pivotidx>0 && pivotidx<=init_varnum*2+20);
				//operator

/*				//reduce left
				int tempclsid=leftclsid;
				while(vproof[tempclsid].value_type==PROOF_REF) {tempclsid=vproof[tempclsid].ref;assert(tempclsid>0 && tempclsid<vproof.size());}
				assert(vproof[tempclsid].value_type!=PROOF_REF);
				if(vproof[tempclsid].value_type==PROOF_TRUE || vproof[tempclsid].value_type==PROOF_FALSE) {
					vproof[leftclsid].value_type=vproof[tempclsid].value_type;
				}else {
					assert(vproof[tempclsid].value_type==PROOF_FORMULA);
					vproof[leftclsid].value_type=PROOF_REF;
					vproof[leftclsid].ref=tempclsid;
				}

				//reduce right
				tempclsid=rightclsid;
				while(vproof[tempclsid].value_type==PROOF_REF) {tempclsid=vproof[tempclsid].ref;assert(tempclsid>0 && tempclsid<vproof.size());}
				assert(vproof[tempclsid].value_type!=PROOF_REF);
				if(vproof[tempclsid].value_type==PROOF_TRUE || vproof[tempclsid].value_type==PROOF_FALSE) {
					vproof[rightclsid].value_type=vproof[tempclsid].value_type;
				}else {
					assert(vproof[tempclsid].value_type==PROOF_FORMULA);
					vproof[rightclsid].value_type=PROOF_REF;
					vproof[rightclsid].ref=tempclsid;
				}
*/
				if(isBvar(pivotidx,POTDEC_reduce,init_varnum)==true) {
					//and 
					if(vproof[leftclsid].value_type==PROOF_FALSE || vproof[rightclsid].value_type==PROOF_FALSE) {
						vproof[position].value_type=PROOF_FALSE;
					} else if(vproof[leftclsid].value_type==PROOF_TRUE && vproof[rightclsid].value_type==PROOF_TRUE) {
						vproof[position].value_type=PROOF_TRUE;
					} else if(vproof[leftclsid].value_type==PROOF_TRUE) {
						//it depend on rightclsid
						vproof[position].value_type=PROOF_REF;
						if(vproof[rightclsid].value_type==PROOF_REF) {
							vproof[position].ref=vproof[rightclsid].ref;
						} else {
							assert(vproof[rightclsid].value_type==PROOF_FORMULA);
							vproof[position].ref=rightclsid;
						}
					} else if(vproof[rightclsid].value_type==PROOF_TRUE) {
						//it depend on leftclsid
						vproof[position].value_type=PROOF_REF;
						if(vproof[leftclsid].value_type==PROOF_REF) {
							vproof[position].ref=vproof[leftclsid].ref;
						} else {
							assert(vproof[leftclsid].value_type==PROOF_FORMULA);
							vproof[position].ref=leftclsid;
						}
					} else {
						resulting_dual_wire<<"  wire itp"<<totry<<"c"<<position<<" ; "<<endl;
						resulting_dual   <<"  assign itp"<<totry<<"c"<<position<<" = itp"<<totry<<"c";

						while(vproof[leftclsid].value_type==PROOF_REF) {leftclsid=vproof[leftclsid].ref;assert(leftclsid>0 && leftclsid<vproof.size());}
						assert(vproof[leftclsid].value_type==PROOF_FORMULA);
						resulting_dual<<leftclsid<<" & itp"<<totry<<"c";

						while(vproof[rightclsid].value_type==PROOF_REF) {rightclsid=vproof[rightclsid].ref;assert(rightclsid>0 && rightclsid<vproof.size());}
						assert(vproof[rightclsid].value_type==PROOF_FORMULA);
						resulting_dual<<rightclsid<<" ; "<<endl;;
					}
				} else {
					//or
					if(vproof[leftclsid].value_type==PROOF_TRUE || vproof[rightclsid].value_type==PROOF_TRUE) {
						vproof[position].value_type=PROOF_TRUE;
					} else if(vproof[leftclsid].value_type==PROOF_FALSE && vproof[rightclsid].value_type==PROOF_FALSE) {
						vproof[position].value_type=PROOF_FALSE;
					} else if(vproof[leftclsid].value_type==PROOF_FALSE) {
						//it depend on rightclsid
						vproof[position].value_type=PROOF_REF;
						if(vproof[rightclsid].value_type==PROOF_REF) {
							vproof[position].ref=vproof[rightclsid].ref;
						} else {
							assert(vproof[rightclsid].value_type==PROOF_FORMULA);
							vproof[position].ref=rightclsid;
						}
					} else if(vproof[rightclsid].value_type==PROOF_FALSE) {
						//it depend on leftclsid
						vproof[position].value_type=PROOF_REF;
						if(vproof[leftclsid].value_type==PROOF_REF) {
							vproof[position].ref=vproof[leftclsid].ref;
						} else {
							assert(vproof[leftclsid].value_type==PROOF_FORMULA);
							vproof[position].ref=leftclsid;
						}
					} else {
						resulting_dual_wire<<"  wire itp"<<totry<<"c"<<position<<" ; "<<endl;
						resulting_dual<<   "  assign itp"<<totry<<"c"<<position<<" = itp"<<totry<<"c";

						while(vproof[leftclsid].value_type==PROOF_REF) {leftclsid=vproof[leftclsid].ref;assert(leftclsid>0 && leftclsid<vproof.size());}
						assert(vproof[leftclsid].value_type==PROOF_FORMULA);
						resulting_dual<<leftclsid<<" | itp"<<totry<<"c";

						while(vproof[rightclsid].value_type==PROOF_REF) {rightclsid=vproof[rightclsid].ref;assert(rightclsid>0 && rightclsid<vproof.size());}
						assert(vproof[rightclsid].value_type==PROOF_FORMULA);
						resulting_dual<<rightclsid<<" ; "<<endl;;
					}
				}
		} else {//ROOT
			assert(prfitm.type==ROOT);
			assert(prfitm.cls.size()!=0);
			
			if(isAcls(cls,init_varnum)) {
				vector<int> onlyB;
				filterB(cls,POTDEC_reduce,onlyB);

				if(onlyB.size()>0) {
					resulting_dual_wire<<"  wire itp"<<totry<<"c"<<position<<" ; "<<endl;
					resulting_dual<<   "  assign itp"<<totry<<"c"<<position<<" = ";
					for(vector< int >::iterator itr_cls=onlyB.begin();itr_cls!=onlyB.end();++itr_cls) {
						resulting_dual<<((*itr_cls)>0?"v":"!v")<<abs(*itr_cls);
						if((itr_cls+1)!=onlyB.end()) resulting_dual<<" | ";
					}
					resulting_dual<<" ; "<<endl;
				} else {
					vproof[position].value_type=PROOF_FALSE;
				}
				
			} else {
				vproof[position].value_type=PROOF_TRUE;
			}
		}
		position++;
	}

	int finalclsid=vproof.size()-1;
	while(vproof[finalclsid].value_type==PROOF_REF) {finalclsid=vproof[finalclsid].ref;assert(finalclsid>0 && finalclsid<vproof.size());}
	resulting_dual<<"  assign v"<<totry<<" = ";
	if(vproof[finalclsid].value_type==PROOF_TRUE) {
		resulting_dual<<"1'b1 ; "<<endl;
	} else if (vproof[finalclsid].value_type==PROOF_FALSE) {
		resulting_dual<<"1'b0 ; "<<endl;
	} else {
		resulting_dual<<"itp"<<totry<<"c"<<finalclsid<<" ; "<<endl;
	}
#endif
	return 1;
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
	resulting_dual_head<<"  input  clk ; "<<endl;
	

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


void SAT_instance::print_dual_tail (ofstream & resulting_dual) 
{
	for(set<string>::iterator itr=inname_2dualsyn_flatidx_lst.begin();itr!=inname_2dualsyn_flatidx_lst.end();++itr) {
		resulting_dual<<"  assign "<< *itr<< " = v" <<src_name2idx[*itr]+prefix*final_index_oneinst<<" ; "<<endl;
	}
	for(set<string>::iterator itr=outname_2dualsyn_flatidx_lst.begin();itr!=outname_2dualsyn_flatidx_lst.end();++itr) {
		resulting_dual<<"  assign  v"<<src_name2idx[*itr]+final_index_oneinst*(prefix+dly+len-1)<<" = "<< *itr <<" ; "<<endl;
	}
	
	resulting_dual<<"endmodule"<<endl;
	resulting_dual.close();
}

void SAT_instance::check_proof(vector< struct ProofItem > & vproof,int totry,int totry_shifted) {
	//check proof
	int position=0;
	for(vector< struct ProofItem >::iterator itr=vproof.begin();itr!=vproof.end();++itr) {
		struct ProofItem & prfitm=*itr;
		if(prfitm.type==CHAIN)  {
			vector <int>& v_ante=prfitm.v_ante;
			vector <int>& v_pivot=prfitm.v_pivot;
			assert(v_ante.size()==v_pivot.size()+1);
			
			int clsid=*(v_ante.begin());
			assert(clsid>=0 && clsid<vproof.size());
			vector<int> leftcls=vproof[clsid].cls;

			vector<int>::iterator itr_anteid=v_ante.begin();
			itr_anteid++;
			vector<int>::iterator itr_pivot=v_pivot.begin();
			for(;itr_anteid!=v_ante.end();itr_anteid++) {
				int rightclsid=*itr_anteid;
				assert(rightclsid>=0 && rightclsid<vproof.size());
				vector<int> rightcls=vproof[rightclsid].cls;

				int pivotidx=*itr_pivot;
				/*cout<<position<<" resolve left ";
				print_cls(cout,leftcls);
				cout<<"resolve right ";
				print_cls(cout,rightcls);*/
				resolve(leftcls,rightcls,pivotidx);
				/*cout<<"resolve get ";
				print_cls(cout,leftcls);*/
				itr_pivot++;
			}
			prfitm.cls=leftcls;

			if((itr+1)==vproof.end()) {
				//this is the last ,
				//it should be 2 lits
				assert(leftcls.size()==2);
				assert(
					(leftcls[0]==totry && leftcls[1]==totry_shifted) ||
					(leftcls[1]==totry && leftcls[0]==totry_shifted)
				);
			}
		} else {
			assert(prfitm.type==ROOT);//no need to deal with this
			//cout<<position<<" root ";
			//print_cls(cout,prfitm.cls);
		}
		position++;
	}
	assert((vproof.end()-1)->cls.size()==2);
	return ;
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

/*    for(set<int>::iterator itr=I.begin();itr!=I.end();++itr) {
	cout<< "IIII " << *itr << endl;
    }
    for(set<int>::iterator itr=O.begin();itr!=O.end();++itr) {
	cout<< "OOOO " << *itr << endl;
    }*/

    backward_gates_extraction(init_varnum,init_clauseset);
    
    return 1;
}


//aux functions


int SAT_instance::add_const_constraint(SAT_Manager mng_reduce,int var1,map<int,int> idx2value,int gid) {
	int v_111=idx2value[var1];
	assert(v_111==0||v_111==1);
	vector<int> restmp1_111;
	int lit_111=(v_111==0)?(neg(var1<<1)):(pos(var1<<1));
	restmp1_111.push_back(lit_111);
	mng_reduce->addClause(restmp1_111);
	return 1;
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
		mng_reduce->addClause(restmp);
		return 0;
	} else {
		vector<int> restmp;
		restmp.push_back(pos(res_var<<1));
		assert(restmp.size()==1);
		cout<<" add_xor_result_constraint res_var "<<res_var<< " "<<pos(res_var<<1)<<endl;
		mng_reduce->addClause(restmp);
		return 1;
	}
}




//when  using these function, you must <<1 on all vars
    void SAT_instance::xor2 (SAT_Manager mng,int a, int b, int o, int gid=0)
	{
		assert(gid==0);
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
	    mng->addClause(lits);

	    lits.clear();
	    lits.push_back(pos(a));
	    lits.push_back(pos(b));
	    lits.push_back(neg(o));
	    mng->addClause(lits);

	    lits.clear();
	    lits.push_back(neg(a));
	    lits.push_back(pos(b));
	    lits.push_back(pos(o));
	    mng->addClause(lits);

	    lits.clear();
	    lits.push_back(pos(a));
	    lits.push_back(neg(b));
	    lits.push_back(pos(o));
	    mng->addClause(lits);
	}

    void SAT_instance::or_n (SAT_Manager mng,int * inputs, int num_input, int o, int gid=0)
	{
		assert(gid==0);
	    vector <int> lits;
	    int i;
	    for (i=0; i< num_input; ++i) {
		lits.clear();
		lits.push_back(neg(inputs[i]));
		lits.push_back(pos(o));
		mng->addClause(lits);
	    }
	    lits.clear();
	    for (i=0; i< num_input; ++i)
		lits.push_back(pos(inputs[i]));
	    lits.push_back(neg(o));
	    mng->addClause(lits);
    
	}
    
    void SAT_instance::equ2(SAT_Manager mng,int a, int b, int gid=0)
    {
		assert(gid==0);
    	assert((a>>1)!=(b>>1));
    	vector <int> lits;
	
	lits.clear();
	lits.push_back(pos(a));
	lits.push_back(neg(b));
	mng->addClause(lits);

	lits.clear();
	lits.push_back(neg(a));
	lits.push_back(pos(b));
	mng->addClause(lits);
    }

    void SAT_instance::ine2(SAT_Manager mng,int a, int b, int gid=0)
    {
		assert(gid==0);
    	assert((a>>1)!=(b>>1));
    	vector <int> lits;
	
	lits.clear();
	lits.push_back(pos(a));
	lits.push_back(pos(b));
	mng->addClause(lits);
	
	lits.clear();
	lits.push_back(neg(a));
	lits.push_back(neg(b));
	mng->addClause(lits);
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

