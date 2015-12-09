%{
open Typedef
%}

%token <string> LPARENT
%token <string> RPARENT
%token <string> NULL
%token <int> UNSIGNED_NUMBER
%start treeNode
%type <Typedef.treeNode> treeNode

%%

treeNode : LPARENT treeNode dataNode treeNode dataNode treeNode  RPARENT
	{T_treeNode($2,$3,$4,$5,$6)}
	| LPARENT RPARENT
	{T_treeNode_NULL}
;

dataNode : 
	NULL {T_dataNode_NULL}
	| UNSIGNED_NUMBER {T_dataNode($1)}
;

%%

