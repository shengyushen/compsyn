#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <assert.h>
#include "typedef.h"
#include "t3.h"
#include "vlist.h"
#include "parse.h"

void usage() {
	printf("Usage : \n");
	printf("t3 <tree file name>  : to flatten the tree specified in <tree file name>\n");
	printf("t3 -l                : to run a generate and test loop \n");
	printf("t3 -gen <depth> <density>: to generate a tree description file at stdout with depth <depth> and density <density> \n");
	return;
}

void flatten_print( TreeNode * tnp ) {
	time_t start_time= time(NULL); 
	printf("begin flatten\n");
	fflush(stdout);
	//flatten
	size_t  NumElement;
	value_t * flatArray = flatten(tnp,&NumElement);
	assert (NumElement >=0);
	
	time_t end_time= time(NULL);

	printf("run time %lu\n",end_time - start_time);
	fflush(stdout);

	// print out the result
/*	printf ("flatten result with size %zu is :\n",NumElement);
	int i;
	for(i=0;i<NumElement;i++) {
		printf( "%d " ,flatArray[i]);
	}
	printf("\n");
*/
	free ( flatArray ) ;
	return;
}

FILE *yyin;
void parse_flat (char * namein) {
	if (( yyin = fopen(namein,"r")) == NULL) {
		printf("Can not open %s\n",namein); 
		usage();
		return ;
	};
	printf ( "Flattening file %s\n" , namein ) ;

	//calling the parser
	TreeNode * tnp ;
	int res=yyparse(&tnp);
	assert (res==0);
	assert (tnp!=(TreeNode *)NULL);

	//test 
	flatten_print ( tnp ) ;
	
	//free the alloced tnp
	freeTreeNode ( tnp );

	fclose(yyin);
	return;
}


unsigned int density;
unsigned int random50 ()  {
	assert(density <100);
	long l = random()%100;
	if(l<density) return 1;
	else return 0;
}

struct vlist vl;
TreeNode * generate_treenode (unsigned int depth) ;
void randomize_treenode (TreeNode ** tnpp , unsigned int depth) {
	if(random50()) {
		*tnpp=generate_treenode (depth);
	} else {
		*tnpp=(TreeNode *)NULL;
	}
	return ;
}

void randomize_datanode (DataNode ** dnpp) {
	if(random50()) {
		value_t v = (value_t)random();
		vlist_insert(&vl,v);
		DataNode * newdnp =allocDataNode();
		newdnp->value = v;
		(*dnpp) = newdnp;
	} else {
		*dnpp = (DataNode *)NULL;
	}
	return;
}

TreeNode * generate_treenode (unsigned int depth) {
	if(depth!=0) {
		//construct current tree node
		TreeNode * current_tree_node = allocTreeNode();

		//allocing sub trees
		randomize_treenode(&(current_tree_node->left_tree),depth -1);
		randomize_datanode(&(current_tree_node->left_data));
		randomize_treenode(&(current_tree_node->mid_tree) ,depth -1);
		randomize_datanode(&(current_tree_node->right_data));
		randomize_treenode(&(current_tree_node->right_tree),depth -1);
	
		return current_tree_node;
	} else {
		return (TreeNode *)NULL;
	}
}

void flatten_compare( TreeNode * tnp ) {
	//flatten
	size_t  NumElement;
	value_t * flatArray = flatten(tnp,&NumElement);
	assert (NumElement >=0);

	// print out the result

	unsigned issame=vlist_compare_array(&vl,flatArray,NumElement);
	if(issame==0) {
		printf("fillin data are not the same as flatten result\n");
		printf("fillin data are\n");
		vlist_print(&vl);
		printf ("flatten result with size %zu is :\n",NumElement);
		int i;
		for(i=0;i<NumElement;i++) {
			printf( "%d " ,flatArray[i]);
		}
		printf("\n");
		exit(1);
	} else {
		printf("filled data are the same as flatten result with %zu data\n",NumElement);
	}

	free ( flatArray ) ;
	return;
}

#define STEPSIZE 100
#define TOTALTEST 10000
void generate_and_test_loop () {
	printf ( "Generaring and testing loop \n" ) ;
	
	vlist_init(&vl);
	unsigned int depth;
	for(depth =STEPSIZE;depth <=TOTALTEST;depth++) {
		vlist_free(&vl);
		//generate a complete tree unintialized
		printf("tree depth is %d\n",depth/STEPSIZE);
		density = random()%100;
		TreeNode * tnp =  generate_treenode (depth/STEPSIZE);
		assert (tnp!=(TreeNode *)NULL);
	
		//test 
		flatten_compare ( tnp ) ;
		
		//free the alloced tnp
		freeTreeNode ( tnp );
	}
	vlist_free(&vl);

	return ;
}


int main(int argc, char *argv[]){ 
	if  (argc == 2) {
		char namein[512];
		strcpy(namein,argv[1]);

		if( ( strcmp("-l",namein) ) == 0) {
			//run generating and testing loop
			generate_and_test_loop ();
		} else {
			//flatening specified file
			parse_flat( namein );
		}
	} else if (argc ==4) {
		if( ( strcmp("-gen",argv[1]) ) == 0) {
			//run generating and testing loop
			unsigned int depth=atoi(argv[2]);
			density=atoi(argv[3]);
			TreeNode * tnp = generate_treenode(depth);
			printTreeNode(tnp);
		} else {
		usage();
		}
	} else {
		usage();
	}

	return 0;
}
