//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:05 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_DDR_TO_SDR.v endFileName  

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

//$Id: XFIPCS_TX_DDR_TO_SDR.v,v 1.8 2014/02/21 07:12:01 huqian Exp $
//$Log: XFIPCS_TX_DDR_TO_SDR.v,v $
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.3  2011/02/17 21:13:08  adamc
//cvs_snap v1_28
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

module `XFIPCS_TOPLEVELNAME_TX_DDR_TO_SDR (
                        xgmii_clk,
                        reset_to_xgmii,

                        txc,
                        txd,

                        txc_sdr,
                        txd_sdr
                );

input                   xgmii_clk;
input                   reset_to_xgmii;

`ifdef XFIPCS_TOPLEVELNAME_DDR
input   [3:0]           txc;
input   [31:0]          txd;
reg     [31:0]          data_neg_edge;
reg     [3:0]           control_neg_edge;
`else
input   [7:0]           txc;
input   [63:0]          txd;
`endif

output  [7:0]           txc_sdr;
reg     [7:0]           txc_sdr;
output  [63:0]          txd_sdr;
reg     [63:0]          txd_sdr;

wire    [7:0]           control_wide;
wire    [63:0]          data_wide;

`ifdef XFIPCS_TOPLEVELNAME_DDR
wire    [3:0]           control_in;
wire    [31:0]          data_in;

 assign control_in = (reset_to_xgmii == 1'b1)                     ? 4'h0 : txc ;
 assign data_in = (reset_to_xgmii == 1'b1)                ? 32'h00000000 : txd ;

 always @(negedge xgmii_clk)
   begin
     control_neg_edge <= control_in;
     data_neg_edge <= data_in;
   end

 assign control_wide = {control_in, control_neg_edge};
 assign data_wide = {data_in, data_neg_edge};
`else
 assign control_wide = txc;
 assign data_wide = txd;
`endif

 always @(posedge xgmii_clk)
   begin
     txc_sdr <= control_wide;
     txd_sdr <= data_wide;
   end

endmodule
