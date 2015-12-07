%{
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "typedef.h"

void yyerror (TreeNode ** tnpp,char const *s)
{
  fprintf (stderr, "%s\n", s);
}

%}

%union {
	char * str;
	value_t num;
	TreeNode * tree;
	DataNode * data;
}

%token KEY_NULL
%token KEY_LPARENT
%token KEY_RPARENT

%token NUMBER
%token UNKNOWN

%type <tree> tree
%type <data> data
%parse-param { TreeNode **tnpp }
%%
input :
	tree {*tnpp = $1;}
;

tree :
	KEY_LPARENT KEY_RPARENT
		{ 
			TreeNode * ssy = (TreeNode *) NULL;
			$$ =  ssy;
		}
	| KEY_LPARENT tree data tree data tree KEY_RPARENT
		{
			DataNode * d1= $3;
			DataNode * d2 = $5;
			TreeNode * ssy = (TreeNode *) malloc(sizeof(TreeNode));
			assert(ssy!=(TreeNode *)NULL);
			ssy-> left_tree = $2;
			ssy-> left_data = $3;
			ssy-> mid_tree  = $4;
			ssy-> right_data= $5;
			ssy-> right_tree= $6;
			$$=ssy;
		}
;

data :
	KEY_NULL {
			$$ = (DataNode *) NULL;
		}
	| NUMBER {
			DataNode * ssy = (DataNode *) malloc (sizeof(DataNode));
			ssy-> value = yylval.num;
			$$ = ssy;
		}
%%

