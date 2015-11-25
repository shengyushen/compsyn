//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:17 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_64B66B_DEC.v endFileName  

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

//$Id: XFIPCS_64B66B_DEC.v,v 1.8 2014/02/21 07:11:59 huqian Exp $
//$Log: XFIPCS_64B66B_DEC.v,v $
//Revision 1.8  2014/02/21 07:11:59  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.8  2014/02/11 06:50:50  huqian
//Six T blocks are treated as error(invalid) blocks for 16G32G FC
//
//Revision 1.7  2014/02/10 09:04:50  huqian
//reserved0/reserved1/reserved2/reserved3/reserved4/reserved5 are treated as error(invalid) codes for 16G32G FC
//
//Revision 1.6  2011/01/21 21:27:45  adamc
//Some reset cleanup especially for RX
//
//Revision 1.5  2011/01/12 20:35:53  adamc
//removed scrambler disable
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

module `XFIPCS_TOPLEVELNAME_64B66B_DEC (
                      CLK,
                      RESET,
                      ALTERNATE_ENCODE,
                      DECODER_DATA_IN,
                      DATA_VALID,
                      DECODER_CONTROL_OUT,
                      DECODER_DATA_OUT,
                      DESCRAMBLED_DATA_OUT
                     );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input CLK;
input RESET;
input [65:0] DECODER_DATA_IN;
input DATA_VALID;
input ALTERNATE_ENCODE;

output [7:0] DECODER_CONTROL_OUT;
output [63:0] DECODER_DATA_OUT;
output [65:0] DESCRAMBLED_DATA_OUT;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire [7:0]  DECODER_CONTROL_OUT;
wire [63:0] DECODER_DATA_OUT;
wire [65:0] DESCRAMBLED_DATA_OUT;

wire        reset;
wire [65:0] decoder_data_in;
wire [7:0]  decoder_control_out;
wire [63:0] decoder_data_out;
wire [7:0]  decoder_block_type_field;
wire [1:0]  sync_header;
reg  [57:0] data_prev;
wire [57:0] data_to_save;
wire [63:0] data_shifted_39;
wire [63:0] data_shifted_58;
wire [63:0] block_payload;
wire [65:0] data;

reg [7:0] byte0;
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;
reg [7:0] byte4;
reg [7:0] byte5;
reg [7:0] byte6;
reg [7:0] byte7;
reg [6:0] byte0c;
reg [6:0] byte1c;
reg [6:0] byte2c;
reg [6:0] byte3c;
reg [6:0] byte4c;
reg [6:0] byte5c;
reg [6:0] byte6c;
reg [6:0] byte7c;
reg [3:0] ord0;
reg [3:0] ord4;

reg [8:0] decoded0;
reg [8:0] decoded1;
reg [8:0] decoded2;
reg [8:0] decoded3;
reg [8:0] decoded4;
reg [8:0] decoded5;
reg [8:0] decoded6;
reg [8:0] decoded7;
reg invalid_byte0;
reg invalid_byte1;
reg invalid_byte2;
reg invalid_byte3;
reg invalid_byte4;
reg invalid_byte5;
reg invalid_byte6;
reg invalid_byte7;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TERM    = 8'hfd;
parameter START   = 8'hfb;
parameter ORDER   = 8'h9c;
parameter ERROR   = 8'hfe;
parameter IDLE    = 8'h07;
parameter LPI     = 8'h06;
parameter FSIG    = 8'h5c;
`ifndef XFIPCS_16G32GFC
parameter IDLE_R  = 8'h1c;
parameter CODE_3C = 8'h3c;
parameter IDLE_A  = 8'h7c;
parameter IDLE_K  = 8'hbc;
parameter CODE_DC = 8'hdc;
parameter CODE_F7 = 8'hf7;
`endif

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign reset = RESET;

 assign decoder_data_in  = DECODER_DATA_IN;
 assign DECODER_CONTROL_OUT = decoder_control_out ;
 assign DECODER_DATA_OUT = decoder_data_out ;

 assign sync_header = decoder_data_in[1:0];
 assign data_to_save = (DATA_VALID) ? decoder_data_in[65:8] : data_prev;

 always @(posedge CLK)
   begin
    if (reset)
     data_prev <= 58'h0;
    else
     data_prev <= data_to_save;
   end


 assign data_shifted_39 = {decoder_data_in[26:2], data_prev[57:19]};
 assign data_shifted_58 = {decoder_data_in[7:2], data_prev};
 assign block_payload = decoder_data_in[65:2] ^ data_shifted_39 ^ data_shifted_58;
 assign data = {block_payload, sync_header};

 assign DESCRAMBLED_DATA_OUT = data;

 always @(*)
 begin
   byte0 = 8'h00;
   byte1 = 8'h00;
   byte2 = 8'h00;
   byte3 = 8'h00;
   byte4 = 8'h00;
   byte5 = 8'h00;
   byte6 = 8'h00;
   byte7 = 8'h00;
   byte0c = 7'h00;
   byte1c = 7'h00;
   byte2c = 7'h00;
   byte3c = 7'h00;
   byte4c = 7'h00;
   byte5c = 7'h00;
   byte6c = 7'h00;
   byte7c = 7'h00;
   ord0 = 4'h0;
   ord4 = 4'h0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       byte0c = 7'h1e;
       byte1c = 7'h1e;
       byte2c = 7'h1e;
       byte3c = 7'h1e;
       byte4c = 7'h1e;
       byte5c = 7'h1e;
       byte6c = 7'h1e;
       byte7c = 7'h1e;
     end
   else if (sync_header == 2'b10)
     begin
       byte0 = data[9 :2 ];
       byte1 = data[17:10];
       byte2 = data[25:18];
       byte3 = data[33:26];
       byte4 = data[41:34];
       byte5 = data[49:42];
       byte6 = data[57:50];
       byte7 = data[65:58];
     end
   else
     case(data[9:2])
     8'h1e:
       begin
         byte0c = data[16:10];
         byte1c = data[23:17];
         byte2c = data[30:24];
         byte3c = data[37:31];
         byte4c = data[44:38];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     8'h2d:
       begin
         byte0c = data[16:10];
         byte1c = data[23:17];
         byte2c = data[30:24];
         byte3c = data[37:31];
         ord4   = data[41:38];
         byte5  = data[49:42];
         byte6  = data[57:50];
         byte7  = data[65:58];
       end
     8'h33:
       begin
         byte0c = data[16:10];
         byte1c = data[23:17];
         byte2c = data[30:24];
         byte3c = data[37:31];
         byte5  = data[49:42];
         byte6  = data[57:50];
         byte7  = data[65:58];
       end
     8'h66:
       begin
         byte1  = data[17:10];
         byte2  = data[25:18];
         byte3  = data[33:26];
         ord0   = data[37:34];
         byte5  = data[49:42];
         byte6  = data[57:50];
         byte7  = data[65:58];
       end
     8'h55:
       begin
         byte1  = data[17:10];
         byte2  = data[25:18];
         byte3  = data[33:26];
         ord0   = data[37:34];
         ord4   = data[41:38];
         byte5  = data[49:42];
         byte6  = data[57:50];
         byte7  = data[65:58];
       end
     8'h78:
       begin
         byte1  = data[17:10];
         byte2  = data[25:18];
         byte3  = data[33:26];
         byte4  = data[41:34];
         byte5  = data[49:42];
         byte6  = data[57:50];
         byte7  = data[65:58];
       end
     8'h4b:
       begin
         byte1  = data[17:10];
         byte2  = data[25:18];
         byte3  = data[33:26];
         ord0   = data[37:34];
         byte4c = data[44:38];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     `ifndef XFIPCS_16G32GFC  
     8'h87:
       begin
         byte1c = data[23:17];
         byte2c = data[30:24];
         byte3c = data[37:31];
         byte4c = data[44:38];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     8'h99:
       begin
         byte0  = data[17:10];
         byte2c = data[30:24];
         byte3c = data[37:31];
         byte4c = data[44:38];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     8'haa:
       begin
         byte0  = data[17:10];
         byte1  = data[25:18];
         byte3c = data[37:31];
         byte4c = data[44:38];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     `endif  
     8'hb4:
       begin
         byte0  = data[17:10];
         byte1  = data[25:18];
         byte2  = data[33:26];
         byte4c = data[44:38];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
         ord4   = data[41:38];
         byte5  = data[49:42];
         byte6  = data[57:50];
         byte7  = data[65:58];
       end
     `ifndef XFIPCS_16G32GFC  
     8'hcc:
       begin
         byte0  = data[17:10];
         byte1  = data[25:18];
         byte2  = data[33:26];
         byte3  = data[41:34];
         byte5c = data[51:45];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     8'hd2:
       begin
         byte0  = data[17:10];
         byte1  = data[25:18];
         byte2  = data[33:26];
         byte3  = data[41:34];
         byte4  = data[49:42];
         byte6c = data[58:52];
         byte7c = data[65:59];
       end
     8'he1:
       begin
         byte0  = data[17:10];
         byte1  = data[25:18];
         byte2  = data[33:26];
         byte3  = data[41:34];
         byte4  = data[49:42];
         byte5  = data[57:50];
         byte7c = data[65:59];
       end
     `endif  
     8'hff:
       begin
         byte0  = data[17:10];
         byte1  = data[25:18];
         byte2  = data[33:26];
         byte3  = data[41:34];
         byte4  = data[49:42];
         byte5  = data[57:50];
         byte6  = data[65:58];
       end
     default:
       begin
         byte0c = 7'h1e;
         byte1c = 7'h1e;
         byte2c = 7'h1e;
         byte3c = 7'h1e;
         byte4c = 7'h1e;
         byte5c = 7'h1e;
         byte6c = 7'h1e;
         byte7c = 7'h1e;
       end
     endcase
 end


 assign decoder_block_type_field = block_payload[7:0];


 always @(*)
 begin : decode_byte0
   invalid_byte0 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded0 = {1'b1, ERROR};
       invalid_byte0 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded0 =  {1'b0, byte0};
   else if (decoder_block_type_field == 8'h78)
     decoded0 = {1'b1, START};
   `ifndef XFIPCS_16G32GFC  
   else if (decoder_block_type_field == 8'h87)
     decoded0 = {1'b1, TERM};
   `endif  
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h4b)
     begin
       case (ord0)
         4'h0:    decoded0 = {1'b1, ORDER};
         4'hf:    decoded0 = {1'b1, FSIG};
         default:
           begin
                  decoded0 = {1'b1, ERROR};
                  invalid_byte0 = 1'b1;
           end
       endcase
     end
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33)
     begin
       case (byte0c)
         7'h00:   decoded0 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded0 = {1'b1, IDLE_R};
         7'h33:   decoded0 = {1'b1, CODE_3C};
         7'h4b:   decoded0 = {1'b1, IDLE_A};
         7'h55:   decoded0 = {1'b1, IDLE_K};
         7'h66:   decoded0 = {1'b1, CODE_DC};
         7'h78:   decoded0 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded0 = {1'b1, ERROR};
         7'h06:   decoded0 = {1'b1, LPI};
         default:
           begin
                  decoded0 = {1'b1, ERROR};
                  invalid_byte0 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'hb4 ||
            decoder_block_type_field == 8'hff)
   `else
   else if (decoder_block_type_field == 8'h99 ||
            decoder_block_type_field == 8'haa ||
            decoder_block_type_field == 8'hb4 ||
            decoder_block_type_field == 8'hcc ||
            decoder_block_type_field == 8'hd2 ||
            decoder_block_type_field == 8'he1 ||
            decoder_block_type_field == 8'hff)
   `endif         
     decoded0 =  {1'b0, byte0};
   else
     begin
       decoded0 = {1'b1, ERROR};
       invalid_byte0 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte1
   invalid_byte1 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded1 = {1'b1, ERROR};
       invalid_byte1 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded1 = {1'b0, byte1};
   `ifndef XFIPCS_16G32GFC  
   else if (decoder_block_type_field == 8'h99)
     decoded1 = {1'b1, TERM};
   `endif
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33)
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h87)
   `endif         
     begin
       case (byte1c)
         7'h00:   decoded1 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded1 = {1'b1, IDLE_R};
         7'h33:   decoded1 = {1'b1, CODE_3C};
         7'h4b:   decoded1 = {1'b1, IDLE_A};
         7'h55:   decoded1 = {1'b1, IDLE_K};
         7'h66:   decoded1 = {1'b1, CODE_DC};
         7'h78:   decoded1 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded1 = {1'b1, ERROR};
         7'h06:   decoded1 = {1'b1, LPI};
         default:
           begin
                  decoded1 = {1'b1, ERROR};
                  invalid_byte1 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'hb4 ||
            decoder_block_type_field == 8'hff)
   `else
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'haa ||
            decoder_block_type_field == 8'hb4 ||
            decoder_block_type_field == 8'hcc ||
            decoder_block_type_field == 8'hd2 ||
            decoder_block_type_field == 8'he1 ||
            decoder_block_type_field == 8'hff)
   `endif         
     decoded1 = {1'b0, byte1};
   else
     begin
       decoded1 = {1'b1, ERROR};
       invalid_byte1 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte2
   invalid_byte2 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded2 = {1'b1, ERROR};
       invalid_byte2 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded2 = {1'b0, byte2};
   `ifndef XFIPCS_16G32GFC  
   else if (decoder_block_type_field == 8'haa)
     decoded2 = {1'b1, TERM};
   `endif
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33)
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h87 ||
            decoder_block_type_field == 8'h99)
   `endif         
     begin
       case (byte2c)
         7'h00:   decoded2 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded2 = {1'b1, IDLE_R};
         7'h33:   decoded2 = {1'b1, CODE_3C};
         7'h4b:   decoded2 = {1'b1, IDLE_A};
         7'h55:   decoded2 = {1'b1, IDLE_K};
         7'h66:   decoded2 = {1'b1, CODE_DC};
         7'h78:   decoded2 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded2 = {1'b1, ERROR};
         7'h06:   decoded2 = {1'b1, LPI};
         default:
           begin
                  decoded2 = {1'b1, ERROR};
                  invalid_byte2 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'hb4 ||
            decoder_block_type_field == 8'hff)
   `else 
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'hb4 ||
            decoder_block_type_field == 8'hcc ||
            decoder_block_type_field == 8'hd2 ||
            decoder_block_type_field == 8'he1 ||
            decoder_block_type_field == 8'hff)
   `endif         
     decoded2 = {1'b0, byte2};
   else
     begin
       decoded2 = {1'b1, ERROR};
       invalid_byte2 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte3
   invalid_byte3 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded3 = {1'b1, ERROR};
       invalid_byte3 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded3 = {1'b0, byte3};
   else if (decoder_block_type_field == 8'hb4)
     decoded3 = {1'b1, TERM};
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33)
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h2d ||
            decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h87 ||
            decoder_block_type_field == 8'h99 ||
            decoder_block_type_field == 8'haa)
   `endif         
     begin
       case (byte3c)
         7'h00:   decoded3 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded3 = {1'b1, IDLE_R};
         7'h33:   decoded3 = {1'b1, CODE_3C};
         7'h4b:   decoded3 = {1'b1, IDLE_A};
         7'h55:   decoded3 = {1'b1, IDLE_K};
         7'h66:   decoded3 = {1'b1, CODE_DC};
         7'h78:   decoded3 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded3 = {1'b1, ERROR};
         7'h06:   decoded3 = {1'b1, LPI};
         default:
           begin
                  decoded3 = {1'b1, ERROR};
                  invalid_byte3 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'hff)
   `else
   else if (decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'hcc ||
            decoder_block_type_field == 8'hd2 ||
            decoder_block_type_field == 8'he1 ||
            decoder_block_type_field == 8'hff)
   `endif         
     decoded3 = {1'b0, byte3};
   else
     begin
       decoded3 = {1'b1, ERROR};
       invalid_byte3 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte4
   invalid_byte4 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded4 = {1'b1, ERROR};
       invalid_byte4 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded4 = {1'b0, byte4};
   else if (decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h66)
     decoded4 = {1'b1, START};
   `ifndef XFIPCS_16G32GFC  
   else if (decoder_block_type_field == 8'hcc)
     decoded4 = {1'b1, TERM};
   `endif  
   else if (decoder_block_type_field == 8'h2d ||
            (decoder_block_type_field == 8'hb4 & ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'h55)
     begin
       case (ord4)
         4'h0:    decoded4 = {1'b1, ORDER};
         4'hf:    decoded4 = {1'b1, FSIG};
         default:
           begin
                  decoded4 = {1'b1, ERROR};
                  invalid_byte4 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h4b ||
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE))
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'h87 ||
            decoder_block_type_field == 8'h99 ||
            decoder_block_type_field == 8'haa ||
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE))
   `endif         
     begin
       case (byte4c)
         7'h00:   decoded4 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded4 = {1'b1, IDLE_R};
         7'h33:   decoded4 = {1'b1, CODE_3C};
         7'h4b:   decoded4 = {1'b1, IDLE_A};
         7'h55:   decoded4 = {1'b1, IDLE_K};
         7'h66:   decoded4 = {1'b1, CODE_DC};
         7'h78:   decoded4 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded4 = {1'b1, ERROR};
         7'h06:   decoded4 = {1'b1, LPI};
         default:
           begin
                  decoded4 = {1'b1, ERROR};
                  invalid_byte4 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'hff)
   `else
   else if (decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'hd2 ||
            decoder_block_type_field == 8'he1 ||
            decoder_block_type_field == 8'hff)
   `endif         
     decoded4 = {1'b0, byte4};
   else
     begin
       decoded4 = {1'b1, ERROR};
       invalid_byte4 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte5
   invalid_byte5 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded5 = {1'b1, ERROR};
       invalid_byte5 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded5 = {1'b0, byte5};
   `ifndef XFIPCS_16G32GFC  
   else if (decoder_block_type_field == 8'hd2)
     decoded5 = {1'b1, TERM};
   `endif
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e || 
            decoder_block_type_field == 8'h4b || 
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE))
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'h87 ||
            decoder_block_type_field == 8'h99 ||
            decoder_block_type_field == 8'haa ||
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'hcc)
   `endif         
     begin
       case (byte5c)
         7'h00:   decoded5 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded5 = {1'b1, IDLE_R};
         7'h33:   decoded5 = {1'b1, CODE_3C};
         7'h4b:   decoded5 = {1'b1, IDLE_A};
         7'h55:   decoded5 = {1'b1, IDLE_K};
         7'h66:   decoded5 = {1'b1, CODE_DC};
         7'h78:   decoded5 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded5 = {1'b1, ERROR};
         7'h06:   decoded5 = {1'b1, LPI};
         default:
           begin
                  decoded5 = {1'b1, ERROR};
                  invalid_byte5 = 1'b1;
           end
       endcase
     end
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h2d || 
            (decoder_block_type_field == 8'hb4 & ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'h33 || 
            decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'hff)
   `else
   else if (decoder_block_type_field == 8'h2d ||
            (decoder_block_type_field == 8'hb4 & ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'he1 ||
            decoder_block_type_field == 8'hff)
   `endif         
     decoded5 = {1'b0, byte5};
   else
     begin
       decoded5 = {1'b1, ERROR};
       invalid_byte5 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte6
   invalid_byte6 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded6 = {1'b1, ERROR};
       invalid_byte6 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded6 = {1'b0, byte6};
   `ifndef XFIPCS_16G32GFC  
   else if (decoder_block_type_field == 8'he1)
     decoded6 = {1'b1, TERM};
   `endif
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e || 
            decoder_block_type_field == 8'h4b || 
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE))
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'h87 ||
            decoder_block_type_field == 8'h99 ||
            decoder_block_type_field == 8'haa ||
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'hcc ||
            decoder_block_type_field == 8'hd2)
   `endif         
     begin
       case (byte6c)
         7'h00:   decoded6 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded6 = {1'b1, IDLE_R};
         7'h33:   decoded6 = {1'b1, CODE_3C};
         7'h4b:   decoded6 = {1'b1, IDLE_A};
         7'h55:   decoded6 = {1'b1, IDLE_K};
         7'h66:   decoded6 = {1'b1, CODE_DC};
         7'h78:   decoded6 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded6 = {1'b1, ERROR};
         7'h06:   decoded6 = {1'b1, LPI};
         default:
           begin
                  decoded6 = {1'b1, ERROR};
                  invalid_byte6 = 1'b1;
           end
       endcase
     end
   else if (decoder_block_type_field == 8'h2d ||
            (decoder_block_type_field == 8'hb4 & ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78 ||
            decoder_block_type_field == 8'hff)
     decoded6 = {1'b0, byte6};
   else
     begin
       decoded6 = {1'b1, ERROR};
       invalid_byte6 = 1'b1;
     end
 end

 always @(*)
 begin : decode_byte7
   invalid_byte7 = 1'b0;
   if (sync_header == 2'b00 || sync_header == 2'b11)
     begin
       decoded7 = {1'b1, ERROR};
       invalid_byte7 = 1'b1;
     end
   else if (sync_header == 2'b10)
     decoded7 = {1'b0, byte7};
   else if (decoder_block_type_field == 8'hff)
     decoded7 = {1'b1, TERM};
   `ifdef XFIPCS_16G32GFC
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h4b ||
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE))
   `else
   else if (decoder_block_type_field == 8'h1e ||
            decoder_block_type_field == 8'h4b ||
            decoder_block_type_field == 8'h87 ||
            decoder_block_type_field == 8'h99 ||
            decoder_block_type_field == 8'haa ||
            (decoder_block_type_field == 8'hb4 & ~ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'hcc ||
            decoder_block_type_field == 8'hd2 ||
            decoder_block_type_field == 8'he1)
   `endif         
     begin
       case (byte7c)
         7'h00:   decoded7 = {1'b1, IDLE};
         `ifndef XFIPCS_16G32GFC
         7'h2d:   decoded7 = {1'b1, IDLE_R};
         7'h33:   decoded7 = {1'b1, CODE_3C};
         7'h4b:   decoded7 = {1'b1, IDLE_A};
         7'h55:   decoded7 = {1'b1, IDLE_K};
         7'h66:   decoded7 = {1'b1, CODE_DC};
         7'h78:   decoded7 = {1'b1, CODE_F7};
         `endif
         7'h1e:   decoded7 = {1'b1, ERROR};
         7'h06:   decoded7 = {1'b1, LPI};
         default:
           begin
                  decoded7 = {1'b1, ERROR};
                  invalid_byte7 = 1'b1;
           end
       endcase
     end
   else if (decoder_block_type_field == 8'h2d ||
            (decoder_block_type_field == 8'hb4 & ALTERNATE_ENCODE) ||
            decoder_block_type_field == 8'h33 ||
            decoder_block_type_field == 8'h66 ||
            decoder_block_type_field == 8'h55 ||
            decoder_block_type_field == 8'h78)
     decoded7 = {1'b0, byte7};
   else
     begin
       decoded7 = {1'b1, ERROR};
       invalid_byte7 = 1'b1;
     end
 end

 assign decoder_data_out =
          (invalid_byte0 == 1'b1 || invalid_byte1 == 1'b1 ||
           invalid_byte2 == 1'b1 || invalid_byte3 == 1'b1 ||
           invalid_byte4 == 1'b1 || invalid_byte5 == 1'b1 ||
           invalid_byte6 == 1'b1 || invalid_byte7 == 1'b1)    ? 64'hfefefefefefefefe :
                {decoded7[7:0], decoded6[7:0], decoded5[7:0], decoded4[7:0],
                 decoded3[7:0], decoded2[7:0], decoded1[7:0], decoded0[7:0]} ;

 assign decoder_control_out =
          (invalid_byte0 == 1'b1 || invalid_byte1 == 1'b1 ||
           invalid_byte2 == 1'b1 || invalid_byte3 == 1'b1 ||
           invalid_byte4 == 1'b1 || invalid_byte5 == 1'b1 ||
           invalid_byte6 == 1'b1 || invalid_byte7 == 1'b1)           ? 8'hff :
                        {decoded7[8], decoded6[8], decoded5[8], decoded4[8],
                         decoded3[8], decoded2[8], decoded1[8], decoded0[8]} ;

endmodule
