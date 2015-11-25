//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:00 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_SDR_TO_DDR.v endFileName  

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

//$Id: XFIPCS_RX_SDR_TO_DDR.v,v 1.8 2014/02/21 07:12:00 huqian Exp $
//$Log: XFIPCS_RX_SDR_TO_DDR.v,v $
//Revision 1.8  2014/02/21 07:12:00  huqian
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

module `XFIPCS_TOPLEVELNAME_RX_SDR_TO_DDR (
                        xgmii_clk,
                        reset_to_xgmii,

                        rxc_sdr,
                        rxd_sdr,

                        rxc,
                        rxd
                );

input                   xgmii_clk;
input                   reset_to_xgmii;

input   [7:0]           rxc_sdr;
input   [63:0]          rxd_sdr;
`ifdef XFIPCS_TOPLEVELNAME_DDR
reg     [3:0]           control_pos;
reg     [3:0]           control_neg;
reg     [31:0]          data_pos;
reg     [31:0]          data_neg;
output  [3:0]           rxc;
wire    [3:0]           rxc;
output  [31:0]          rxd;
wire    [31:0]          rxd;
`else
reg     [7:0]           control_pos;
reg     [63:0]          data_pos;
output  [7:0]           rxc;
wire    [7:0]           rxc;
output  [63:0]          rxd;
wire    [63:0]          rxd;
`endif


`ifdef XFIPCS_TOPLEVELNAME_DDR
 always @(posedge xgmii_clk)
   begin
     control_pos <= rxc_sdr[7:4];
     data_pos <= rxd_sdr[63:32];
   end

 always @(negedge xgmii_clk)
   begin
     control_neg <= rxc_sdr[3:0];
     data_neg <= rxd_sdr[31:0];
   end

 assign rxc = xgmii_clk ? control_neg : control_pos;
 assign rxd = xgmii_clk ? data_neg : data_pos;
`else
 always @(posedge xgmii_clk)
   begin
     control_pos <= rxc_sdr[7:0];
     data_pos <= rxd_sdr[63:0];
   end

 assign rxc = control_pos;
 assign rxd = data_pos;
`endif

endmodule
