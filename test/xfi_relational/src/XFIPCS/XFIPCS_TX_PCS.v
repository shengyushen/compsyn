
`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_TX_PCS (
                        pma_tx_clk,
                        reset_to_pma_tx,
                        reset_to_xgmii_tx,

                        enable_alternate_refresh,
                        ALTERNATE_ENCODE,
                        loopback_xgmii,
                        txc_xfi,
                        txd_xfi,
												tx_fifo_pop_pre,
                        test_pat_seed_a,
                        test_pat_seed_b,
                        tx_prbs_pat_en,
                        tx_test_pat_en,
                        test_pat_sel,
                        data_pat_sel,
                        scr_bypass_enable,

                        tx_data_out,
												tx_fifo_pop_2,
                        tx_mode,
                        t_type_li,
                        TXxQUIET,
                        TXxREFRESH,
												assertion_shengyushen
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           pma_tx_clk;
input           reset_to_pma_tx;
input           reset_to_xgmii_tx;

input           enable_alternate_refresh;
input           loopback_xgmii;
input   [7:0]   txc_xfi;
input   [63:0]  txd_xfi;
input            tx_fifo_pop_pre;
input   [57:0]  test_pat_seed_a;
input   [57:0]  test_pat_seed_b;
input           tx_prbs_pat_en;
input           tx_test_pat_en;
input           test_pat_sel;
input           data_pat_sel;
input           ALTERNATE_ENCODE;
input           scr_bypass_enable;

output  [65:0]  tx_data_out;
output					tx_fifo_pop_2;
output  [1:0]   tx_mode;
output          t_type_li;
output          TXxQUIET;
output          TXxREFRESH;

output				assertion_shengyushen;
// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire            tx_fifo_pop;
wire            tx_fifo_pop_2;

wire    [65:0]  tx_data_out;
wire    [65:0]  tx_data_out_loopback;
wire    [31:0]  tx_gearbox_data_out;
wire            tx_local_fault;
reg             tx_local_fault_pma;

wire    [7:0]   encoder_control_in;
wire    [7:0]   txc_xfi;
wire    [63:0]  encoder_data_in;
wire    [63:0]  txd_xfi;
wire    [65:0]  tx_data_66b;

wire            tx_prbs_pat_en;
wire            tx_test_pat_en;
wire            test_mode_enc_nxt ;
reg             test_mode_enc ;
wire            test_mode_square_nxt ;
wire    [65:0]  test_data_out=66'b0;
wire            tx_prbs_pat_en_pma;
reg             square_wave;
wire            square_wave_nxt;
wire            square_wave_pma;
//wire            tx_fifo_hold;

wire            scr_bypass_enable;
wire            scr_bypass_enable_pma;
wire            scrambler_bypass;

wire            t_type_li;
wire            tx_active;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TX_FIFO_BYPASS = 1'b0;

parameter DATA  = 2'b00;
parameter QUIET = 2'b01;
parameter ALERT = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign tx_data_out_loopback =  (tx_prbs_pat_en_pma) ? test_data_out :tx_data_66b ;
 assign tx_data_out = (square_wave_pma || (tx_mode == ALERT))  ? 66'h0 : tx_data_out_loopback;

 assign test_mode_enc_nxt = tx_test_pat_en && ~test_pat_sel ;
 assign test_mode_square_nxt = tx_test_pat_en && test_pat_sel ;

 assign tx_fifo_pop = tx_fifo_pop_pre /*&& ~tx_fifo_hold */;


 `XFIPCS_TOPLEVELNAME_TX_FLOW  flow(
                         .pma_tx_clk              (pma_tx_clk             ),
                         .reset_to_pma_tx         (reset_to_pma_tx        ),

                         .enable_alternate_refresh (enable_alternate_refresh),
                         .ALTERNATE_ENCODE        (ALTERNATE_ENCODE),
                         .tx_fifo_pop             (tx_fifo_pop            ),
                         .txc_xfi                 (txc_xfi                ),
                         .txd_xfi                 (txd_xfi                ),
                         .scr_bypass_enable       (scr_bypass_enable_pma  ),

                         .tx_fifo_pop_2           (tx_fifo_pop_2          ),
                         .encoder_control_in      (encoder_control_in     ),
                         .encoder_data_in         (encoder_data_in        ),
                         .tx_local_fault          (tx_local_fault         ),
                         .tx_mode                 (tx_mode                ),
                         .scrambler_bypass        (scrambler_bypass       ),
                         .t_type_li               (t_type_li              ),
                         .tx_active               (tx_active              ),
                         .TXxQUIET                (TXxQUIET               ),
                         .TXxREFRESH              (TXxREFRESH             )
                 );

 `XFIPCS_TOPLEVELNAME_64B66B_ENC  enc(
                         .CLK                    (pma_tx_clk             ),
                         .RESET                  (reset_to_pma_tx        ),

                         .ALTERNATE_ENCODE       (ALTERNATE_ENCODE),
                         .DATA_VALID             (tx_fifo_pop_2          ),
                         .ENCODER_DATA_IN        (encoder_data_in        ),
                         .ENCODER_CONTROL_IN     (encoder_control_in     ),
                         .TEST_PAT_SEED_A        (test_pat_seed_a        ),
                         .TEST_PAT_SEED_B        (test_pat_seed_b        ),
                         .TEST_MODE              (test_mode_enc          ),
                         .DATA_PAT_SEL           (data_pat_sel           ),
                         .scrambler_bypass       (scrambler_bypass       ),

                         .ENCODER_DATA_OUT       (tx_data_66b            )
                 );

 assign square_wave_nxt = loopback_xgmii || test_mode_square_nxt || reset_to_xgmii_tx ;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async001(.clk      (pma_tx_clk),
                                         .data_in  (tx_prbs_pat_en),
                                         .data_out (tx_prbs_pat_en_pma)
                                        );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async002(.clk      (pma_tx_clk),
                                         .data_in  (square_wave),
                                         .data_out (square_wave_pma)
                                        );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async003(.clk      (pma_tx_clk),
                                         .data_in  (scr_bypass_enable),
                                         .data_out (scr_bypass_enable_pma)
                                        );

 // This is used in the MDIO unit for reg 1 bit 9. If we get a small blip
 // of LPIs to cause it to leave the active state but then go right back,
 // it doesn't matter if the MDIO reg reflects this (or misses it)


 always @(posedge pma_tx_clk)
 begin
   test_mode_enc <= test_mode_enc_nxt;
   square_wave <= square_wave_nxt;
 end

 always @(posedge pma_tx_clk)
 begin
   tx_local_fault_pma <= tx_local_fault;
 end
//according to original XFIPCS.v ALTERNATE_ENCODE can be disable and set to 0 
assign	assertion_shengyushen=(enable_alternate_refresh==1'b0 && tx_test_pat_en==1'b0 && loopback_xgmii==1'b0 && test_pat_sel==1'b0 && reset_to_xgmii_tx==1'b0 && reset_to_pma_tx==1'b0 && tx_prbs_pat_en==1'b0 && data_pat_sel==1'b0 && scr_bypass_enable==1'b0 && ALTERNATE_ENCODE==1'b0 && txc_xfi==8'b0 && encoder_control_in==8'b0);

endmodule
