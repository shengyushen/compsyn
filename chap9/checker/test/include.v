

`include "comment.v" haha to test something after include but on the same line

//`include "sss.v"
/*`include "sss.v"
`include "sss1.v"
*/


`include // sdf
"directive.v"

`include /*comment*/ "file_in_include.v"

`define sdf
`define sdf2

//`ifdef nodef2
/*
`undef sdf
`ifdef nodef1
*/

`ifdef sdf
sdf is defined
// sdf defined in comment1
/* sdf defined in comment2
*/
`elsif sdf2
sdf is not defined
// sdf defined in comment1 2
/* sdf defined in comment2 2
*/
`endif


`undef sdf

`ifdef sdf
sdf is defined
// sdf defined in comment1
/* sdf defined in comment2
*/
`elsif sdf2
sdf is not defined
// sdf defined in comment1 2
/* sdf defined in comment2 2
*/
`else
sdf 3 is not defined
`endif

`undef sdf2

`ifdef sdf
sdf is defined
// sdf defined in comment1
/* sdf defined in comment2
*/
`elsif sdf2
sdf is not defined
// sdf defined in comment1 2
/* sdf defined in comment2 2
*/
`else
sdf 3 is not defined
`endif

