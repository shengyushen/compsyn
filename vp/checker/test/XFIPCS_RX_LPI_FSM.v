//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:54 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_LPI_FSM.v endFileName  

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

//$Id:
//$Log:
//
//----------------------------------------------------------------------
// FILE NAME:
//   XFIPCS_RX_LPI_FSM.v
//
// DESCRIPTION:
//   LPI Receive FSM (Figure 49-17)
//
//----------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_RX_LPI_FSM
(
 clk,
 reset,
 enable_alternate_refresh,
 r_type_li,
 r_type_idle,
 rx_block_lock,
 energy_detect,
 scr_bypass_enable,
 rx_hss_t1_value,
 rx_hss_t3_value,
 rx_hss_t6_value,
 `ifdef XFIPCS_16G32GFC
 speed_sel,
 XGMIICLK_425M,
 lpi_fw,
 rx_tw_timer_value,
 `endif

 rx_mode,
 rx_lpi_active,
 block_lock,
 wake_error_counter_inc,
 RXxQUIET,
 RXxREFRESH
);

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input         clk;
input         reset;
input         enable_alternate_refresh;
input         r_type_li;
input         r_type_idle;
input         rx_block_lock;
input         energy_detect;
input         scr_bypass_enable;
`ifdef XFIPCS_16G32GFC
input  [17:0] rx_hss_t1_value;
input  [17:0] rx_hss_t6_value;
input         speed_sel;
input         XGMIICLK_425M;
input         lpi_fw;
input  [12:0] rx_tw_timer_value;
`else
input  [15:0] rx_hss_t1_value;
input  [15:0] rx_hss_t6_value;
`endif
input  [15:0] rx_hss_t3_value;

output        rx_mode;
output        rx_lpi_active;
output        block_lock;
output        wake_error_counter_inc;
output        RXxQUIET;
output        RXxREFRESH;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
reg  [3:0] rx_lpi_state;
reg  [3:0] rx_lpi_state_nxt;
reg        rx_mode;
reg        rx_mode_nxt;
reg        block_lock;
reg        block_lock_nxt;

reg        rx_lpi_active;
reg        rx_lpi_active_nxt;
reg        wake_error_counter_inc;
reg        wake_error_counter_inc_nxt;

reg         start_rx_tw_timer_nxt;
//reg         start_rx_tw_timer;
wire        rx_tw_timer_done;
`ifdef XFIPCS_16G32GFC
wire [12:0] rx_tw_timer_nxt;
reg  [12:0] rx_tw_timer;
`else
wire [11:0] rx_tw_timer_nxt;
reg  [11:0] rx_tw_timer;
`endif
reg         start_rx_tq_timer_nxt;
//reg         start_rx_tq_timer;
wire        rx_tq_timer_done;
`ifdef XFIPCS_16G32GFC
wire [20:0] rx_tq_timer_nxt;
reg  [20:0] rx_tq_timer;
`else
wire [18:0] rx_tq_timer_nxt;
reg  [18:0] rx_tq_timer;
`endif
reg         start_rx_wf_timer_nxt;
//reg         start_rx_wf_timer;
wire        rx_wf_timer_done;
`ifdef XFIPCS_16G32GFC
wire [22:0] rx_wf_timer_nxt;
reg  [22:0] rx_wf_timer;
`else
wire [20:0] rx_wf_timer_nxt;
reg  [20:0] rx_wf_timer;
`endif

`ifdef XFIPCS_16G32GFC
wire [17:0] rx_refresh_timer_nxt;
reg  [17:0] rx_refresh_timer;
`else
wire [15:0] rx_refresh_timer_nxt;
reg  [15:0] rx_refresh_timer;
`endif
reg         start_rx_refresh_timer_nxt;
reg         start_rx_refresh_timer;
wire        rx_refresh_timer_done;

reg         RXxREFRESH;
reg         RXxREFRESH_nxt;
reg         RXxQUIET;
reg         RXxQUIET_nxt;

wire [3:0]  energy_detect_count_nxt;
reg  [3:0]  energy_detect_count;

wire        rx_hss_t1_done;
wire        rx_hss_t3_done;
wire        rx_hss_t6_done;


// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TRUE  = 1'b1;
parameter FALSE = 1'b0;

parameter DATA  = 1'b0;
parameter QUIET = 1'b1;

parameter RX_ACTIVE     = 4'b0000;
parameter RX_SLEEP      = 4'b1001;
parameter RX_QUIET      = 4'b1010;
parameter RX_WAKE       = 4'b0011;
parameter RX_WTF        = 4'b1100;
parameter RX_LINK_FAIL  = 4'b0101;
parameter RX_PRE_QUIET  = 4'b0110;
parameter RX_POST_QUIET = 4'b1111;
`ifdef XFIPCS_16G32GFC
parameter RX_FAST_WAKE  = 4'b0111;
`endif

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign energy_detect_count_nxt = (energy_detect)                        ? 4'd0 :
                                  (energy_detect_count != 4'hF)          ? energy_detect_count + 4'd1 :
                                                                           energy_detect_count;

 // counter/timer logic
 `ifdef XFIPCS_16G32GFC
 assign rx_tw_timer_done  = (rx_tw_timer == 13'd0);
 assign rx_tq_timer_done  = (rx_tq_timer == 21'd0);
 assign rx_wf_timer_done  = (rx_wf_timer == 23'd0);
 assign rx_refresh_timer_done = (rx_refresh_timer == 18'h3FFFF);
 `else
 assign rx_tw_timer_done  = (rx_tw_timer == 12'd0);
 assign rx_tq_timer_done  = (rx_tq_timer == 19'd0);
 assign rx_wf_timer_done  = (rx_wf_timer == 21'd0);
 assign rx_refresh_timer_done = (rx_refresh_timer == 16'hFFFF);
 `endif

 // to aid in verif assertions
 assign rx_hss_t1_done = (rx_tq_timer      <= {3'b000, rx_hss_t1_value});
 `ifdef XFIPCS_16G32GFC
 assign rx_hss_t3_done = (rx_refresh_timer >= {2'b00, rx_hss_t3_value});
 `else
 assign rx_hss_t3_done = (rx_refresh_timer >= rx_hss_t3_value);
 `endif
 assign rx_hss_t6_done = (rx_refresh_timer >= rx_hss_t6_value);

 // Reset logic moved to flop instantiation
 `ifdef XFIPCS_16G32GFC
 assign rx_tw_timer_nxt  = (rx_tw_timer_done)  ? rx_tw_timer  : rx_tw_timer - 13'd1;
 assign rx_tq_timer_nxt  = (rx_tq_timer_done)  ? rx_tq_timer  : rx_tq_timer - 21'd1;
 assign rx_wf_timer_nxt  = (rx_wf_timer_done)  ? rx_wf_timer  : rx_wf_timer - 23'd1;
 assign rx_refresh_timer_nxt = (rx_refresh_timer_done) ? rx_refresh_timer : rx_refresh_timer + 18'd1;
 `else
 assign rx_tw_timer_nxt  = (rx_tw_timer_done)  ? rx_tw_timer  : rx_tw_timer - 12'd1;
 assign rx_tq_timer_nxt  = (rx_tq_timer_done)  ? rx_tq_timer  : rx_tq_timer - 19'd1;
 assign rx_wf_timer_nxt  = (rx_wf_timer_done)  ? rx_wf_timer  : rx_wf_timer - 21'd1;
 assign rx_refresh_timer_nxt = (rx_refresh_timer_done) ? rx_refresh_timer : rx_refresh_timer + 16'd1;
 `endif

 `ifdef XFIPCS_16G32GFC
 reg XGMIICLK_425M_r1;
 always @(posedge clk) begin
   XGMIICLK_425M_r1 <= XGMIICLK_425M;
 end

 wire [20:0] rx_tq_timer_max;
 assign rx_tq_timer_max = speed_sel ? `XFIPCS_RX_TQ_TIMER_MAX_32G : (XGMIICLK_425M_r1 ? `XFIPCS_RX_TQ_TIMER_MAX_16G_425M : `XFIPCS_RX_TQ_TIMER_MAX_16G_212M);
 wire [19:0] lp_tx_tql_min;
 assign lp_tx_tql_min = speed_sel ? `XFIPCS_LP_TX_TQL_MIN_32G : (XGMIICLK_425M_r1 ? `XFIPCS_LP_TX_TQL_MIN_16G_425M : `XFIPCS_LP_TX_TQL_MIN_16G_212M);
 `endif

 always @(posedge clk) begin : timers
  if (start_rx_tw_timer_nxt && scr_bypass_enable)
   `ifdef XFIPCS_16G32GFC
   //rx_tw_timer <= speed_sel ? `XFIPCS_RX_TW_TIMER_MIN_BYPASS_32G : (XGMIICLK_425M_r1 ? `XFIPCS_RX_TW_TIMER_MIN_BYPASS_16G_425M : `XFIPCS_RX_TW_TIMER_MIN_BYPASS_16G_212M);
   rx_tw_timer <= rx_tw_timer_value;
   `else
   rx_tw_timer <= `XFIPCS_RX_TW_TIMER_MAX_BYPASS;
   `endif
  else if (start_rx_tw_timer_nxt)
   `ifdef XFIPCS_16G32GFC
   //rx_tw_timer <= XGMIICLK_425M_r1 ? `XFIPCS_RX_TW_TIMER_MIN_16G_425M : `XFIPCS_RX_TW_TIMER_MIN_16G_212M;
   rx_tw_timer <= rx_tw_timer_value;
   `else
   rx_tw_timer <= `XFIPCS_RX_TW_TIMER_MAX;
   `endif
  else
   rx_tw_timer <= rx_tw_timer_nxt;

  if (start_rx_tq_timer_nxt)
   `ifdef XFIPCS_16G32GFC
   rx_tq_timer <= speed_sel ? `XFIPCS_RX_TQ_TIMER_MAX_32G : (XGMIICLK_425M_r1 ? `XFIPCS_RX_TQ_TIMER_MAX_16G_425M : `XFIPCS_RX_TQ_TIMER_MAX_16G_212M);
   `else
   rx_tq_timer <= `XFIPCS_RX_TQ_TIMER_MAX;
   `endif
  else
   rx_tq_timer <= rx_tq_timer_nxt;

  if (start_rx_wf_timer_nxt)
   `ifdef XFIPCS_16G32GFC
   rx_wf_timer <= speed_sel ? `XFIPCS_RX_WF_TIMER_MIN_32G : (XGMIICLK_425M_r1 ? `XFIPCS_RX_WF_TIMER_MIN_16G_425M : `XFIPCS_RX_WF_TIMER_MIN_16G_212M);
   `else
   rx_wf_timer <= `XFIPCS_RX_WF_TIMER_MAX;
   `endif
  else
   rx_wf_timer <= rx_wf_timer_nxt;

  if (start_rx_refresh_timer_nxt)
   `ifdef XFIPCS_16G32GFC
   rx_refresh_timer <= 18'h00000;
   `else
   rx_refresh_timer <= 16'h0000;
   `endif
  else
   rx_refresh_timer <= rx_refresh_timer_nxt;
 end


 // This is the Lock state machine of Fig 49-17 in IEEE 802.3ae C49
 always @(*) begin : fsm
  // default values
  rx_lpi_state_nxt           = rx_lpi_state;
  rx_mode_nxt                = rx_mode;
  rx_lpi_active_nxt          = rx_lpi_active;
  block_lock_nxt             = block_lock;
  start_rx_tq_timer_nxt      = 1'b0;
  start_rx_tw_timer_nxt      = 1'b0;
  start_rx_wf_timer_nxt      = 1'b0;
  start_rx_refresh_timer_nxt = 1'b0;
  wake_error_counter_inc_nxt = 1'b0;
  RXxQUIET_nxt               = RXxQUIET;
  RXxREFRESH_nxt             = RXxREFRESH;

  case (rx_lpi_state)
   RX_ACTIVE : begin
    `ifdef XFIPCS_16G32GFC
    if (!lpi_fw && rx_block_lock && block_lock && r_type_li) begin
    `else
    if (rx_block_lock && block_lock && r_type_li) begin
    `endif
     rx_lpi_state_nxt = RX_SLEEP;
     rx_lpi_active_nxt = TRUE;
     start_rx_tq_timer_nxt = 1'b1;
    `ifdef XFIPCS_16G32GFC
    end else if (lpi_fw && r_type_li) begin
     rx_lpi_state_nxt = RX_FAST_WAKE;
     rx_lpi_active_nxt = TRUE;
    `endif
    end else if (block_lock != rx_block_lock) begin
     rx_lpi_state_nxt = RX_ACTIVE;
     rx_lpi_active_nxt = FALSE;
     rx_mode_nxt = DATA;
     block_lock_nxt = rx_block_lock;

     `ifdef XFIPCS_16G32GFC
     if (rx_refresh_timer >= {2'b00, rx_hss_t3_value})
     `else
     if (rx_refresh_timer >= rx_hss_t3_value)
     `endif
      RXxREFRESH_nxt = 1'b0;
    end else begin
     // stay in RX_ACTIVE
     `ifdef XFIPCS_16G32GFC
     if (rx_refresh_timer >= {2'b00, rx_hss_t3_value})
     `else
     if (rx_refresh_timer >= rx_hss_t3_value)
     `endif
      RXxREFRESH_nxt = 1'b0;
    end
   end

   RX_SLEEP : begin
    if (rx_tq_timer_done) begin
     rx_lpi_state_nxt = RX_LINK_FAIL;
     block_lock_nxt = FALSE;
     RXxQUIET_nxt = 1'b0;
     start_rx_refresh_timer_nxt = 1'b1;
    end else if (!enable_alternate_refresh && !rx_block_lock) begin
     rx_lpi_state_nxt = RX_QUIET;
     rx_mode_nxt = QUIET;
    end else if (enable_alternate_refresh && !rx_block_lock && energy_detect_count[3]) begin
     rx_lpi_state_nxt = RX_PRE_QUIET;
     rx_mode_nxt = QUIET;
     RXxQUIET_nxt = 1'b1;
     start_rx_refresh_timer_nxt = 1'b1;
    end else if (rx_block_lock && !rx_tq_timer_done && r_type_li) begin
     rx_lpi_state_nxt = RX_SLEEP;
     rx_lpi_active_nxt = TRUE;
     start_rx_tq_timer_nxt = 1'b1;
    end else if (rx_block_lock && !rx_tq_timer_done && r_type_idle) begin
     rx_lpi_state_nxt = RX_ACTIVE;
     rx_lpi_active_nxt = FALSE;
     rx_mode_nxt = DATA;
     block_lock_nxt = rx_block_lock;

     `ifdef XFIPCS_16G32GFC
     if (rx_refresh_timer >= {2'b00, rx_hss_t3_value})
     `else
     if (rx_refresh_timer >= rx_hss_t3_value)
     `endif
      RXxREFRESH_nxt = 1'b0;
    end
   end

   RX_PRE_QUIET : begin
    `ifdef XFIPCS_16G32GFC
    if (!energy_detect && (rx_refresh_timer >= {2'b00, rx_hss_t3_value})) begin
    `else
    if (!energy_detect && (rx_refresh_timer >= rx_hss_t3_value)) begin
    `endif
     rx_lpi_state_nxt = RX_QUIET;
     RXxREFRESH_nxt = 1'b0;
    end else if (!RXxREFRESH && energy_detect) begin
     rx_lpi_state_nxt = RX_POST_QUIET;
     RXxREFRESH_nxt = 1'b1;
     start_rx_refresh_timer_nxt = 1'b1;
    end else if (RXxREFRESH && energy_detect && (rx_refresh_timer >= rx_hss_t6_value)) begin
     rx_lpi_state_nxt = RX_WAKE;
     rx_mode_nxt = DATA;
     RXxQUIET_nxt = 1'b0;
     start_rx_tw_timer_nxt = 1'b1;
     start_rx_refresh_timer_nxt = 1'b1;
    end
   end

   RX_QUIET : begin
    if (!enable_alternate_refresh && energy_detect) begin // normal refresh/wake
     rx_lpi_state_nxt = RX_WAKE;
     rx_mode_nxt = DATA;
     start_rx_tw_timer_nxt = 1'b1;
    end else if (!enable_alternate_refresh && rx_tq_timer_done) begin // normal tq timeout
     rx_lpi_state_nxt = RX_LINK_FAIL;
     block_lock_nxt = FALSE;
    end else if (enable_alternate_refresh &&
                 (energy_detect ||     // wake
                  rx_tq_timer_done ||  // quiet for too long
                  `ifdef XFIPCS_16G32GFC
                  (rx_tq_timer - (rx_tq_timer_max - {1'b0, lp_tx_tql_min}) - 21'd8 <= {3'h0,rx_hss_t1_value}))) begin // alternate refresh or wake; added 500ns skew here between TXxQUIET and energy_detect going low per the HSS databook, plus 8 cycles taken away by t5
                  `else
                  (rx_tq_timer - (`XFIPCS_RX_TQ_TIMER_MAX - `XFIPCS_LP_TX_TQL_MIN) - 19'd8 <= {3'h0,rx_hss_t1_value}))) begin // alternate refresh or wake; added 500ns skew here between TXxQUIET and energy_detect going low per the HSS databook, plus 8 cycles taken away by t5
                  `endif
     rx_lpi_state_nxt = RX_POST_QUIET;
     RXxREFRESH_nxt = 1'b1;
     start_rx_refresh_timer_nxt = 1'b1;
    end
   end

   RX_POST_QUIET : begin
    if (energy_detect && (rx_refresh_timer >= rx_hss_t6_value)) begin
     rx_lpi_state_nxt = RX_WAKE;
     rx_mode_nxt = DATA;
     RXxQUIET_nxt = 1'b0;
     start_rx_tw_timer_nxt = 1'b1;
     start_rx_refresh_timer_nxt = 1'b1;
    end else if (!energy_detect && rx_tq_timer_done && (rx_refresh_timer >= rx_hss_t6_value)) begin
     rx_lpi_state_nxt = RX_LINK_FAIL;
     block_lock_nxt = FALSE;
     RXxQUIET_nxt = 1'b0;
     start_rx_refresh_timer_nxt = 1'b1;
    end
   end

   RX_WAKE : begin
    if (rx_tw_timer_done) begin
     rx_lpi_state_nxt = RX_WTF;
     wake_error_counter_inc_nxt = 1'b1;
     start_rx_wf_timer_nxt = 1'b1;
    end else if (rx_block_lock && r_type_li) begin
     rx_lpi_state_nxt = RX_SLEEP;
     rx_lpi_active_nxt = TRUE;
     start_rx_tq_timer_nxt = 1'b1;
    end else if (rx_block_lock && r_type_idle) begin
     rx_lpi_state_nxt = RX_ACTIVE;
     rx_lpi_active_nxt = FALSE;
     rx_mode_nxt = DATA;
     block_lock_nxt = rx_block_lock;

     `ifdef XFIPCS_16G32GFC
     if (rx_refresh_timer >= {2'b00, rx_hss_t3_value})
     `else
     if (rx_refresh_timer >= rx_hss_t3_value)
     `endif
      RXxREFRESH_nxt = 1'b0;
    end
   end

   RX_WTF : begin
    if (rx_wf_timer_done) begin
     rx_lpi_state_nxt = RX_LINK_FAIL;
     block_lock_nxt = FALSE;
     RXxQUIET_nxt = 1'b0;
     start_rx_refresh_timer_nxt = 1'b1;
    end else if (rx_block_lock && r_type_li) begin
     rx_lpi_state_nxt = RX_SLEEP;
     rx_lpi_active_nxt = TRUE;
     start_rx_tq_timer_nxt = 1'b1;
    end else if (rx_block_lock && !r_type_li) begin
     rx_lpi_state_nxt = RX_ACTIVE;
     rx_lpi_active_nxt = FALSE;
     rx_mode_nxt = DATA;
     block_lock_nxt = rx_block_lock;

     `ifdef XFIPCS_16G32GFC
     if (rx_refresh_timer >= {2'b00, rx_hss_t3_value})
     `else
     if (rx_refresh_timer >= rx_hss_t3_value)
     `endif
      RXxREFRESH_nxt = 1'b0;
    end
   end

   RX_LINK_FAIL : begin
    rx_lpi_state_nxt = RX_ACTIVE;
     rx_lpi_active_nxt = FALSE;
     rx_mode_nxt = DATA;
     block_lock_nxt = rx_block_lock;

     `ifdef XFIPCS_16G32GFC
     if (rx_refresh_timer >= {2'b00, rx_hss_t3_value})
     `else
     if (rx_refresh_timer >= rx_hss_t3_value)
     `endif
      RXxREFRESH_nxt = 1'b0;
   end

   `ifdef XFIPCS_16G32GFC
   RX_FAST_WAKE : begin
    if (!r_type_li) begin
     rx_lpi_state_nxt = RX_ACTIVE;
     rx_lpi_active_nxt = FALSE;
     rx_mode_nxt = DATA;
     block_lock_nxt = rx_block_lock;
    end else begin
     rx_lpi_state_nxt = RX_FAST_WAKE;
     rx_lpi_active_nxt = TRUE;
    end
   end
   `endif

   default : begin
    rx_lpi_state_nxt = RX_ACTIVE;
    rx_lpi_active_nxt = FALSE;
    rx_mode_nxt = DATA;
    block_lock_nxt = rx_block_lock;
    RXxREFRESH_nxt = 1'b0;
    RXxQUIET_nxt = 1'b0;
   end
  endcase
 end

 // instantiate flops
 always @(posedge clk) begin : flops
  if (reset) begin
   rx_lpi_state  <= RX_ACTIVE;
   rx_mode       <= DATA;
   rx_lpi_active <= FALSE;
   block_lock    <= rx_block_lock;
   wake_error_counter_inc <= 1'b0;
   RXxQUIET      <= 1'b0;
   RXxREFRESH    <= 1'b0;
   energy_detect_count <= 4'd0;

  end else begin
   rx_lpi_state  <= rx_lpi_state_nxt;
   rx_mode       <= rx_mode_nxt;
   rx_lpi_active <= rx_lpi_active_nxt;
   block_lock    <= block_lock_nxt;
   wake_error_counter_inc <= wake_error_counter_inc_nxt;
   RXxQUIET      <= RXxQUIET_nxt;
   RXxREFRESH    <= RXxREFRESH_nxt;
   energy_detect_count <= energy_detect_count_nxt;
  end
 end
endmodule
