#define MAX_LINE_LENGTH    65536
#define MAX_WORD_LENGTH    64


class inout4rev_cz {
public:
	string name;
	int left,right;
};

struct lt_inout4rev_cz
{
  bool operator()(inout4rev_cz k1,inout4rev_cz k2) const
  {
    return strcmp(k1.name.c_str(), k2.name.c_str()) < 0;
  }
};

struct ltint
{
  bool operator()(int s1, int s2) const
  {
    return s1<s2;
  }
};





class xor_operation 
{
public:
	int op1;
	int op2;
	int res;
};

struct lt_xor_operation
{
  bool operator()(xor_operation k1,xor_operation k2) const
  {
    return (k1.op1 < k2.op1);
  }
};


enum ProofItem_Type {
	ROOT,
	CHAIN
};

enum ProofItem_Value_Type {
	PROOF_TRUE,
	PROOF_FALSE,
	PROOF_REF,
	PROOF_FORMULA
};

struct ProofItem {
	ProofItem_Type type;
	ProofItem_Value_Type value_type;
	vector <int> cls;
	vector <int> v_ante;
	vector <int> v_pivot;
	int ref;
};

class SAT_instance {
public:
    //these are my setting
    int final_index_oneinst;
    int dly;
    int len;
    int prefix;
    int forward;
    
    set<string>  inname_2dualsyn_flatidx_lst;//the input name to be dual syned, with array index
    set<string>  inname_2dualsyn_notflatidx_lst;//the input name to be dual syned, without array index

    set<string>  outname_2dualsyn_flatidx_lst;//the output to be dual syned, with array index
    set<string>  outname_2dualsyn_notflatidx_lst;//the output to be dual syned, without array index
    
    map<string,int> tgt_name2idx;
    map<string,int> src_name2idx;
    map<int,string> tgt_idx2name;
    map<int,string> src_idx2name;

    //for rev_cz special purpose
    set<inout4rev_cz,lt_inout4rev_cz>  in_name_leftright_set;//inname_2dualsyn_notflatidx_lst with array index
    set<inout4rev_cz,lt_inout4rev_cz>  out_name_leftright_set;//outname_2dualsyn_notflatidx_lst with array index

    set<int>	O;//the set of output idx account for shifted
    set<int>	I;//the set of  input idx account for shifted
    
    int timeout_nl_const;
    double start_time;



    //function list
    SAT_instance(void);
    //functions that would initial something
    void read_cnf(char * filename,char * timeout_value,int & init_varnum,set<vector <int> > & init_clauseset);
    

    int	solve_ssy(int  init_varnum,set<vector <int> > init_clauseset);
    //void find_anchor_point_set(set<int> & ssy);
    void backward_gates_extraction(int init_varnum,set<vector <int> > init_clauseset);
    int print_dual(SAT_Manager mng,int totry,set<int> &POTDEC_reduce,ofstream & resulting_dual,ofstream & resulting_dual_wire,int  init_varnum) ;
    void print_dual_head (ofstream & resulting_dual_head,ofstream & resulting_dual) ;
    void print_dual_tail (ofstream & resulting_dual) ;
    void check_proof(vector< struct ProofItem > & vproof,int totry,int totry_shifted);

    //mng manipulation
    void initial_sat_solver(SAT_Manager & mng_2init,set< vector<int> > init_clauseset_2init,int init_varnum_2init);


    //functions that manipulate the clause lib
    void xor2 (SAT_Manager mng,int a, int b, int o, int gid);
    void or_n (SAT_Manager mng,int * inputs, int num_input, int o, int gid);
    void equ2(SAT_Manager mng,int a, int b, int gid);
    void ine2(SAT_Manager mng,int a, int b, int gid);
    int * ptr(vector<int>::iterator itr);
    int pos(int i) ;
    int neg(int i) ;
    
    //set manipulation
    void my_set_union(set<int> s1,set<int> s2,set<int> & res);
    void my_set_intersect(set<int> s1,set<int> s2,set<int> & res);
    void my_set_permutation(set<int> s1,set<int> s2,set<int> & res);
    void my_set_permutation_elem(set<int> s1,int s2,set<int> & res);
    void my_set_sub(set<int> s1,set<int> s2,set<int> & res);
    bool is_var_in_cls(int totest,vector<int> cls) ;
    
    int add_xor_result_constraint(SAT_Manager mng_reduce,int var1,int var2,int res_var,map<int,int> idx2value,int gid);
    int add_const_constraint(SAT_Manager mng_reduce,int var1,map<int,int> idx2value,int gid);
};
