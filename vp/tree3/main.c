#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <assert.h>
#include "typedef.h"
#include "parse.h"

void usage() {
	printf("Usage : \n");
	printf("t3 <tree file name>  : to flatten the tree specified in <tree file name>\n");
	printf("t3 -l                : to run a generate and test loop \n");
	return;
}

void flatten_print( TreeNode * tn ) {
	//flatten
	size_t  NumElement;
	value_t * flatArray = flatten(tn,&NumElement);
	assert (NumElement >=0);

	// print out the result
	printf ("flatten result with size %zu is :\n",NumElement);
	int i;
	for(i=0;i<NumElement;i++) {
		printf( " %d " ,flatArray[i]);
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
	TreeNode * tn ;
	int res=yyparse(&tn);
	assert (res==0);
	assert (tn!=(TreeNode *)NULL);

	//test 
	flatten_print ( tn ) ;
	
	//free the alloced tn
	freeTreeNode ( tn );

	fclose(yyin);
	return;
}

TreeNode * generate_node () {
}

void generate_and_test_loop () {
	printf ( "Generaring and testing loop \n" ) ;

	TreeNode * tn =  generate_node ();
	assert (tn!=(TreeNode *)NULL);

	//test 
	flatten_print ( tn ) ;
	
	//free the alloced tn
	freeTreeNode ( tn );

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
