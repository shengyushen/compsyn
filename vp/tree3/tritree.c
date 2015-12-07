#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <assert.h>
#include "typedef.h"
#include "parse.h"

void copyData (value_t *src, value_t *dst, size_t num) {
	assert (num>=0);
	int i;
	for(i=0;i<num;i++) {
		dst[i]=src[i];
	}
	return ;
}

value_t *flatten(TreeNode *n, size_t *num_elements) 
{
	if(n==(TreeNode*)NULL) {
		*num_elements=0;
		return (value_t*)NULL;
	} else {
		size_t leftSize;
		value_t * leftTreeArray = flatten(n->left_tree,&leftSize);
		size_t midSize;
		value_t * midTreeArray = flatten(n->mid_tree,&midSize);
		size_t rightSize;
		value_t * rightTreeArray = flatten(n->right_tree,&rightSize);

		size_t leftDataSize;
		if((n->left_data)==(DataNode *)NULL) {
			leftDataSize = 0;
		} else {
			leftDataSize = 1;
		}

		size_t rightDataSize;
		if((n->right_data)==(DataNode *) NULL) {
			rightDataSize = 0;
		} else {
			rightDataSize = 1;
		}

		//the total size of new array
		size_t allsize = leftSize + rightSize + midSize + leftDataSize + rightDataSize;
		*num_elements = allsize;

		value_t *newArray = malloc(allsize*(sizeof(value_t)));
		//copying the left tree
		copyData(leftTreeArray,newArray,leftSize);
		size_t newindex =leftSize;

		//copying the left data and manipulate the new index
		if(leftDataSize==1) {
			newArray[newindex]=(n->left_data)->value;
			newindex ++;
		}

		//copying the mid tree
		copyData(midTreeArray,newArray+newindex,midSize);
		newindex = newindex + midSize;

		//copying the right data
		if(rightDataSize ==1) {
			newArray[newindex]=(n->right_data)->value;
			newindex ++;
		}

		//copying the right tree
		copyData(rightTreeArray,newArray+newindex,rightSize);
		
		//free all mem alloced in sub
		free(leftTreeArray);
		free(midTreeArray);
		free(rightTreeArray);

		return newArray;
	}
}


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

	/*char *line = NULL;
	size_t len = 0;
	char read;
	while ((read = getline(&line, &len, yyin)) != -1) {
		printf ("%s\n",line);
	}*/

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
