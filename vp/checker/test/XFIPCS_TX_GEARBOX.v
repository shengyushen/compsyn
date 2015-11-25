//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:15 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_GEARBOX.v endFileName  

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

//$Id: XFIPCS_TX_GEARBOX.v,v 1.8 2014/02/21 07:12:01 huqian Exp $
//$Log: XFIPCS_TX_GEARBOX.v,v $
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.5  2013/12/12 03:29:21  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.4  2013/09/17 06:05:53  huqian
//Initial 32G Fibre Channel
//
//Revision 1.3  2011/01/25 21:22:21  adamc
//Reset updates for TX
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

module `XFIPCS_TOPLEVELNAME_TX_GEARBOX (
                        pma_tx_clk,
                        reset_to_pma_tx,

                        tx_fifo_pop,
                        tx_data_66b,

                        tx_data_out
                );

input                   pma_tx_clk;
input                   reset_to_pma_tx;

input                   tx_fifo_pop;
input   [65:0]          tx_data_66b;

`ifdef XFIPCS_16G32GFC
output  [63:0]          tx_data_out;
reg     [63:0]          tx_data_out;
reg     [63:0]          tx_data_out_nxt;
 
reg     [129:0]         data_reg;
wire    [129:0]         data_reg_in;
`else
output  [31:0]          tx_data_out;
reg     [31:0]          tx_data_out;
reg     [31:0]          tx_data_out_nxt;

reg     [97:0]          data_reg;
wire    [97:0]          data_reg_in;
wire    [5:0]           output_pointer_in;
`endif
wire    [5:0]           output_pointer_nxt;
reg     [5:0]           output_pointer;

`ifdef XFIPCS_16G32GFC
reg reset_to_pma_tx_r1;

always @(posedge pma_tx_clk)
  begin
   if (reset_to_pma_tx) begin
    data_reg       <= 130'h300ff00ff00ff00ff00ff00ff00ff00ff;
    output_pointer <= 6'h00;
    tx_data_out    <= 64'h00ff00ff00ff00ff;
   end else begin
    data_reg       <= data_reg_in;
    output_pointer <= output_pointer_nxt;
    tx_data_out    <= tx_data_out_nxt;
   end
   reset_to_pma_tx_r1 <= reset_to_pma_tx;
  end
 
assign data_reg_in = tx_fifo_pop  ? {tx_data_66b, data_reg[129:66]} : data_reg;
assign output_pointer_nxt = reset_to_pma_tx_r1 ? 6'h10 : (output_pointer==6'h0 ? 6'h20 : output_pointer - 1);
 
always @(output_pointer or data_reg or reset_to_pma_tx) begin
  casex ({reset_to_pma_tx, output_pointer})
    7'b1xxxxxx :  tx_data_out_nxt = 64'h00ff00ff ;
    7'h00 :  tx_data_out_nxt = data_reg[ 63: 0];
    7'h01 :  tx_data_out_nxt = data_reg[ 65: 2];
    7'h02 :  tx_data_out_nxt = data_reg[ 67: 4];
    7'h03 :  tx_data_out_nxt = data_reg[ 69: 6];
    7'h04 :  tx_data_out_nxt = data_reg[ 71: 8];
    7'h05 :  tx_data_out_nxt = data_reg[ 73:10];
    7'h06 :  tx_data_out_nxt = data_reg[ 75:12];
    7'h07 :  tx_data_out_nxt = data_reg[ 77:14];
    7'h08 :  tx_data_out_nxt = data_reg[ 79:16];
    7'h09 :  tx_data_out_nxt = data_reg[ 81:18];
    7'h0a :  tx_data_out_nxt = data_reg[ 83:20];
    7'h0b :  tx_data_out_nxt = data_reg[ 85:22];
    7'h0c :  tx_data_out_nxt = data_reg[ 87:24];
    7'h0d :  tx_data_out_nxt = data_reg[ 89:26];
    7'h0e :  tx_data_out_nxt = data_reg[ 91:28];
    7'h0f :  tx_data_out_nxt = data_reg[ 93:30];
    7'h10 :  tx_data_out_nxt = data_reg[ 95:32];
    7'h11 :  tx_data_out_nxt = data_reg[ 97:34];
    7'h12 :  tx_data_out_nxt = data_reg[ 99:36];
    7'h13 :  tx_data_out_nxt = data_reg[101:38];
    7'h14 :  tx_data_out_nxt = data_reg[103:40];
    7'h15 :  tx_data_out_nxt = data_reg[105:42];
    7'h16 :  tx_data_out_nxt = data_reg[107:44];
    7'h17 :  tx_data_out_nxt = data_reg[109:46];
    7'h18 :  tx_data_out_nxt = data_reg[111:48];
    7'h19 :  tx_data_out_nxt = data_reg[113:50];
    7'h1a :  tx_data_out_nxt = data_reg[115:52];
    7'h1b :  tx_data_out_nxt = data_reg[117:54];
    7'h1c :  tx_data_out_nxt = data_reg[119:56];
    7'h1d :  tx_data_out_nxt = data_reg[121:58];
    7'h1e :  tx_data_out_nxt = data_reg[123:60];
    7'h1f :  tx_data_out_nxt = data_reg[125:62];
    default: tx_data_out_nxt = data_reg[127:64]; // output_pointer == 6'h20
  endcase
end
`else
always @(posedge pma_tx_clk)
  begin
   if (reset_to_pma_tx) begin
    data_reg       <= 98'h300ff00ff00ff00ff00ff00ff;
    output_pointer <= 6'h00;
    tx_data_out    <= 32'h00ff00ff;
   end else begin
    data_reg       <= data_reg_in;
    output_pointer <= output_pointer_nxt;
    tx_data_out    <= tx_data_out_nxt;
   end

  end

assign data_reg_in = tx_fifo_pop  ? {tx_data_66b, data_reg[97:66]} : data_reg;
assign output_pointer_in = tx_fifo_pop || output_pointer > 16
                                  ? output_pointer - 17 : output_pointer + 16 ;
assign output_pointer_nxt = output_pointer_in > 32 ? 6'h00 : output_pointer_in ;

always @(output_pointer or data_reg or reset_to_pma_tx) begin
  casex ({reset_to_pma_tx, output_pointer})
    7'b1xxxxxx :  tx_data_out_nxt = 32'h00ff00ff ;
    7'h00 :  tx_data_out_nxt = data_reg[31: 0];
    7'h01 :  tx_data_out_nxt = data_reg[33: 2];
    7'h02 :  tx_data_out_nxt = data_reg[35: 4];
    7'h03 :  tx_data_out_nxt = data_reg[37: 6];
    7'h04 :  tx_data_out_nxt = data_reg[39: 8];
    7'h05 :  tx_data_out_nxt = data_reg[41:10];
    7'h06 :  tx_data_out_nxt = data_reg[43:12];
    7'h07 :  tx_data_out_nxt = data_reg[45:14];
    7'h08 :  tx_data_out_nxt = data_reg[47:16];
    7'h09 :  tx_data_out_nxt = data_reg[49:18];
    7'h0a :  tx_data_out_nxt = data_reg[51:20];
    7'h0b :  tx_data_out_nxt = data_reg[53:22];
    7'h0c :  tx_data_out_nxt = data_reg[55:24];
    7'h0d :  tx_data_out_nxt = data_reg[57:26];
    7'h0e :  tx_data_out_nxt = data_reg[59:28];
    7'h0f :  tx_data_out_nxt = data_reg[61:30];
    7'h10 :  tx_data_out_nxt = data_reg[63:32];
    7'h11 :  tx_data_out_nxt = data_reg[65:34];
    7'h12 :  tx_data_out_nxt = data_reg[67:36];
    7'h13 :  tx_data_out_nxt = data_reg[69:38];
    7'h14 :  tx_data_out_nxt = data_reg[71:40];
    7'h15 :  tx_data_out_nxt = data_reg[73:42];
    7'h16 :  tx_data_out_nxt = data_reg[75:44];
    7'h17 :  tx_data_out_nxt = data_reg[77:46];
    7'h18 :  tx_data_out_nxt = data_reg[79:48];
    7'h19 :  tx_data_out_nxt = data_reg[81:50];
    7'h1a :  tx_data_out_nxt = data_reg[83:52];
    7'h1b :  tx_data_out_nxt = data_reg[85:54];
    7'h1c :  tx_data_out_nxt = data_reg[87:56];
    7'h1d :  tx_data_out_nxt = data_reg[89:58];
    7'h1e :  tx_data_out_nxt = data_reg[91:60];
    7'h1f :  tx_data_out_nxt = data_reg[93:62];
    default: tx_data_out_nxt = data_reg[95:64]; // output_pointer == 6'h20
  endcase
end
`endif

endmodule
