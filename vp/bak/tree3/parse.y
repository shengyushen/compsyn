%{
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "typedef.h"
#include "t3.h"

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

%token KEY_D0
%token KEY_DN
%token KEY_T0
%token KEY_TN
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
	KEY_T0 
		{ 
			TreeNode * ssy = (TreeNode *) NULL;
			$$ =  ssy;
		}
	| KEY_LPARENT KEY_TN tree data tree data tree KEY_RPARENT
		{
			DataNode * d1= $4;
			DataNode * d2 = $6;
			TreeNode * ssy = allocTreeNode();
			assert(ssy!=(TreeNode *)NULL);
			ssy-> left_tree = $3;
			ssy-> left_data = $4;
			ssy-> mid_tree  = $5;
			ssy-> right_data= $6;
			ssy-> right_tree= $7;
			$$=ssy;
		}
;

data :
	KEY_D0 {
			$$ = (DataNode *) NULL;
		}
	| KEY_LPARENT KEY_DN NUMBER KEY_RPARENT {
			DataNode * ssy = allocDataNode();
			ssy-> value = yylval.num;
			$$ = ssy;
		}
%%

