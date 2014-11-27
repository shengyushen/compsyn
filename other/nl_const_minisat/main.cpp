
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



int main(int argc, char ** argv)
{
    //SAT_Manager mng = SAT_InitManager();
    if (argc < 2) {
	cerr << "Z-Chaff: Accelerated SAT Solver from Princeton. " << endl;
	cerr << "Copyright 2000-2004, Princeton University." << endl << endl;;
	cerr << "Usage: "<< argv[0] << " cnf_file [time_limit]" << endl;
	return 2;
    }
    //cout << "Z-Chaff Version: " << SAT_Version(mng) << endl;
    cout << "Solving " << argv[1] << " ......" << endl;
    
    int init_varnum;
    set<vector <int> > init_clauseset;
    SAT_instance sat_inst;
    if (argc == 3) {
    	sat_inst.read_cnf(argv[1],argv[2],init_varnum,init_clauseset);
    }
    else 
	assert(0);
	
    sat_inst.solve_ssy(init_varnum,init_clauseset);
    
    return 0;
}

