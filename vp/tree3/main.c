#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <assert.h>
#include "typedef.h"
#include "parse.h"

FILE *yyin;
int main(int argc, char *argv[]){ 
	if  (argc != 2) {
		printf("Usage : tritree <tree file name>\n");
		return 1;
	}

	char namein[512];
	strcpy(namein,argv[1]);

	if (( yyin = fopen(namein,"r")) == NULL) {
		printf("Can not open %s\n",namein); 
		return 1;
	};

	//calling the parser
	TreeNode * tn ;
	int res=yyparse(&tn);
	assert (res==0);

	size_t  NumElement;
	value_t * flatArray = flatten(tn,&NumElement);
	assert (NumElement >=0);

	// print out the result
	printf ("flatten result with size %d is :\n",NumElement);
	int i;
	for(i=0;i<NumElement;i++) {
		printf( " %d " ,flatArray[i]);
	}
	printf("\n");

	fclose(yyin);
	return 0;
}
