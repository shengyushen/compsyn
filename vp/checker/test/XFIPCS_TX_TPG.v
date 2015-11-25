//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:23 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_TPG.v endFileName  

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

//$Id: XFIPCS_TX_TPG.v,v 1.8 2014/02/21 07:12:01 huqian Exp $
//$Log: XFIPCS_TX_TPG.v,v $
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.4  2013/12/12 03:29:21  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.3  2013/09/17 06:09:00  huqian
//Initial 32G Fibre Channel
//
//Revision 1.2  2010/08/05 19:23:27  farmer
//picked up RTL from /afs/btv/data/asiccores/xfipcs/release/synth/fdk_200909b/source
//
//
//-----------------------------------------------------------------------------
// Copyright IBM Corporation 2006
// IBM Confidential
//-----------------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_TX_TPG (
                        pma_tx_clk,
                        reset_to_pma_tx,

                        tx_prbs_pat_en,

                        test_data_out
                );

input           pma_tx_clk;
input           reset_to_pma_tx;
input           tx_prbs_pat_en;

`ifdef XFIPCS_16G32GFC
output  [63:0]  test_data_out;
wire    [63:0]  test_data_out;
 
wire            data_scrambled_31_lo32b, data_scrambled_31_hi32b;
wire    [2:0]   data_scrambled_30_28_lo32b, data_scrambled_30_28_hi32b;
wire    [27:0]  data_scrambled_27_0_lo32b, data_scrambled_27_0_hi32b;
wire    [31:0]  data_scrambled_lo32b, data_scrambled_hi32b;
wire    [30:0]  data_prev_hi32b;
wire    [30:0]  data_prev_lo32b_nxt;
reg     [30:0]  data_prev_lo32b;
      
assign data_scrambled_27_0_lo32b = data_prev_lo32b[27:0] ^ data_prev_lo32b[30:3];
assign data_scrambled_30_28_lo32b = data_scrambled_27_0_lo32b[2:0] ^ data_prev_lo32b[30:28];
assign data_scrambled_31_lo32b = data_scrambled_27_0_lo32b[3] ^ data_scrambled_27_0_lo32b[0];
assign data_scrambled_lo32b = {data_scrambled_31_lo32b, data_scrambled_30_28_lo32b, data_scrambled_27_0_lo32b};
assign data_prev_hi32b = reset_to_pma_tx || ~tx_prbs_pat_en ? 31'h40000000 : data_scrambled_lo32b[31:1] ;

assign data_scrambled_27_0_hi32b = data_prev_hi32b[27:0] ^ data_prev_hi32b[30:3];
assign data_scrambled_30_28_hi32b = data_scrambled_27_0_hi32b[2:0] ^ data_prev_hi32b[30:28];
assign data_scrambled_31_hi32b = data_scrambled_27_0_hi32b[3] ^ data_scrambled_27_0_hi32b[0];
assign data_scrambled_hi32b = {data_scrambled_31_hi32b, data_scrambled_30_28_hi32b, data_scrambled_27_0_hi32b};
assign data_prev_lo32b_nxt = reset_to_pma_tx || ~tx_prbs_pat_en ? 31'h40000000 : data_scrambled_hi32b[31:1] ;

assign test_data_out = {~data_scrambled_hi32b, ~data_scrambled_lo32b};
 
always @(posedge pma_tx_clk)
  begin
    data_prev_lo32b <= data_prev_lo32b_nxt ;
  end
`else
output  [31:0]  test_data_out;
wire    [31:0]  test_data_out;

wire            data_scrambled_31;
wire    [2:0]   data_scrambled_30_28;
wire    [27:0]  data_scrambled_27_0;
wire    [31:0]  data_scrambled;
wire    [30:0]  data_prev_in;
reg     [30:0]  data_prev;

assign data_scrambled_27_0 = data_prev[27:0] ^ data_prev[30:3];
assign data_scrambled_30_28 = data_scrambled_27_0[2:0] ^ data_prev[30:28];
assign data_scrambled_31 = data_scrambled_27_0[3] ^ data_scrambled_27_0[0];
assign data_scrambled = {data_scrambled_31, data_scrambled_30_28, data_scrambled_27_0};
assign data_prev_in = reset_to_pma_tx || ~tx_prbs_pat_en ? 31'h40000000 : data_scrambled[31:1] ;
assign test_data_out = ~data_scrambled;

always @(posedge pma_tx_clk)
  begin
    data_prev <= data_prev_in ;
  end
`endif

endmodule
