/*****************************************************************************************[Proof.C]
MiniSat -- Copyright (c) 2003-2005, Niklas Een, Niklas Sorensson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**************************************************************************************************/
#include <set>
#include <map>

using namespace std;

#include "Proof.h"
#include "Sort.h"

void resolve(vec<Lit>& main, vec<Lit>& other, Var x)
{
    Lit     p;
    bool    ok1 = false, ok2 = false;
    for (int i = 0; i < main.size(); i++){
        if (var(main[i]) == x){
            ok1 = true, p = main[i];
            main[i] = main.last();
            main.pop();
            break;
        }
    }

    for (int i = 0; i < other.size(); i++){
        if (var(other[i]) != x)
            main.push(other[i]);
        else{
            if (p != ~other[i])
                printf("PROOF ERROR! Resolved on variable with SAME polarity in both clauses: %d\n", x+1);
            ok2 = true;
        }
    }

    if (!ok1 || !ok2)
        printf("PROOF ERROR! Resolved on missing variable: %d\n", x+1);

    sortUnique(main);
}

void ssyChecker::root   (const vec<Lit>& c) {
	root_chain.push(true);
        clauses.push();
	for(int i=0;i<c.size();i++) {
		int sdf=(sign(c[i])? (- var(c[i])):(var(c[i])));
		clauses.last().push(sdf);
	}
}

void ssyChecker::chain  (const vec<ClauseId>& cs, const vec<Var>& xs) {
	root_chain.push(false);
        clauses.push();
        clauses.last().push(cs[0]);
	for (int i = 0; i < xs.size(); i++) {
		clauses.last().push(xs[i]);
		clauses.last().push(cs[i+1]);
	}
}


void ssyChecker::deleted(ClauseId c) {
        //clauses[c].clear(); 
}



//=================================================================================================
// Temporary files handling:


class TempFiles {
    vec<cchar*> files;      // For clean-up purposed on abnormal exit.

public:
   ~TempFiles()
    {
        for (int i = 0; i < files.size(); i++)
            remove(files[i]);
            //printf("Didn't delete:\n  %s\n", files[i]);
    }

    // Returns a read-only string with the filename of the temporary file. The pointer can be used to 
    // remove the file (which is otherwise done automatically upon program exit).
    //
    char* open(File& fp)
    {
        char*   name;
        for(;;){
            name = tempnam(NULL, NULL);     // (gcc complains about this... stupid gcc...)
            assert(name != NULL);
            fp.open(name, "wx+");
            if (fp.null())
                xfree(name);
            else{
								// dont add, I will remvove these files in clear_proof
                //files.push(name);
                return name;
            }
        }
    }
};
static TempFiles temp_files;       // (should be singleton)


//=================================================================================================
// Proof logging:


Proof::Proof()
{
    trav=new ssyChecker;
    fp_name    = temp_files.open(fp);
    id_counter = 0;
    trav       = NULL;
}


Proof::Proof(ProofTraverser& t)
{
    id_counter = 0;
    trav       = &t;
}


ClauseId Proof::addRoot(vec<Lit>& cl)
{
    cl.copyTo(clause);
    sortUnique(clause);

    if (trav != NULL)
        trav->root(clause);
    if (!fp.null()){
        putUInt(fp, index(clause[0]) << 1);
        for (int i = 1; i < clause.size(); i++)
            putUInt(fp, index(clause[i]) - index(clause[i-1]));
        putUInt(fp, 0);     // (0 is safe terminator since we removed duplicates)
    }

    return id_counter++;
}


void Proof::beginChain(ClauseId start)
{
    assert(start != ClauseId_NULL);
    chain_id .clear();
    chain_var.clear();
    chain_id.push(start);
}


void Proof::resolve(ClauseId next, Var x)
{
    assert(next != ClauseId_NULL);
    chain_id .push(next);
    chain_var.push(x);
}


ClauseId Proof::endChain()
{
    assert(chain_id.size() == chain_var.size() + 1);
    if (chain_id.size() == 1)
        return chain_id[0];
    else{
        if (trav != NULL)
            trav->chain(chain_id, chain_var);
        if (!fp.null()){
            putUInt(fp, ((id_counter - chain_id[0]) << 1) | 1);
            for (int i = 0; i < chain_var.size(); i++)
                putUInt(fp, chain_var[i] + 1),
                putUInt(fp, id_counter - chain_id[i+1]);
            putUInt(fp, 0);
        }

        return id_counter++;
    }
}


void Proof::deleted(ClauseId gone)
{
    if (trav != NULL)
        trav->deleted(gone);
    if (!fp.null()){
        putUInt(fp, ((id_counter - gone) << 1) | 1);
        putUInt(fp, 0);
    }
}


//=================================================================================================
// Read-back methods:


void Proof::compress(Proof& dst, ClauseId goal)
{
    assert(!fp.null());
    assert(false);  // Not yet!    
}


vec<long>& Proof::checkProof(char * proofname)
{
	ClauseId goal = ClauseId_NULL;
	if (trav != NULL) {
	        delete trav;
	}
	trav = new ssyChecker();
	
	//construct the proof in clauses
	traverse(*trav, goal);

	//find out all used clause
	set <int> visited;
	set <int> frontie;
	vec<vec<int> > & clauses=((class ssyChecker *)trav)->clauses;
	vec<bool> &      root_chain=((class ssyChecker *)trav)->root_chain;
	frontie.insert(clauses.size()-1);
	while(frontie.size()>0) {
		//pop out an element
		set<int>::iterator current_pos_iter=frontie.begin();
		int current_pos=*current_pos_iter;
		frontie.erase(current_pos_iter);

		//insert this element into visited
		visited.insert(current_pos);

		//insert all sub proof item of current_pos into frontie
		if(root_chain[current_pos]==false) {//ROOT dont need to trace any more
			vec<int> & current_clause = clauses[current_pos];
			assert(current_pos<(clauses.size()));

			for(int i =0;i<current_clause.size();i=i+2) {
				if(visited.find(current_clause[i])==visited.end()) frontie.insert(current_clause[i]);
			}
		}
	}
	
	//output the shrinked ssylog
	//predefined NULL to ocuppy the position 0 in vproof2
	//because the set type will return position 0 if we index it with undefined index
	vec<long>&  ssylog=((class ssyChecker *)trav)->ssylog;
	assert(ssylog.size()==0);
	ssylog.push(esc_int(1));
	ssylog.push(0);//the null clause

	//the map from vproof1 index to vproof2 index
	map < int , int  > idx1toidx2;
	int newpos=1;
	for(set<int>::iterator itr=visited.begin();itr!=visited.end();++itr) {
		int position=*itr;
		vec<int> & current_clause=clauses[position];

		if(root_chain[position]==false) { //chain 
			ssylog.push(esc_int(2));
			for(int i=0;i<current_clause.size();i++) {
				if((i%2)==0) {//clause id
					int oldante=current_clause[i];
					int newante=idx1toidx2[oldante];
					assert(newante>0);
					ssylog.push(esc_int(newante));
				} else {//pivot id
					ssylog.push(esc_int(current_clause[i]));
				}
			}
		} else {//root
			ssylog.push(esc_int(1));
			for (int i = 0; i < current_clause.size(); i++) {
				ssylog.push((long)(esc_int(current_clause[i]))); 
			}
		}
		ssylog.push(0);

		//add in new position mapping
		idx1toidx2[position]=newpos;
		newpos++;
	}
	//printf("size after reduce %d\n", (ssylog.size()));

	return ((class ssyChecker *)trav)->ssylog;
}



vec<long>& Proof::save(cchar* prooffilename)
{
    return checkProof((char * )prooffilename);
}

void Proof::clear_proof()
{
	if( ! ( fp.null() )) {
		fp.close();
	}

	if (trav != NULL) {
	        delete trav;
					trav=NULL;
	}
}


void Proof::traverse(ProofTraverser& trav, ClauseId goal)
{
    assert(!fp.null());

    // Switch to read mode:
    fp.setMode(READ);
    fp.seek(0);

    // Traverse proof:
    if (goal == ClauseId_NULL)
        goal = last();

    uint64  tmp;
    int     idx;
    for(ClauseId id = 0; id <= goal; id++){
        tmp = getUInt(fp);
        if ((tmp & 1) == 0){
            // Root clause:
            clause.clear();
            idx = tmp >> 1;
            clause.push(toLit(idx));
            for(;;){
                tmp = getUInt(fp);
                if (tmp == 0) break;
                idx += tmp;
                clause.push(toLit(idx));
            }
            trav.root(clause);

        }else{
            // Derivation or Deletion:
            chain_id .clear();
            chain_var.clear();
            chain_id.push(id - (tmp >> 1));
            for(;;){
                tmp = getUInt(fp);
                if (tmp == 0) break;
                chain_var.push(tmp - 1);
                tmp = getUInt(fp);
                chain_id.push(id - tmp);
            }

            if (chain_var.size() == 0)
                id--,   // (no new clause introduced)
                trav.deleted(chain_id[0]);
            else
                trav.chain(chain_id, chain_var);
        }
    }
    trav.done();

    // Restore write (proof-logging) mode:
    fp.seek(0, SEEK_END);
    fp.setMode(WRITE);
}
