
`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_TX_LPI_FSM
(
 clk,
 reset,
 enable_alternate_refresh,
 t_type_li,
 scr_bypass_enable,
 tx_hss_t1_value,
 tx_hss_t2_value,
 tx_hss_t3_value,

 tx_mode,
 scrambler_bypass,
 tx_active,
 TXxQUIET,
 TXxREFRESH
);

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input         clk;
input         reset;
input         t_type_li;
input         enable_alternate_refresh;
input         scr_bypass_enable;
input  [10:0] tx_hss_t1_value;
input  [15:0] tx_hss_t2_value;
input  [15:0] tx_hss_t3_value;

output [1:0]  tx_mode;
output        scrambler_bypass;
output        tx_active;
output        TXxQUIET;
output        TXxREFRESH;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
reg  [3:0] tx_lpi_state;
reg  [3:0] tx_lpi_state_nxt;
reg  [1:0] tx_mode;
reg  [1:0] tx_mode_nxt;
reg        scrambler_bypass;
reg        scrambler_bypass_nxt;

reg         start_tx_ts_timer_nxt;
//reg         start_tx_ts_timer;
wire        tx_ts_timer_done;
wire [10:0] tx_ts_timer_nxt;
reg  [10:0] tx_ts_timer;
reg         start_tx_tq_timer_nxt;
//reg         start_tx_tq_timer;
wire        tx_tq_timer_done;
wire [19:0] tx_tq_timer_nxt;
reg  [19:0] tx_tq_timer;
reg         start_tx_tw_timer_nxt;
//reg         start_tx_tw_timer;
wire        tx_tw_timer_done;
wire [11:0] tx_tw_timer_nxt;
reg  [11:0] tx_tw_timer;

reg         start_one_us_timer_nxt;
//reg         start_one_us_timer;
reg  [8:0]  one_us_timer;
wire [8:0]  one_us_timer_nxt;
wire        one_us_timer_done;

reg         tx_active_nxt;
reg         tx_active;

reg         TXxREFRESH_nxt;
reg         TXxREFRESH;
reg         TXxQUIET_nxt;
reg         TXxQUIET;

reg  [15:0] tx_refresh_timer;
wire [15:0] tx_refresh_timer_nxt;
reg         start_tx_refresh_timer_nxt;
wire        tx_refresh_timer_done;

wire        tx_hss_t1_done;
wire        tx_hss_t2_done;
wire        tx_hss_t3_done;
// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TRUE  = 1'b1;
parameter FALSE = 1'b0;

parameter TX_ACTIVE     = 4'b0000;
parameter TX_SLEEP      = 4'b1001;
parameter TX_QUIET      = 4'b1010;
parameter TX_ALERT      = 4'b0011;
parameter TX_WAKE       = 4'b1100;
parameter TX_SCR_BYPASS = 4'b0101;
parameter TX_PRE_QUIET  = 4'b0110;
parameter TX_POST_QUIET = 4'b1111;

parameter DATA  = 2'b00;
parameter QUIET = 2'b01;
parameter ALERT = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------

 // counter/timer logic
 assign tx_ts_timer_done  = (tx_ts_timer == 11'd0);
 assign tx_tq_timer_done  = (tx_tq_timer == 20'd0);
 assign tx_tw_timer_done  = (tx_tw_timer == 12'd0);
 assign one_us_timer_done = (one_us_timer == 9'd0);
 assign tx_refresh_timer_done = (tx_refresh_timer == 16'hFFFF);

 // to aid in verif assertions
 assign tx_hss_t1_done = (tx_ts_timer      >= tx_hss_t1_value);
 assign tx_hss_t2_done = (tx_refresh_timer >= tx_hss_t2_value);
 assign tx_hss_t3_done = (tx_refresh_timer >= tx_hss_t3_value);

 // Reset logic moved to flop instantiation
 assign tx_ts_timer_nxt  = (tx_ts_timer_done)  ? tx_ts_timer  : tx_ts_timer - 11'd1;
 assign tx_tq_timer_nxt  = (tx_tq_timer_done)  ? tx_tq_timer  : tx_tq_timer - 20'd1;
 assign tx_tw_timer_nxt  = (tx_tw_timer_done)  ? tx_tw_timer  : tx_tw_timer - 12'd1;
 assign one_us_timer_nxt = (one_us_timer_done) ? one_us_timer : one_us_timer - 9'd1;
 assign tx_refresh_timer_nxt = (tx_refresh_timer_done) ? tx_refresh_timer : tx_refresh_timer + 16'd1;

 always @(posedge clk) begin : timers
  if (start_tx_ts_timer_nxt)
   tx_ts_timer <= `XFIPCS_TX_TS_TIMER_MAX;
  else
   tx_ts_timer <= tx_ts_timer_nxt;

  if (start_tx_tq_timer_nxt)
   tx_tq_timer <= `XFIPCS_TX_TQ_TIMER_MAX;
  else
   tx_tq_timer <= tx_tq_timer_nxt;

  if (start_tx_tw_timer_nxt)
   tx_tw_timer <= `XFIPCS_TX_TW_TIMER_MAX;
  else
   tx_tw_timer <= tx_tw_timer_nxt;

  if (start_one_us_timer_nxt)
   one_us_timer <= `XFIPCS_ONE_US_TIMER_MAX;
  else
   one_us_timer <= one_us_timer_nxt;

  if (start_tx_refresh_timer_nxt)
   tx_refresh_timer <= 16'd0;
  else
   tx_refresh_timer <= tx_refresh_timer_nxt;
 end

 // This is the Lock state machine of Fig 49-14 in IEEE 802.3ae C49
 always @(*) begin : fsm
  // default values
  tx_lpi_state_nxt       = tx_lpi_state;
  tx_mode_nxt            = tx_mode;
  scrambler_bypass_nxt   = scrambler_bypass;
  start_tx_ts_timer_nxt  = 1'b0;
  start_tx_tq_timer_nxt  = 1'b0;
  start_tx_tw_timer_nxt  = 1'b0;
  start_one_us_timer_nxt = 1'b0;
  start_tx_refresh_timer_nxt = 1'b0;
  tx_active_nxt          = 1'b0;
  TXxQUIET_nxt           = TXxQUIET;
  TXxREFRESH_nxt         = TXxREFRESH;

  case (tx_lpi_state)
   TX_ACTIVE : begin
    if (t_type_li) begin
     tx_lpi_state_nxt = TX_SLEEP;
     start_tx_ts_timer_nxt = 1'b1;
     scrambler_bypass_nxt = FALSE;
    end else begin
     tx_lpi_state_nxt = TX_ACTIVE;
     tx_mode_nxt = DATA;
     scrambler_bypass_nxt = FALSE;
     tx_active_nxt        = 1'b1;
     TXxREFRESH_nxt = 1'b0;
    end
   end

   TX_SLEEP : begin
    if (!enable_alternate_refresh && t_type_li && tx_ts_timer_done) begin
     tx_lpi_state_nxt = TX_QUIET;
     start_tx_tq_timer_nxt = 1'b1;
     tx_mode_nxt = QUIET;
    end else if (enable_alternate_refresh &&
                 t_type_li && (tx_ts_timer == tx_hss_t1_value)) begin
     tx_lpi_state_nxt = TX_PRE_QUIET;
     TXxREFRESH_nxt = 1'b1;
    end else if (!t_type_li) begin
     tx_lpi_state_nxt = TX_ACTIVE;
     tx_mode_nxt = DATA;
     scrambler_bypass_nxt = FALSE;
     tx_active_nxt        = 1'b1;
     TXxREFRESH_nxt = 1'b0;
    end
   end

   TX_PRE_QUIET: begin
    if (!t_type_li) begin
     tx_lpi_state_nxt = TX_ACTIVE;
     tx_mode_nxt = DATA;
     scrambler_bypass_nxt = FALSE;
     tx_active_nxt = 1'b1;
     TXxREFRESH_nxt = 1'b0;
    end else if (t_type_li && tx_ts_timer_done) begin
     tx_lpi_state_nxt = TX_QUIET;
     start_tx_tq_timer_nxt = 1'b1;
     tx_mode_nxt = QUIET;
     TXxQUIET_nxt = 1'b1;
     start_tx_refresh_timer_nxt = 1'b1;
    end
   end

   TX_QUIET : begin
    if (!enable_alternate_refresh && (tx_tq_timer_done || !t_type_li)) begin
     tx_lpi_state_nxt = TX_ALERT;
     tx_mode_nxt = ALERT;
     start_one_us_timer_nxt = 1'b1;
    end else if (enable_alternate_refresh &&
                 (tx_refresh_timer == tx_hss_t2_value)) begin
     tx_lpi_state_nxt = TX_POST_QUIET;
     TXxREFRESH_nxt = 1'b0;
     start_tx_refresh_timer_nxt = 1'b1;
    end
   end

   TX_POST_QUIET : begin
    if ((tx_tq_timer_done || !t_type_li) &&
        (tx_refresh_timer >=  tx_hss_t3_value)) begin
     tx_lpi_state_nxt = TX_ALERT;
     tx_mode_nxt = ALERT;
     start_one_us_timer_nxt = 1'b1;
     TXxQUIET_nxt = 1'b0;
    end
   end

   TX_ALERT : begin
    if (one_us_timer_done) begin
     tx_lpi_state_nxt = TX_WAKE;
     tx_mode_nxt = DATA;
     start_tx_tw_timer_nxt = 1'b1;
    end
   end

   TX_WAKE : begin
    if (t_type_li && tx_tw_timer_done && !scr_bypass_enable) begin
     tx_lpi_state_nxt = TX_SLEEP;
     start_tx_ts_timer_nxt = 1'b1;
     scrambler_bypass_nxt = FALSE;
    end else if (tx_tw_timer_done && scr_bypass_enable) begin
     tx_lpi_state_nxt = TX_SCR_BYPASS;
     scrambler_bypass_nxt = TRUE;
     start_one_us_timer_nxt = 1'b1;
    end else if (!t_type_li && tx_tw_timer_done && !scr_bypass_enable) begin
     tx_lpi_state_nxt = TX_ACTIVE;
     tx_mode_nxt = DATA;
     scrambler_bypass_nxt = FALSE;
     tx_active_nxt        = 1'b1;
     TXxREFRESH_nxt = 1'b0;
    end
   end

   TX_SCR_BYPASS : begin
    if (t_type_li && one_us_timer_done) begin
     tx_lpi_state_nxt = TX_SLEEP;
     start_tx_ts_timer_nxt = 1'b1;
     scrambler_bypass_nxt = FALSE;
    end else if (!t_type_li && one_us_timer_done) begin
     tx_lpi_state_nxt = TX_ACTIVE;
     tx_mode_nxt = DATA;
     scrambler_bypass_nxt = FALSE;
     tx_active_nxt        = 1'b1;
    end
   end

   default : begin
    tx_lpi_state_nxt = TX_ACTIVE;
    tx_mode_nxt = DATA;
    scrambler_bypass_nxt = FALSE;
    tx_active_nxt        = 1'b1;

   end
  endcase
 end

 // instantiate flops
 always @(posedge clk) begin : flops
  if (reset) begin
   tx_lpi_state     <= TX_ACTIVE;
   tx_mode          <= DATA;
   scrambler_bypass <= FALSE;
   TXxREFRESH       <= 1'b0;
   TXxQUIET         <= 1'b0;
   tx_active        <= 1'b1;
  end else begin
   tx_lpi_state     <= tx_lpi_state_nxt;
   tx_mode          <= tx_mode_nxt;
   scrambler_bypass <= scrambler_bypass_nxt;
   TXxREFRESH       <= TXxREFRESH_nxt;
   TXxQUIET         <= TXxQUIET_nxt;
   tx_active        <= tx_active_nxt;
  end

//  reset_pending <= reset_pending_nxt;
 end

endmodule
