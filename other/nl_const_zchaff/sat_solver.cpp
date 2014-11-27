/* =========FOR INTERNAL USE ONLY. NO DISTRIBUTION PLEASE ========== */

/*********************************************************************
 Copyright 2000-2004, Princeton University.  All rights reserved. 
 By using this software the USER indicates that he or she has read, 
 understood and will comply with the following:

 --- Princeton University hereby grants USER nonexclusive permission 
 to use, copy and/or modify this software for internal, noncommercial,
 research purposes only. Any distribution, including commercial sale 
 or license, of this software, copies of the software, its associated 
 documentation and/or modifications of either is strictly prohibited 
 without the prior consent of Princeton University.  Title to copyright
 to this software and its associated documentation shall at all times 
 remain with Princeton University.  Appropriate copyright notice shall 
 be placed on all software copies, and a complete copy of this notice 
 shall be included in all copies of the associated documentation.  
 No right is  granted to use in advertising, publicity or otherwise 
 any trademark,  service mark, or the name of Princeton University. 


 --- This software and any associated documentation is provided "as is" 

 PRINCETON UNIVERSITY MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS 
 OR IMPLIED, INCLUDING THOSE OF MERCHANTABILITY OR FITNESS FOR A 
 PARTICULAR PURPOSE, OR THAT  USE OF THE SOFTWARE, MODIFICATIONS, OR 
 ASSOCIATED DOCUMENTATION WILL NOT INFRINGE ANY PATENTS, COPYRIGHTS, 
 TRADEMARKS OR OTHER INTELLECTUAL PROPERTY RIGHTS OF A THIRD PARTY.  

 Princeton University shall not be liable under any circumstances for 
 any direct, indirect, special, incidental, or consequential damages 
 with respect to any claim by USER or any third party on account of 
 or arising from the use, or inability to use, this software or its 
 associated documentation, even if Princeton University has been advised
 of the possibility of those damages.
*********************************************************************/
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

