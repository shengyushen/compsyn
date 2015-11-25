//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:22 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_ASYNC_BUS_DRS.v endFileName  

// --------------------------------------------------------------------
// IBM Confidential                                                    
// --------------------------------------------------------------------
// (C) Copyright IBM Corporation 2014                                  
//                                                                     
// Use of this design is restricted by terms and conditions specified  
// in the Design Kit License Agreement and the IBM customer            
// contract. Unauthorized use of this design is prohibited. Customer   
// is responsible to ensure this design is functional in the target    
// application. IBM and its agents are not responsible for operability 
// or support of this design if modifications are made to this code.   
//                                                                     
// Contact your IBM Field Application Engineer (FAE) for any updates   
// for this core.                                                      
// --------------------------------------------------------------------

//SCCS File Version= %I%
//Release Date= 11/05/17  00:24:35 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_ASYNC_BUS_DRS.v endFileName

// --------------------------------------------------------------------
// IBM Confidential
// --------------------------------------------------------------------
// (C) Copyright IBM Corporation 2011
//
// Use of this design is restricted by terms and conditions specified
// in the Design Kit License Agreement and the IBM customer
// contract. Unauthorized use of this design is prohibited. Customer
// is responsible to ensure this design is functional in the target
// application. IBM and its agents are not responsible for operability
// or support of this design if modifications are made to this code.
//
// Contact your IBM Field Application Engineer (FAE) for any updates
// for this core.
// --------------------------------------------------------------------

//$Id: XFIPCS_ASYNC_BUS_DRS.v,v 1.9 2014/04/03 12:17:03 huqian Exp $
//$Log: XFIPCS_ASYNC_BUS_DRS.v,v $
//Revision 1.9  2014/04/03 12:17:03  huqian
//Uncomment SYNCH_IBM_CU32HP to get specific IBM_CU32HP cells for XFIPCS_ASYNC_DRS and XFIPCS_ASYNC_BUS_DRS modules
//
//Revision 1.3  2011/02/08 16:22:19  adamc
//cvs_snap v1_23
//
//Revision 1.2  2011/02/08 16:05:10  adamc
//cvs_snap v1_22
//
//Revision 1.1  2011/02/07 20:15:13  adamc
//cvs_snap v1_21
//
//Revision 1.2  2010/08/05 19:23:27  farmer
//picked up RTL from /afs/btv/data/asiccores/xfipcs/release/synth/fdk_200909b/source
//
//
//-----------------------------------------------------------------------------
// Copyright IBM Corporation 2005
// IBM Confidential
//-----------------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS (
                        clk,
                        data_in,
                        data_out
                );

parameter       WIDTH = 2;
parameter       RANDOM_SEED = 0;
parameter       SHORT_DELAY=0;
parameter       NO_XSTATE=0;

input              clk;
input  [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;
wire   [WIDTH-1:0] data_out;

wire   [WIDTH-1:0] data_wam;


`ifdef XFIPCS_TOPLEVELNAME_WAM_ON
 wam_multibit #(
  .random_seed(RANDOM_SEED),
  .bus_width(WIDTH),
  .gated_data(0),
  .short_delay(SHORT_DELAY),
  .negative_edge(0),
  .no_xstate(NO_XSTATE))
  wam(.datain(data_in), .dataout(data_wam), .dst_clk(clk));
`else
assign data_wam = data_in;
`endif

`ifdef SYNCH_IBM_CU32HP

  genvar i;
  generate
    for (i=0; i < WIDTH; i=i+1)
      begin: b
        SYNCHR_X2M_A9TH drs1_reg ( .Q(data_out[i]), .D(data_wam[i]), .CK(clk), .R(1'b0), .SN(1'b1), .SE(1'b0), .SI(1'b0) );
      end
  endgenerate

`else // ~SYNCH_IBM_CU32HP

  reg    [WIDTH-1:0] drs1;
  reg    [WIDTH-1:0] drs2;

  always @(posedge clk)
    begin
      drs1 <= data_wam;
      drs2 <= drs1;
    end

  assign data_out = drs2;

`endif // SYNCH_IBM_CU32HP

endmodule
