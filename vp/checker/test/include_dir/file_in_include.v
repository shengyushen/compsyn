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


`resetall

`ifdef ssy
	`ssy2
`elsif ssy2
	`ssy3
`else 
	`ssy4
`endif
//last line in file_in_include.v
