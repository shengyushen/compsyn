
`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_TX_FLOW (
                        pma_tx_clk,
                        reset_to_pma_tx,

                        enable_alternate_refresh,
                        ALTERNATE_ENCODE,
                        tx_fifo_pop,
                        txc_xfi,
                        txd_xfi,
                        scr_bypass_enable,

                        tx_fifo_pop_2,
                        encoder_data_in,
                        encoder_control_in,
                        tx_local_fault,
                        tx_mode,
                        scrambler_bypass,
                        t_type_li,
                        tx_active,
                        TXxQUIET,
                        TXxREFRESH
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input                   pma_tx_clk;
input                   reset_to_pma_tx;

input                   enable_alternate_refresh;
input                   ALTERNATE_ENCODE;
input                   tx_fifo_pop;
input   [7:0]           txc_xfi;
input   [63:0]          txd_xfi;
input                   scr_bypass_enable;

output  [7:0]           encoder_control_in;
output  [63:0]          encoder_data_in;
output                  tx_local_fault;
output                  tx_fifo_pop_2;
output  [1:0]           tx_mode;
output                  scrambler_bypass;
output                  t_type_li;
output                  tx_active;
output                  TXxQUIET;
output                  TXxREFRESH;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire                    tx_local_fault;
reg                     tx_fifo_pop_2;
wire    [3:0]           t_type;
reg     [3:0]           t_type_prev;
wire    [1:0]           tx_coded;

reg     [7:0]           cntl_xfi;
reg     [63:0]          data_xfi;
wire    [7:0]           byte0;
wire    [7:0]           byte1;
wire    [7:0]           byte2;
wire    [7:0]           byte3;
wire    [7:0]           byte4;
wire    [7:0]           byte5;
wire    [7:0]           byte6;
wire    [7:0]           byte7;
wire                    term0;
wire                    term1;
wire                    term2;
wire                    term3;
wire                    term4;
wire                    term5;
wire                    term6;
wire                    term7;
wire                    data0;
wire                    data1;
wire                    data2;
wire                    data3;
wire                    data4;
wire                    data5;
wire                    data6;
wire                    data7;
wire                    cntl0;
wire                    cntl1;
wire                    cntl2;
wire                    cntl3;
wire                    cntl4;
wire                    cntl5;
wire                    cntl6;
wire                    cntl7;
wire                    error0;
wire                    error1;
wire                    error2;
wire                    error3;
wire                    error4;
wire                    error5;
wire                    error6;
wire                    error7;
wire                    cntlorerr0;
wire                    cntlorerr1;
wire                    cntlorerr2;
wire                    cntlorerr3;
wire                    cntlorerr4;
wire                    cntlorerr5;
wire                    cntlorerr6;
wire                    cntlorerr7;
wire                    ord0;
wire                    ord4;
wire                    start0;
wire                    start4;
wire                    lpi0;
wire                    lpi1;
wire                    lpi2;
wire                    lpi3;
wire                    lpi4;
wire                    lpi5;
wire                    lpi6;
wire                    lpi7;

wire    [63:0]          txd_xfi_in;
wire    [7:0]           txc_xfi_in;

wire    [7:0]           lpi_7_0;
reg                     t_type_li;
wire                    t_type_li_nxt;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TX_INIT     = 4'b0000;
parameter TX_C        = 4'b1001;
parameter TX_S        = 4'b1010;
parameter TX_D        = 4'b0011;
parameter TX_T        = 4'b1100;
parameter TX_E        = 4'b0101;
parameter TX_N        = 4'b1111;
parameter TX_LI       = 4'b0110;
parameter LBLOCK_T    = 2'b01;
parameter ENCODE      = 2'b00;
parameter EBLOCK_T    = 2'b10;
parameter TERM        = 8'hfd;
parameter START       = 8'hfb;
parameter ORDER       = 8'h9c;
parameter ERROR       = 8'hfe;
parameter IDLE        = 8'h07;
parameter LPI         = 8'h06;
parameter FSIG        = 8'h5c;
parameter IDLE_R      = 8'h1c;
parameter CODE_3C     = 8'h3c;
parameter IDLE_A      = 8'h7c;
parameter IDLE_K      = 8'hbc;
parameter CODE_DC     = 8'hdc;
parameter CODE_F7     = 8'hf7;

parameter DATA  = 2'b00;
parameter QUIET = 2'b01;
parameter ALERT = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign t_type_li_nxt = (t_type == TX_LI);

 assign txd_xfi_in = reset_to_pma_tx ? 64'h0707070707070707 :
                     tx_fifo_pop ? txd_xfi : data_xfi ;
 assign txc_xfi_in = reset_to_pma_tx ? 8'hff :
                     tx_fifo_pop ? txc_xfi : cntl_xfi ;

 always @(posedge pma_tx_clk)
   begin
     if (reset_to_pma_tx) begin
      t_type_prev   <= TX_N;
     end else begin
      t_type_prev   <= t_type;
     end

     tx_fifo_pop_2 <= tx_fifo_pop;
     data_xfi      <= txd_xfi_in;
     cntl_xfi      <= txc_xfi_in;
     t_type_li     <= t_type_li_nxt;
   end

   assign byte0 =  txd_xfi_in[7 :0 ] ;
   assign byte1 =  txd_xfi_in[15:8 ] ;
   assign byte2 =  txd_xfi_in[23:16] ;
   assign byte3 =  txd_xfi_in[31:24] ;
   assign byte4 =  txd_xfi_in[39:32] ;
   assign byte5 =  txd_xfi_in[47:40] ;
   assign byte6 =  txd_xfi_in[55:48] ;
   assign byte7 =  txd_xfi_in[63:56] ;

   assign data0 = !txc_xfi_in[0] ;
   assign data1 = !txc_xfi_in[1] ;
   assign data2 = !txc_xfi_in[2] ;
   assign data3 = !txc_xfi_in[3] ;
   assign data4 = !txc_xfi_in[4] ;
   assign data5 = !txc_xfi_in[5] ;
   assign data6 = !txc_xfi_in[6] ;
   assign data7 = !txc_xfi_in[7] ;

   assign term0 = (txc_xfi_in[0] == 1'b1) & (byte0 == TERM);
   assign term1 = (txc_xfi_in[1] == 1'b1) & (byte1 == TERM);
   assign term2 = (txc_xfi_in[2] == 1'b1) & (byte2 == TERM);
   assign term3 = (txc_xfi_in[3] == 1'b1) & (byte3 == TERM);
   assign term4 = (txc_xfi_in[4] == 1'b1) & (byte4 == TERM);
   assign term5 = (txc_xfi_in[5] == 1'b1) & (byte5 == TERM);
   assign term6 = (txc_xfi_in[6] == 1'b1) & (byte6 == TERM);
   assign term7 = (txc_xfi_in[7] == 1'b1) & (byte7 == TERM);
   assign ord0  = (txc_xfi_in[3:0] == 4'h1) & ((byte0 == ORDER) | (byte0 == FSIG));
   assign ord4  = (txc_xfi_in[7:4] == 4'h1) & ((byte4 == ORDER) | (byte4 == FSIG));
   assign start0 = (txc_xfi_in == 8'h01) & (byte0 == START);
   assign start4 = (txc_xfi_in[7:4] == 4'h1) & (byte4 == START);
   assign error0 = (txc_xfi_in[0] == 1'b1) & (byte0 == ERROR);
   assign error1 = (txc_xfi_in[1] == 1'b1) & (byte1 == ERROR);
   assign error2 = (txc_xfi_in[2] == 1'b1) & (byte2 == ERROR);
   assign error3 = (txc_xfi_in[3] == 1'b1) & (byte3 == ERROR);
   assign error4 = (txc_xfi_in[4] == 1'b1) & (byte4 == ERROR);
   assign error5 = (txc_xfi_in[5] == 1'b1) & (byte5 == ERROR);
   assign error6 = (txc_xfi_in[6] == 1'b1) & (byte6 == ERROR);
   assign error7 = (txc_xfi_in[7] == 1'b1) & (byte7 == ERROR);

   assign lpi0 = (txc_xfi_in[0] == 1'b1) & (byte0 == LPI);
   assign lpi1 = (txc_xfi_in[1] == 1'b1) & (byte1 == LPI);
   assign lpi2 = (txc_xfi_in[2] == 1'b1) & (byte2 == LPI);
   assign lpi3 = (txc_xfi_in[3] == 1'b1) & (byte3 == LPI);
   assign lpi4 = (txc_xfi_in[4] == 1'b1) & (byte4 == LPI);
   assign lpi5 = (txc_xfi_in[5] == 1'b1) & (byte5 == LPI);
   assign lpi6 = (txc_xfi_in[6] == 1'b1) & (byte6 == LPI);
   assign lpi7 = (txc_xfi_in[7] == 1'b1) & (byte7 == LPI);

   assign lpi_7_0 = {lpi7,lpi6,lpi5,lpi4,lpi3,lpi2,lpi1,lpi0};

   assign cntl0 = txc_xfi_in[0] == 1'b1 &
                  ( byte0 == IDLE    | byte0 == IDLE_A  |
                    byte0 == IDLE_R  | byte0 == IDLE_K  |
                    byte0 == CODE_3C | byte0 == CODE_DC |
                    byte0 == CODE_F7 | byte0 == LPI);
   assign cntl1 = txc_xfi_in[1] == 1'b1 &
                  ( byte1 == IDLE    | byte1 == IDLE_A  |
                    byte1 == IDLE_R  | byte1 == IDLE_K  |
                    byte1 == CODE_3C | byte1 == CODE_DC |
                    byte1 == CODE_F7 | byte1 == LPI);
   assign cntl2 = txc_xfi_in[2] == 1'b1 &
                  ( byte2 == IDLE    | byte2 == IDLE_A  |
                    byte2 == IDLE_R  | byte2 == IDLE_K  |
                    byte2 == CODE_3C | byte2 == CODE_DC |
                    byte2 == CODE_F7 | byte2 == LPI);
   assign cntl3 = txc_xfi_in[3] == 1'b1 &
                  ( byte3 == IDLE    | byte3 == IDLE_A  |
                    byte3 == IDLE_R  | byte3 == IDLE_K  |
                    byte3 == CODE_3C | byte3 == CODE_DC |
                    byte3 == CODE_F7 | byte3 == LPI);
   assign cntl4 = txc_xfi_in[4] == 1'b1 &
                  ( byte4 == IDLE    | byte4 == IDLE_A  |
                    byte4 == IDLE_R  | byte4 == IDLE_K  |
                    byte4 == CODE_3C | byte4 == CODE_DC |
                    byte4 == CODE_F7 | byte4 == LPI);
   assign cntl5 = txc_xfi_in[5] == 1'b1 &
                  ( byte5 == IDLE    | byte5 == IDLE_A  |
                    byte5 == IDLE_R  | byte5 == IDLE_K  |
                    byte5 == CODE_3C | byte5 == CODE_DC |
                    byte5 == CODE_F7 | byte5 == LPI);
   assign cntl6 = txc_xfi_in[6] == 1'b1 &
                  ( byte6 == IDLE    | byte6 == IDLE_A  |
                    byte6 == IDLE_R  | byte6 == IDLE_K  |
                    byte6 == CODE_3C | byte6 == CODE_DC |
                    byte6 == CODE_F7 | byte6 == LPI);
   assign cntl7 = txc_xfi_in[7] == 1'b1 &
                  ( byte7 == IDLE    | byte7 == IDLE_A  |
                    byte7 == IDLE_R  | byte7 == IDLE_K  |
                    byte7 == CODE_3C | byte7 == CODE_DC |
                    byte7 == CODE_F7 | byte7 == LPI);


   assign cntlorerr0 = cntl0 | error0;
   assign cntlorerr1 = cntl1 | error1;
   assign cntlorerr2 = cntl2 | error2;
   assign cntlorerr3 = cntl3 | error3;
   assign cntlorerr4 = cntl4 | error4;
   assign cntlorerr5 = cntl5 | error5;
   assign cntlorerr6 = cntl6 | error6;
   assign cntlorerr7 = cntl7 | error7;

 assign t_type = (!tx_fifo_pop && (t_type_prev == TX_LI))               ? TX_LI :
                 tx_fifo_pop == 1'b0                                    ? TX_N :
                 (cntl0 && cntl1 && cntl2 && cntl3 &&
                  cntl4 && cntl5 && cntl6 && cntl7 &&
                  ((lpi_7_0 == 8'h00) || (lpi_7_0 == 8'hF0) || (lpi_7_0 == 8'h0F))) ||
                  (ord0 && cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7) ||
                  (ord4 && cntlorerr0 && cntlorerr1 && cntlorerr2 && cntlorerr3) ||
                 (ord0 && ord4)                                         ? TX_C :
                 (lpi0 && lpi1 && lpi2 && lpi3 &&
                  lpi4 && lpi5 && lpi6 && lpi7)                         ? TX_LI :
                 start0 ||
                 (start4 && (ord0 ||
                  (cntlorerr0 && cntlorerr1 && cntlorerr2 && cntlorerr3))) ? TX_S :
                 (term0      && cntlorerr1 && cntlorerr2 && cntlorerr3 &&
                  cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && term1      && cntlorerr2 && cntlorerr3 &&
                  cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && term2      && cntlorerr3 &&
                  cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && data2      && term3      &&
   cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7 && ~ALTERNATE_ENCODE) ||
                 (data0      && data1      && data2      && term3      &&
   ord4 && data5 && data6 && data7 && ALTERNATE_ENCODE) ||
                 (data0      && data1      && data2      && data3      &&
                  term4      && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && data2      && data3      &&
                  data4      && term5      && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && data2      && data3      &&
                  data4      && data5      && term6      && cntlorerr7)   ||
                 (data0      && data1      && data2      && data3      &&
                  data4      && data5      && data6      && term7)      ? TX_T :
                 (data0      && data1      && data2      && data3      &&
                  data4      && data5      && data6      && data7)      ? TX_D :
                                                                          TX_E ;

 `XFIPCS_TOPLEVELNAME_TX_FSM tx_fsm
 (
  .clk      (pma_tx_clk     ),
  .reset    (reset_to_pma_tx),

  .t_type   (t_type         ),

  .tx_coded (tx_coded       )
 );

 `XFIPCS_TOPLEVELNAME_TX_LPI_FSM tx_lpi_fsm
 (
  .clk                     (pma_tx_clk             ),
  .reset                   (reset_to_pma_tx        ),
  .enable_alternate_refresh (enable_alternate_refresh),
  .t_type_li               (t_type_li_nxt          ),
  .scr_bypass_enable       (scr_bypass_enable      ),

  .tx_mode                 (tx_mode                ),
  .scrambler_bypass        (scrambler_bypass       ),
  .tx_active               (tx_active              ),
  .TXxQUIET                (TXxQUIET               ),
  .TXxREFRESH              (TXxREFRESH             )
 );

 assign encoder_data_in = (tx_coded == LBLOCK_T)        ? 64'h0100009c0100009c :
                          (tx_coded == EBLOCK_T)        ? 64'hfefefefefefefefe :
                          (tx_mode == QUIET)            ? 64'h0606060606060606 :
                                                                      data_xfi ;

 assign encoder_control_in = (tx_coded == LBLOCK_T)                    ? 8'h11 :
                             (tx_coded == EBLOCK_T)                    ? 8'hff :
                             (tx_mode == QUIET)                        ? 8'hff :
                                                                      cntl_xfi ;

 assign tx_local_fault = (tx_coded == LBLOCK_T) ? 1'b1 : 1'b0 ;

endmodule
