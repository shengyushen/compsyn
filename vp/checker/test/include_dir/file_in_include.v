//first line in file_in_include.v
`celldefine


`define ssy 1
`define ssy2 ssy
`define ssy3 `ssy

`ssy
`ssy2
`ssy3


`ifdef ssy
	`ssy2
`else
	`ssy3
`endif


`undef ssy

`ssy
//last line in file_in_include.v
