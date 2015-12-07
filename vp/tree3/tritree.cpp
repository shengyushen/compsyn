#include <iostream> 
using namespace std;  

/*
A ternary tree is an extension of a binary tree, where instead of a left
and a right sub-tree pointer and a data value with value between the left
and the right subtree, there are left, center and right subtree pointers,
with two data values, one between the left and the center subtree, and one
between the center and the right subtree.

Your task is to flatten a ternary tree into an array in a depth-first
manner.

Example (look from left to right, root of the tree on the left):
    1
   *2    4
  /     /
 /     /
 3     5
*-----*
 8     6
\      \
 \      \
  9      7

In this case, the output array should come out as follows:

1 2 3 4 5 6 7 8 9

Note that some of the values and subtrees may not be present, and this is
represented by a NULL pointer.  In this case, they should not be traversed
or be included in the output.

The data type definitions appear below:
*/

/* Define the data type */
typedef unsigned int value_t;
/* Data structures used to define the tree. */
typedef struct DataNode {
	value_t value;
} DataNode;

typedef struct TreeNode {
	struct TreeNode *left_tree;
	struct TreeNode *mid_tree;
	struct TreeNode *right_tree;
	struct DataNode *left_data;
	struct DataNode *right_data;
} TreeNode;

/* The interface to the function flatten() that you're required to
 * implement is as follows: */
value_t *flatten(TreeNode *n, size_t *num_elements);

/*
 * In this function:
 * "TreeNode *n" is the pointer to the root node of the tree.
 *
 * "size_t *num_elements" should be filled with the number of elements in
 * the array on exit from the function.
 *
 * The return value "value_t *" should be a pointer to an array of elements
 * containing the values of the flattened tree.
 *
 * It is acceptable to solve this problem in either C or C++.
 *
 * Please describe any assumptions you've made, and the approach you've
 * used to test your implementation.
 */



value_t *flatten(TreeNode *n, size_t *num_elements) {
}



int main (){
	cout<<("shengyu shen\n")<<endl;
	return 0;
}
