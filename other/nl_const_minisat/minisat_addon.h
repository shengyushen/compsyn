#define	SAT_Manager Solver* 	

enum SAT_StatusT {
    UNDETERMINED,
    UNSATISFIABLE,
    SATISFIABLE,
    TIME_OUT,
    MEM_OUT,
    ABORTED
};

double get_cpu_time();

bool findin_set(int tobefind,const set<int>& vv);
int lowbound_set(const set<int>& vv) ;
int upbound_set(const set<int>& vv) ;

bool findin_vector(int tobefind,const vector<int> vv);

void resolve(vector<int> & leftcls,vector<int>& rightcls,int pivotidx);
bool isAcls(vector<int> & cls,int maxidx);
void filterB(vector<int>& cls,set<int>& POTDEC_reduce,vector<int> & res);
bool isBvar(int varidx,set<int>& POTDEC_reduce,int maxidx);
void print_cls(ostream & ost,vector<int> cls2prt);
void print_set(ostream & ost,set<int> cls2prt);

void SAT_SetNumVariables(SAT_Manager mng, int init_varnum);
int SAT_Solve(SAT_Manager mng);
int SAT_GetVarAsgnment(SAT_Manager mng, int varid);
void SAT_AddClause(SAT_Manager mng,vector <int>& lits, int gid);


