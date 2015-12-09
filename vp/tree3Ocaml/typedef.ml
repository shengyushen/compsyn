type treeNode =
	T_treeNode of treeNode*dataNode*treeNode*dataNode*treeNode
	| T_treeNode_NULL
and dataNode =
	T_dataNode of int
	|T_dataNode_NULL
