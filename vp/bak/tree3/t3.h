//free DataNode and TreeNode
void freeDataNode ( DataNode * dn) ;
void freeTreeNode ( TreeNode * tn ) ;

//print DataNode and TreeNode
void printDataNode(DataNode * dnp) ;
void printTreeNode(TreeNode * tnp ) ;

//allocing DataNode and TreeNode
DataNode * allocDataNode() ;
TreeNode * allocTreeNode() ;

void copyData (value_t *src, value_t *dst, size_t num) ;
value_t *flatten(TreeNode *n, size_t *num_elements) ;



