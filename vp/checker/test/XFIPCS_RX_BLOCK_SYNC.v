//SCCS File Version= %I%
//Release Date= 14/04/20  19:56:44 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_BLOCK_SYNC.v endFileName

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

//$Id: XFIPCS_RX_BLOCK_SYNC.v,v 1.10 2014/04/16 13:32:47 huqian Exp $
//$Log: XFIPCS_RX_BLOCK_SYNC.v,v $
//Revision 1.10  2014/04/16 13:32:47  huqian
//Fix possible gate level simulation issue
//
//Revision 1.9  2014/03/06 05:57:08  huqian
//Fix HW282243: hi_ber flag is wrong
//
//Revision 1.8  2014/02/21 07:12:00  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.13  2014/01/23 08:02:49  huqian
//Add support of very small skew between PMA_RX_CLK and PMA_RX_CLK_DIV2 rising edges
//
//Revision 1.4  2014/01/20 07:54:42  huqian
//Copy XFIPCS cvs tag v1_131
//
//Revision 1.12  2014/01/20 05:18:23  huqian
//Fix coding errors reported by Brocade(no functional change)
//
//Revision 1.11  2014/01/06 03:14:34  huqian
//Registered ENABLE_RX_66B_IN/FEC_RX_DATA_66B_VALID/FEC_RX_DATA_66B for timing closure
//
//Revision 1.10  2013/12/26 08:16:35  huqian
//Update loopback rx data path
//
//Revision 1.9  2013/12/17 03:41:44  huqian
//Bypass 32bit-to-66bit gearbox and slip function when connect with 32G FEC
//
//Revision 1.8  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.7  2013/10/28 03:29:33  huqian
//Update watermark to H2O_XFIPCS_003_00
//
//Revision 1.6  2013/09/17 05:51:51  huqian
//Initial 32G Fibre Channel
//
//Revision 1.5  2011/04/20 20:32:25  adamc
//Update to block_sync for rapid block lock during WAKE with FEC
//
//Revision 1.4  2011/01/25 21:26:14  adamc
//Updated reset logic
//
//Revision 1.3  2010/12/08 21:06:25  adamc
//Initial glue logic updates for AZ
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

module `XFIPCS_TOPLEVELNAME_RX_BLOCK_SYNC (
                        pma_rx_clk,
                        reset_to_pma_rx,
`ifdef XFIPCS_16G32GFC
                        pma_rx_clk_div2,
                        reset_to_pma_rx_div2,
                        enable_rx_66b_in,
                        fec_rx_data_66b,
                        fec_rx_data_66b_valid,
`endif

                        loopback_xgmii,
                        pma_rx_ready_flop,
                        rx_data_in,
                        tx_data_out_loopback,
                        rx_lpi_active,
                        rx_mode,
                        scr_bypass_enable,

`ifdef XFIPCS_16G32GFC
                        pma_rx_clk_div2_high,
                        loopback_pma_rx,
`endif
                        rx_block_lock,
                        rx_data_66b,
                        data_valid,
                        prbs_data,
                        sh_valid
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input                   pma_rx_clk;
input                   reset_to_pma_rx;
`ifdef XFIPCS_16G32GFC
input                   pma_rx_clk_div2;
input                   reset_to_pma_rx_div2;
input                   enable_rx_66b_in;
input   [65:0]          fec_rx_data_66b;
input                   fec_rx_data_66b_valid;
`endif

input   [31:0]          rx_data_in;
`ifdef XFIPCS_16G32GFC
input   [63:0]          tx_data_out_loopback;
`else
input   [31:0]          tx_data_out_loopback;
`endif
input                   loopback_xgmii;
input                   pma_rx_ready_flop;
input                   rx_lpi_active;
input                   rx_mode;
input                   scr_bypass_enable;

`ifdef XFIPCS_16G32GFC
output                  pma_rx_clk_div2_high;
output                  loopback_pma_rx;
`endif
output                  rx_block_lock;
output  [65:0]          rx_data_66b;
output                  data_valid;
output  [31:0]          prbs_data;
output                  sh_valid;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter DATA  = 1'b0;
parameter QUIET = 1'b1;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
`ifdef XFIPCS_16G32GFC
reg                     data_valid_in;
`else
wire                    data_valid_in;
`endif
reg                     data_valid;
reg     [65:0]          rx_data_66b;
wire    [65:0]          rx_data_66b_in;
wire                    rx_block_lock;
wire    [31:0]          prbs_data;
wire                    sh_valid;
wire                    slip;
reg                     H2O_XFIPCS_003_08;
wire                    slip_done_set;
//wire                    do_slip;
`ifdef XFIPCS_16G32GFC
reg     [5:0]           sh_offset, sh_offset_nxt, sh_offset_r1;
`else
wire    [4:0]           sh_offset;
`endif
wire    [6:0]           sh_pointer_in;
reg     [6:0]           sh_pointer;
`ifdef XFIPCS_16G32GFC
reg     [129:0]         data_reg;
wire    [129:0]         data_reg_in;
reg                     test_sh_set;
`else
reg     [97:0]          data_reg;
wire    [97:0]          data_reg_in;
wire                    test_sh_set;
`endif
wire                    loopback_pma_rx;
`ifdef XFIPCS_16G32GFC
wire    [63:0]          data_in;
`else
wire    [31:0]          data_in;
`endif
wire                    slip_done_set_nxt;
wire                    signal_ok;

wire                    unscram_i_found;
reg  [2:0]              ignore_slip_count;
wire [2:0]              ignore_slip_count_nxt;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 `ifdef XFIPCS_16G32GFC
 reg pma_rx_clk_div2_high;
 wire pma_rx_clk_div2_high_nxt;
 reg [31:0] prbs_data_high, prbs_data_low;

 always @(posedge pma_rx_clk_div2)
   begin
     prbs_data_high <= data_reg_in[97:66];
     prbs_data_low <= data_reg_in[129:98];
   end

 assign prbs_data = pma_rx_clk_div2_high ? prbs_data_high : prbs_data_low;
 `else
 assign prbs_data = data_reg[97:66];
 `endif

 assign signal_ok = pma_rx_ready_flop | loopback_pma_rx ;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async000(
                         `ifdef XFIPCS_16G32GFC
                         .clk         (pma_rx_clk_div2        ),
                         `else
                         .clk         (pma_rx_clk             ),
                         `endif
                         .data_in     (loopback_xgmii         ),
                         .data_out    (loopback_pma_rx        )
                 );

 // Rapid block lock ability here. Look for unscrambled /I/'s and /LI/'s and immediately lock
 `ifdef XFIPCS_16G32GFC
 assign unscram_i_found = ~loopback_pma_rx & rx_lpi_active & (rx_mode == DATA) & (scr_bypass_enable) &
                          ((data_reg[97:32] == 66'h00000000000000079) | (data_reg[97:32] == 66'h03060c183060c1879));
 `else
 assign unscram_i_found = ~loopback_pma_rx & rx_lpi_active & (rx_mode == DATA) & (scr_bypass_enable) &
                          ((data_reg[65:0] == 66'h00000000000000079) | (data_reg[65:0] == 66'h03060c183060c1879));
 `endif

 assign ignore_slip_count_nxt = (unscram_i_found)           ? 3'h7 :
                                (ignore_slip_count != 3'h0) ? ignore_slip_count - 3'h1 : ignore_slip_count;

 `ifdef XFIPCS_16G32GFC
 reg  [31:0] rx_data_in_r1;
 reg  [63:0] rx_data_in_64b;

 always @(posedge pma_rx_clk)
   begin
     rx_data_in_r1 <= rx_data_in;
     rx_data_in_64b <= {rx_data_in, rx_data_in_r1};
   end

 ///reg  [31:0] rx_data_in_neg;
 ///wire [63:0] rx_data_in_64b;

 /*always @(negedge pma_rx_clk_div2)
   begin
     rx_data_in_neg <= rx_data_in_r1;
   end*/
 ///always @(posedge pma_rx_clk)
 ///  begin
 ///    if (pma_rx_clk_div2_high)
 ///     rx_data_in_neg <= rx_data_in_r1;
 ///  end
 ///assign rx_data_in_64b = {rx_data_in_r1, rx_data_in_neg};
 assign data_in = (loopback_pma_rx) ? tx_data_out_loopback : rx_data_in_64b;
 `else
 assign data_in = (loopback_pma_rx) ? tx_data_out_loopback : rx_data_in;
 `endif

 assign sh_pointer_in = (unscram_i_found)                        ? 7'd34 :
                        (slip_done_set_nxt && (ignore_slip_count == 3'h0) && (sh_pointer > 31)) ? sh_pointer - 31 :
                        (slip_done_set_nxt && (ignore_slip_count == 3'h0))                      ? sh_pointer + 35 :
                                                                             (sh_pointer > 31)  ? sh_pointer - 32 :
                                                                                                  sh_pointer + 34 ;
 `ifdef XFIPCS_16G32GFC
 reg slip_r1;
 always @(posedge pma_rx_clk_div2)
   if (reset_to_pma_rx_div2) begin
     slip_r1 <= 1'b0;
   end
   else begin
     slip_r1 <= slip;
   end

 always @(*)
   begin
    if (reset_to_pma_rx_div2 || unscram_i_found)
     sh_offset_nxt = 6'd34;
    else if (!data_valid)
     sh_offset_nxt = sh_offset;
    else begin
     //if (slip_done_set_nxt && (ignore_slip_count == 3'h0))
     if (slip && !slip_r1 && (ignore_slip_count == 3'h0))
      sh_offset_nxt = sh_offset + 3;
     else
      sh_offset_nxt = sh_offset + 2;
    end
   end

 reg [5:0] data_valid_cnt, data_valid_cnt_nxt;
 always @(posedge pma_rx_clk_div2)
   begin
     if (reset_to_pma_rx_div2 || unscram_i_found) begin
      sh_offset_r1 <= 6'd34;
      sh_offset <= 6'd34;
     end
     else begin
      sh_offset_r1 <= sh_offset;
      sh_offset <= sh_offset_nxt;
     end
   end

 always @(*)
   begin
     if (reset_to_pma_rx_div2)
       data_valid_in = 1'b0;
     else if ((sh_offset!=6'd63) && (sh_offset!=6'd62))
       data_valid_in = 1'b1;
     else if (data_valid_cnt==6'd15)
       data_valid_in = 1'b1;
     else begin
       data_valid_in = 1'b0;
     end
   end

 assign pma_rx_clk_div2_high_nxt = reset_to_pma_rx_div2 ? 1'b1 : ~pma_rx_clk_div2_high;
 always @(posedge pma_rx_clk)
   begin
     pma_rx_clk_div2_high <= pma_rx_clk_div2_high_nxt;
   end

 always @(*)
   if (reset_to_pma_rx_div2)
     test_sh_set = 1'b0;
   else if (sh_offset_r1==6'd63)
     test_sh_set = 1'b0;
   else
     test_sh_set = ~pma_rx_clk_div2_high;
 `else
 assign data_valid_in = ~reset_to_pma_rx & (sh_pointer_in[6:5] == 2'b00);
 assign sh_offset = sh_pointer[4:0];
 assign test_sh_set = (sh_pointer < 32);
 `endif

 `ifdef XFIPCS_16G32GFC
 assign data_reg_in = {data_in, data_reg[129:64]};
 assign slip_done_set_nxt = slip & pma_rx_clk_div2_high & ~slip_done_set;
 `else
 assign data_reg_in = {data_in, data_reg[97:32]};
 assign slip_done_set_nxt = slip & (sh_pointer[6:5] == 2'b01) & ~slip_done_set;
 `endif

 `ifdef XFIPCS_16G32GFC
 always @(*)
   begin
    if (reset_to_pma_rx_div2 || (data_valid_cnt==6'd32))
     data_valid_cnt_nxt = 6'd0;
    else if (data_valid)
     data_valid_cnt_nxt = data_valid_cnt + 1;
    else
     data_valid_cnt_nxt = 6'd0;
   end

 reg [129:0] data_reg_in_store;
 always @(posedge pma_rx_clk)
   begin
    data_reg_in_store <= data_reg_in;
   end

 always @(posedge pma_rx_clk_div2)
   begin
    if (~pma_rx_clk_div2_high)
     data_reg <= data_reg_in;
    else
     data_reg <= data_reg_in_store;
   end

 always @(posedge pma_rx_clk_div2)
   begin
    if (reset_to_pma_rx_div2) begin
     rx_data_66b <= 66'h0;
     data_valid  <= 1'b0;
    end else begin
     rx_data_66b <= rx_data_66b_in;
     data_valid <= data_valid_in;
    end

    ///data_reg <= data_reg_in;
    //data_valid <= data_valid_in;
    data_valid_cnt <= data_valid_cnt_nxt;
   end

 always @(posedge pma_rx_clk)
   begin
    if (reset_to_pma_rx) begin
     sh_pointer <= 7'h00;
     ignore_slip_count <= 3'h0;
    end else begin
     sh_pointer <= sh_pointer_in;
     ignore_slip_count <= ignore_slip_count_nxt;
    end

    H2O_XFIPCS_003_08 <= slip_done_set_nxt;
   end
 `else
 always @(posedge pma_rx_clk)
   begin
    if (reset_to_pma_rx) begin
     sh_pointer <= 7'h00;
     rx_data_66b <= 66'h0;
     ignore_slip_count <= 3'h0;
    end else begin
     sh_pointer <= sh_pointer_in;
     rx_data_66b <= rx_data_66b_in;
     ignore_slip_count <= ignore_slip_count_nxt;
    end

     data_reg <= data_reg_in;
     data_valid <= data_valid_in;
     H2O_XFIPCS_003_08 <= slip_done_set_nxt;
   end
 `endif

 assign slip_done_set = H2O_XFIPCS_003_08 ;

 `ifdef XFIPCS_16G32GFC
 assign rx_data_66b_in = (unscram_i_found)    ? data_reg[ 97: 32] :
                         (data_valid == 1'b0) ? rx_data_66b       :
                         (sh_offset == 6'h00) ? data_reg[ 65:  0] :
                         (sh_offset == 6'h01) ? data_reg[ 66:  1] :
                         (sh_offset == 6'h02) ? data_reg[ 67:  2] :
                         (sh_offset == 6'h03) ? data_reg[ 68:  3] :
                         (sh_offset == 6'h04) ? data_reg[ 69:  4] :
                         (sh_offset == 6'h05) ? data_reg[ 70:  5] :
                         (sh_offset == 6'h06) ? data_reg[ 71:  6] :
                         (sh_offset == 6'h07) ? data_reg[ 72:  7] :
                         (sh_offset == 6'h08) ? data_reg[ 73:  8] :
                         (sh_offset == 6'h09) ? data_reg[ 74:  9] :
                         (sh_offset == 6'h0a) ? data_reg[ 75: 10] :
                         (sh_offset == 6'h0b) ? data_reg[ 76: 11] :
                         (sh_offset == 6'h0c) ? data_reg[ 77: 12] :
                         (sh_offset == 6'h0d) ? data_reg[ 78: 13] :
                         (sh_offset == 6'h0e) ? data_reg[ 79: 14] :
                         (sh_offset == 6'h0f) ? data_reg[ 80: 15] :
                         (sh_offset == 6'h10) ? data_reg[ 81: 16] :
                         (sh_offset == 6'h11) ? data_reg[ 82: 17] :
                         (sh_offset == 6'h12) ? data_reg[ 83: 18] :
                         (sh_offset == 6'h13) ? data_reg[ 84: 19] :
                         (sh_offset == 6'h14) ? data_reg[ 85: 20] :
                         (sh_offset == 6'h15) ? data_reg[ 86: 21] :
                         (sh_offset == 6'h16) ? data_reg[ 87: 22] :
                         (sh_offset == 6'h17) ? data_reg[ 88: 23] :
                         (sh_offset == 6'h18) ? data_reg[ 89: 24] :
                         (sh_offset == 6'h19) ? data_reg[ 90: 25] :
                         (sh_offset == 6'h1a) ? data_reg[ 91: 26] :
                         (sh_offset == 6'h1b) ? data_reg[ 92: 27] :
                         (sh_offset == 6'h1c) ? data_reg[ 93: 28] :
                         (sh_offset == 6'h1d) ? data_reg[ 94: 29] :
                         (sh_offset == 6'h1e) ? data_reg[ 95: 30] :
                         (sh_offset == 6'h1f) ? data_reg[ 96: 31] :
                         (sh_offset == 6'h20) ? data_reg[ 97: 32] :
                         (sh_offset == 6'h21) ? data_reg[ 98: 33] :
                         (sh_offset == 6'h22) ? data_reg[ 99: 34] :
                         (sh_offset == 6'h23) ? data_reg[100: 35] :
                         (sh_offset == 6'h24) ? data_reg[101: 36] :
                         (sh_offset == 6'h25) ? data_reg[102: 37] :
                         (sh_offset == 6'h26) ? data_reg[103: 38] :
                         (sh_offset == 6'h27) ? data_reg[104: 39] :
                         (sh_offset == 6'h28) ? data_reg[105: 40] :
                         (sh_offset == 6'h29) ? data_reg[106: 41] :
                         (sh_offset == 6'h2a) ? data_reg[107: 42] :
                         (sh_offset == 6'h2b) ? data_reg[108: 43] :
                         (sh_offset == 6'h2c) ? data_reg[109: 44] :
                         (sh_offset == 6'h2d) ? data_reg[110: 45] :
                         (sh_offset == 6'h2e) ? data_reg[111: 46] :
                         (sh_offset == 6'h2f) ? data_reg[112: 47] :
                         (sh_offset == 6'h30) ? data_reg[113: 48] :
                         (sh_offset == 6'h31) ? data_reg[114: 49] :
                         (sh_offset == 6'h32) ? data_reg[115: 50] :
                         (sh_offset == 6'h33) ? data_reg[116: 51] :
                         (sh_offset == 6'h34) ? data_reg[117: 52] :
                         (sh_offset == 6'h35) ? data_reg[118: 53] :
                         (sh_offset == 6'h36) ? data_reg[119: 54] :
                         (sh_offset == 6'h37) ? data_reg[120: 55] :
                         (sh_offset == 6'h38) ? data_reg[121: 56] :
                         (sh_offset == 6'h39) ? data_reg[122: 57] :
                         (sh_offset == 6'h3a) ? data_reg[123: 58] :
                         (sh_offset == 6'h3b) ? data_reg[124: 59] :
                         (sh_offset == 6'h3c) ? data_reg[125: 60] :
                         (sh_offset == 6'h3d) ? data_reg[126: 61] :
                         (sh_offset == 6'h3e) ? data_reg[127: 62] :
                                                data_reg[128: 63] ;
 `else
 assign rx_data_66b_in = (unscram_i_found)    ? data_reg[ 65:  0] :
                         (data_valid == 1'b0) ? rx_data_66b       :
                         (sh_offset == 5'h00) ? data_reg[ 65:  0] :
                         (sh_offset == 5'h01) ? data_reg[ 66:  1] :
                         (sh_offset == 5'h02) ? data_reg[ 67:  2] :
                         (sh_offset == 5'h03) ? data_reg[ 68:  3] :
                         (sh_offset == 5'h04) ? data_reg[ 69:  4] :
                         (sh_offset == 5'h05) ? data_reg[ 70:  5] :
                         (sh_offset == 5'h06) ? data_reg[ 71:  6] :
                         (sh_offset == 5'h07) ? data_reg[ 72:  7] :
                         (sh_offset == 5'h08) ? data_reg[ 73:  8] :
                         (sh_offset == 5'h09) ? data_reg[ 74:  9] :
                         (sh_offset == 5'h0a) ? data_reg[ 75: 10] :
                         (sh_offset == 5'h0b) ? data_reg[ 76: 11] :
                         (sh_offset == 5'h0c) ? data_reg[ 77: 12] :
                         (sh_offset == 5'h0d) ? data_reg[ 78: 13] :
                         (sh_offset == 5'h0e) ? data_reg[ 79: 14] :
                         (sh_offset == 5'h0f) ? data_reg[ 80: 15] :
                         (sh_offset == 5'h10) ? data_reg[ 81: 16] :
                         (sh_offset == 5'h11) ? data_reg[ 82: 17] :
                         (sh_offset == 5'h12) ? data_reg[ 83: 18] :
                         (sh_offset == 5'h13) ? data_reg[ 84: 19] :
                         (sh_offset == 5'h14) ? data_reg[ 85: 20] :
                         (sh_offset == 5'h15) ? data_reg[ 86: 21] :
                         (sh_offset == 5'h16) ? data_reg[ 87: 22] :
                         (sh_offset == 5'h17) ? data_reg[ 88: 23] :
                         (sh_offset == 5'h18) ? data_reg[ 89: 24] :
                         (sh_offset == 5'h19) ? data_reg[ 90: 25] :
                         (sh_offset == 5'h1a) ? data_reg[ 91: 26] :
                         (sh_offset == 5'h1b) ? data_reg[ 92: 27] :
                         (sh_offset == 5'h1c) ? data_reg[ 93: 28] :
                         (sh_offset == 5'h1d) ? data_reg[ 94: 29] :
                         (sh_offset == 5'h1e) ? data_reg[ 95: 30] :
                                                data_reg[ 96: 31] ;
 `endif

 `ifdef XFIPCS_16G32GFC
 reg [65:0] fec_rx_data_66b_r1;

 always @(posedge pma_rx_clk_div2)
   if (reset_to_pma_rx_div2) begin
     fec_rx_data_66b_r1 <= 66'h0;
   end
   else begin
     fec_rx_data_66b_r1 <= fec_rx_data_66b;
   end

 wire [65:0] rx_data_66b_lockfsm;
 assign rx_data_66b_lockfsm = enable_rx_66b_in ? (fec_rx_data_66b_valid ? fec_rx_data_66b : fec_rx_data_66b_r1)
                                               : rx_data_66b;

 assign sh_valid = enable_rx_66b_in ? (fec_rx_data_66b_valid ? (rx_data_66b_lockfsm[0] ^ rx_data_66b_lockfsm[1]) : 1'b1)
                                    : (data_valid ? (rx_data_66b_lockfsm[0] ^ rx_data_66b_lockfsm[1]) : 1'b1);
 `else
 assign sh_valid = rx_data_66b[0] ^ rx_data_66b[1];
 `endif

 `XFIPCS_TOPLEVELNAME_LOCK_FSM lock_fsm (
                         .clk            (pma_rx_clk             ),
                         .reset          (reset_to_pma_rx        ),
                         .signal_ok      (signal_ok              ),
                         .sh_valid       (sh_valid               ),
                         .slip_done_set  (slip_done_set          ),
                         .test_sh_set    (test_sh_set            ),

                         .slip           (slip                   ),
                         .rx_block_lock  (rx_block_lock          )
                 );
endmodule
