//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:02 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_TPC.v endFileName  

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

//$Id: XFIPCS_RX_TPC.v,v 1.8 2014/02/21 07:12:01 huqian Exp $
//$Log: XFIPCS_RX_TPC.v,v $
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.6  2014/02/21 06:52:41  huqian
//Fix HW280868
//
//Revision 1.5  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.4  2013/09/17 05:56:48  huqian
//Initial 32G Fibre Channel
//
//Revision 1.3  2011/01/25 21:26:15  adamc
//Updated reset logic
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

module `XFIPCS_TOPLEVELNAME_RX_TPC (
                        pma_rx_clk,
                        reset_to_pma_rx,
`ifdef XFIPCS_16G32GFC                        
                        pma_rx_clk_div2_high,
`endif                        

                        block_lock,
                        rx_prbs_pat_en,
                        rx_test_pat_en,
                        test_pat_sel,
                        test_data_in,
                        test_data_valid,
                        prbs_data,
                        clear_tpec_tog,

                        tpec_pma_gray,
                        tpec_15_8_inc_tog
                );

input           pma_rx_clk;
input           reset_to_pma_rx;
`ifdef XFIPCS_16G32GFC
input           pma_rx_clk_div2_high;
`endif
input           block_lock;
input           rx_prbs_pat_en;
input           rx_test_pat_en;
input           test_pat_sel;
input           test_data_valid;
input   [65:0]  test_data_in;
input   [31:0]  prbs_data;
input           clear_tpec_tog;

output  [7:0]   tpec_pma_gray;
output          tpec_15_8_inc_tog;
reg     [7:0]   tpec_pma_bin;
wire    [7:0]   tpec_pma_bin_nxt;
reg     [7:0]   tpec_pma_gray;
wire    [7:0]   tpec_pma_gray_nxt;

wire    [30:0]  data_prev_in;
reg     [30:0]  data_prev;

wire            clear_tpec_pma;

wire    [31:0]  data_pattern_error;
wire    [5:0]   prbs_pat_error;
wire            tpec_inc_nxt;
reg             tpec_inc;
wire    [6:0]   block_counter_nxt;
reg     [6:0]   block_counter;
wire            first_fail_nxt;
reg             first_fail;
wire            prtp_error;
wire            rx_prbs_pat_en_pma;
wire            rx_test_pat_en_pma;
wire            test_pat_sel_pma;
wire    [31:0]  dpe;
wire    [1:0]   count_2_0;
wire    [1:0]   count_5_3;
wire    [1:0]   count_8_6;
wire    [1:0]   count_11_9;
wire    [1:0]   count_14_12;
wire    [1:0]   count_17_15;
wire    [1:0]   count_20_18;
wire    [1:0]   count_23_21;
wire    [1:0]   count_26_24;
wire    [1:0]   count_29_27;
wire    [1:0]   count_31_30;
wire    [3:0]   count_11_0_nxt;
wire    [3:0]   count_20_12_nxt;
wire    [3:0]   count_31_21_nxt;
reg     [3:0]   count_11_0;
reg     [3:0]   count_20_12;
reg     [3:0]   count_31_21;

assign data_pattern_error = ~prbs_data ^
                           {~prbs_data[3:0], data_prev[30:3]} ^
                           {~prbs_data[0]  , data_prev[30:0]} ;
assign data_prev_in = ~prbs_data[31:1];
assign dpe = data_pattern_error;
assign count_2_0  [0] = dpe[0 ] ^ dpe[1 ] ^ dpe[2 ] ;
assign count_5_3  [0] = dpe[3 ] ^ dpe[4 ] ^ dpe[5 ] ;
assign count_8_6  [0] = dpe[6 ] ^ dpe[7 ] ^ dpe[8 ] ;
assign count_11_9 [0] = dpe[9 ] ^ dpe[10] ^ dpe[11] ;
assign count_14_12[0] = dpe[12] ^ dpe[13] ^ dpe[14] ;
assign count_17_15[0] = dpe[15] ^ dpe[16] ^ dpe[17] ;
assign count_20_18[0] = dpe[18] ^ dpe[19] ^ dpe[20] ;
assign count_23_21[0] = dpe[21] ^ dpe[22] ^ dpe[23] ;
assign count_26_24[0] = dpe[24] ^ dpe[25] ^ dpe[26] ;
assign count_29_27[0] = dpe[27] ^ dpe[28] ^ dpe[29] ;
assign count_31_30[0] = dpe[30] ^ dpe[31]           ;
assign count_2_0  [1] = (dpe[0 ] && dpe[1 ]) || (dpe[2 ] && dpe[0 ]) || (dpe[1 ] && dpe[2 ]) ;
assign count_5_3  [1] = (dpe[3 ] && dpe[4 ]) || (dpe[5 ] && dpe[3 ]) || (dpe[4 ] && dpe[5 ]) ;
assign count_8_6  [1] = (dpe[6 ] && dpe[7 ]) || (dpe[8 ] && dpe[6 ]) || (dpe[7 ] && dpe[8 ]) ;
assign count_11_9 [1] = (dpe[9 ] && dpe[10]) || (dpe[11] && dpe[9 ]) || (dpe[10] && dpe[11]) ;
assign count_14_12[1] = (dpe[12] && dpe[13]) || (dpe[14] && dpe[12]) || (dpe[13] && dpe[14]) ;
assign count_17_15[1] = (dpe[15] && dpe[16]) || (dpe[17] && dpe[15]) || (dpe[16] && dpe[17]) ;
assign count_20_18[1] = (dpe[18] && dpe[19]) || (dpe[20] && dpe[18]) || (dpe[19] && dpe[20]) ;
assign count_23_21[1] = (dpe[21] && dpe[22]) || (dpe[23] && dpe[21]) || (dpe[22] && dpe[23]) ;
assign count_26_24[1] = (dpe[24] && dpe[25]) || (dpe[26] && dpe[24]) || (dpe[25] && dpe[26]) ;
assign count_29_27[1] = (dpe[27] && dpe[28]) || (dpe[29] && dpe[27]) || (dpe[28] && dpe[29]) ;
assign count_31_30[1] = (dpe[30] && dpe[31]) ;
assign count_11_0_nxt = {2'b00, count_2_0} + {2'b00, count_5_3} +
                    {2'b00, count_8_6} + {2'b00, count_11_9} ;
assign count_20_12_nxt = {2'b00, count_14_12} + {2'b00, count_17_15} +
                     {2'b00, count_20_18} ;
assign count_31_21_nxt = {2'b00, count_23_21} + {2'b00, count_26_24} +
                     {2'b00, count_29_27} + {2'b00, count_31_30} ;
assign prbs_pat_error = ~rx_prbs_pat_en_pma ? 6'h00 :
                        {2'b00, count_31_21} +
                        {2'b00, count_20_12} +
                        {2'b00, count_11_0} ;
assign tpec_inc_nxt = rx_test_pat_en_pma & first_fail & prtp_error ;

wire test_data_valid_pmaclk;
`ifdef XFIPCS_16G32GFC
assign test_data_valid_pmaclk = test_data_valid & pma_rx_clk_div2_high;
`else
assign test_data_valid_pmaclk = test_data_valid;
`endif
assign block_counter_nxt = test_data_valid_pmaclk                ? block_counter + 1 :
                                                                block_counter ;
assign first_fail_nxt = |block_counter_nxt && (first_fail || prtp_error) ;
assign prtp_error = test_data_valid_pmaclk && rx_test_pat_en_pma &&
                    ~test_pat_sel_pma && block_lock &&
                                       test_data_in != 66'h00000000000000001 &&
                                       test_data_in != 66'h3fffffffffffffffd &&
                                       test_data_in != 66'h00400000004000155 &&
                                       test_data_in != 66'h3fbfffffffbfffea9;

`XFIPCS_TOPLEVELNAME_ASYNC_DRS async001(
                        .clk         (pma_rx_clk       ),
                        .data_in     (clear_tpec_tog   ),
                        .data_out    (clear_tpec_pma   )
                );

`XFIPCS_TOPLEVELNAME_ASYNC_DRS async002(
                        .clk         (pma_rx_clk        ),
                        .data_in     (rx_prbs_pat_en    ),
                        .data_out    (rx_prbs_pat_en_pma)
                );

`XFIPCS_TOPLEVELNAME_ASYNC_DRS async003(
                        .clk         (pma_rx_clk        ),
                        .data_in     (rx_test_pat_en    ),
                        .data_out    (rx_test_pat_en_pma)
                );

`XFIPCS_TOPLEVELNAME_ASYNC_DRS async004(
                        .clk         (pma_rx_clk        ),
                        .data_in     (test_pat_sel      ),
                        .data_out    (test_pat_sel_pma  )
                );

assign tpec_pma_bin_nxt = clear_tpec_pma ? 8'h00 :
                          tpec_inc       ? tpec_pma_bin + 1 :
                                           tpec_pma_bin + {2'h0, prbs_pat_error};
assign tpec_pma_gray_nxt = tpec_pma_bin ^ {1'b0, tpec_pma_bin[7:1]};

wire tpec_15_8_inc;
assign tpec_15_8_inc = (tpec_pma_bin[7:6] == 2'b11 &&
                        tpec_pma_bin_nxt[7:6] == 2'b00);
 
reg tpec_15_8_inc_r1, tpec_15_8_inc_r2, tpec_15_8_inc_r3;
reg tpec_15_8_inc_tog;
always @(posedge pma_rx_clk)
  begin
    if (tpec_15_8_inc || tpec_15_8_inc_r1 || tpec_15_8_inc_r2 || tpec_15_8_inc_r3) begin
     tpec_15_8_inc_tog <= 1'b1;
    end else begin
     tpec_15_8_inc_tog <= 1'b0;
    end
 
    tpec_15_8_inc_r3 <= tpec_15_8_inc_r2;
    tpec_15_8_inc_r2 <= tpec_15_8_inc_r1;
    tpec_15_8_inc_r1 <= tpec_15_8_inc;
  end

always @(posedge pma_rx_clk)
  begin
   if (reset_to_pma_rx) begin
    data_prev <= 31'h40000000;
    block_counter <= 7'h00;
    tpec_pma_bin <= 8'h00;
    tpec_pma_gray <= 8'h00;
   end else begin
    data_prev <= data_prev_in;
    block_counter <= block_counter_nxt;
    tpec_pma_bin <= tpec_pma_bin_nxt ;
    tpec_pma_gray <= tpec_pma_gray_nxt ;
   end

   tpec_inc <= tpec_inc_nxt ;
   first_fail <= first_fail_nxt ;
   count_11_0 <= count_11_0_nxt ;
   count_20_12 <= count_20_12_nxt ;
   count_31_21 <= count_31_21_nxt ;
  end

endmodule
