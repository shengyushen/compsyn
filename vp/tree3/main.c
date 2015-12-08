#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <assert.h>
#include "typedef.h"
#include "vlist.h"
#include "parse.h"

void usage() {
	printf("Usage : \n");
	printf("t3 <tree file name>  : to flatten the tree specified in <tree file name>\n");
	printf("t3 -l                : to run a generate and test loop \n");
	return;
}

void flatten_print( TreeNode * tnp ) {
	//flatten
	size_t  NumElement;
	value_t * flatArray = flatten(tnp,&NumElement);
	assert (NumElement >=0);

	// print out the result
	printf ("flatten result with size %zu is :\n",NumElement);
	int i;
	for(i=0;i<NumElement;i++) {
		printf( "%d " ,flatArray[i]);
	}
	printf("\n");

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

TreeNode * generate_node (unsigned int depth) {
	if(depth!=0) {
		//construct current tree node
		TreeNode * current_tree_node = malloc (sizeof(TreeNode));

		//allocing sub trees
		current_tree_node->left_tree  = generate_node (depth -1);
		current_tree_node->mid_tree   = generate_node (depth -1);
		current_tree_node->right_tree = generate_node (depth -1);
		current_tree_node->left_data  = malloc (sizeof(DataNode));
		current_tree_node->right_data = malloc (sizeof(DataNode));
	
	
		return current_tree_node;
	} else {
		return (TreeNode *)NULL;
	}
}

unsigned int random50 ()  {
	long l = random()%2;
	return l;
}

void fillin (TreeNode * tnp) ;
void randomize_treenode (TreeNode ** tnpp) {
	if(random50()) {
		fillin(*tnpp);
	} else {
		freeTreeNode(*tnpp);
		*tnpp = (TreeNode *)NULL;
	}
	return ;
}



struct vlist vl;

void randomize_datanode (DataNode ** dnpp) {
	if((*dnpp)) {
		if(random50()) {
			value_t v = (value_t)random();
			vlist_insert(&vl,v);
			(*dnpp)->value = v;
		} else {
			freeDataNode(*dnpp);
			*dnpp = (DataNode *)NULL;
		}
	} else {
	}
	return;
}

void fillin (TreeNode * tnp) {
	if(tnp) {
		randomize_treenode(&(tnp->left_tree));
		randomize_datanode(&(tnp->left_data));
		randomize_treenode(&(tnp->mid_tree));
		randomize_datanode(&(tnp->right_data));
		randomize_treenode(&(tnp->right_tree));
	}

	return;
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
		//generate a complete tree unintialized
		printf("tree depth is %d\n",depth/STEPSIZE);
		TreeNode * tnp =  generate_node (depth/STEPSIZE);
		assert (tnp!=(TreeNode *)NULL);
	
		//filling in values
		vlist_free(&vl);
		fillin(tnp);

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
	} else {
		usage();
	}

	return 0;
}
