

`line 1 "comment.v" 1
// first line in comment.v


/*


/*

*/

*/



//jump back to include.v
`line 4 "include.v" 2



`line 1 "directive.v" 1
`begin_keywords    
`celldefine         
`default_nettype        
`end_keywords        
`endcelldefine   
`nounconnected_drive   
`pragma   
`timescale   
`unconnected_drive  


//jump back to include.v
`line 7 "include.v" 2


// INFO : using ./include_dir/file_in_include.v as file_in_include.v
`line 1 "./include_dir/file_in_include.v" 1
//first line in file_in_include.v
`celldefine


`define ssy 1
`define ssy2 ssy
`define ssy3 `ssy
`define ssy4 sdf

`ssy
`ssy2
`ssy3


`ifdef ssy
	`ssy2
`endif


`undef ssy

`ifdef ssy
	`ssy2
`elsif ssy2
	`ssy3
`endif

`undef ssy2

`ifdef ssy
	`ssy2
`elsif ssy2
	`ssy3
`else 
	`ssy4
`endif
//last line in file_in_include.v
//jump back to include.v
`line 9 "include.v" 2

