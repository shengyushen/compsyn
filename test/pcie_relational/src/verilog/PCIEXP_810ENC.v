


`include "defines.v"




`timescale 1 ns / 10 ps

module PCIEXP_810ENC
    (
      PCLK250                                    ,
      Reset_P2                                   ,         
      DataIn_P2                                  ,         
      KCodeIn_P2                                 ,         
      UseNegDisp_P2                              ,         

      DataOut_P2                                           
    );


input              PCLK250                       ;
input     [7:0]    DataIn_P2                     ;
input              KCodeIn_P2                    ;
input              Reset_P2                      ;
input              UseNegDisp_P2                 ;

output    [9:0]    DataOut_P2                    ;









wire      [7:0]    DATA_IN                       ;




wire               L40                           ;
wire               L04                           ;
wire               L13_1                         ;
wire               L13_2                         ;
wire               L13_4                         ;
wire               L13_8                         ;

wire      [5:0]    DATA_OUT_56                   ;



wire               PLUS_56_FLP_DISP              ;
wire               MINUS_56_NEUT_DISP            ;
wire               MINUS_56_FLP_DISP             ;




wire      [3:0]    DATA_OUT_34                   ;
wire               ALT_7                         ;




wire               PLUS_34_FLP_DISP              ;
wire               PLUS_34_NEUT_DISP             ;
wire               MINUS_34_NEUT_DISP            ;
wire               MINUS_34_FLP_DISP             ;




wire               KCODE_OPT                     ;
reg                DISPARITY_P0                  ;
wire               DISPARITY_P2                  ;
wire               DISPARITY                     ;
wire               DISPARITY_56                  ;




wire               INVERT56                      ;
wire               INVERT34                      ;

wire      [9:0]    DATA_OUT_810                  ;  




wire      [9:0]    DATA_OUT_FLP                  ;  


wire               BP_DATAIN_56_00011            ;
wire               BP_DATAIN_56_00110            ;
wire               BP_DATAIN_56_00101            ;
wire               BP_DATAIN_56_11111            ;
wire               BP_DATAIN_56_00111            ;
wire               BP_DATAIN_56_11XXX            ;
wire               BP_DATAIN_56_XX00X            ;



wire               BP_DATAIN_56_00000            ;
wire               BP_DATAIN_56_10000            ;
wire               BP_DATAIN_56_01000            ;
wire               BP_DATAIN_56_00100            ;
wire               BP_DATAIN_56_00010            ;
wire               BP_DATAIN_56_11110            ;



wire               BP_DATAIN_56_00001            ;
wire               BP_DATAIN_56_11101            ;
wire               BP_DATAIN_56_11011            ;
wire               BP_DATAIN_56_10111            ;
wire               BP_DATAIN_56_01111            ;



wire               BP_DATAOUT_56_00XXXX          ;
wire               BP_DATAOUT_56_11XXXX          ;
wire               BP_DATAIN_34_111              ;
wire               BP_DATAIN_34_000              ;



wire               BP_DATAIN_34_001              ;








  always @(posedge PCLK250) DISPARITY_P0 <= DISPARITY_P2;






  
  assign DATA_IN[0] = DataIn_P2[7];  
  assign DATA_IN[1] = DataIn_P2[6];  
  assign DATA_IN[2] = DataIn_P2[5];  
  assign DATA_IN[3] = DataIn_P2[4];  
  assign DATA_IN[4] = DataIn_P2[3];  
  assign DATA_IN[5] = DataIn_P2[2];  
  assign DATA_IN[6] = DataIn_P2[1];  
  assign DATA_IN[7] = DataIn_P2[0];  







  assign L40   =  (DATA_IN[7:4] == 4'b1111); 
  assign L04   =  (DATA_IN[7:4] == 4'b0000); 
  assign L13_1 =  (DATA_IN[7:4] == 4'b0001); 
  assign L13_2 =  (DATA_IN[7:4] == 4'b0010);
  assign L13_4 =  (DATA_IN[7:4] == 4'b0100);
  assign L13_8 =  (DATA_IN[7:4] == 4'b1000);

  assign BP_DATAIN_56_00011 = (DATA_IN[7:3] == 5'b00011);
  assign BP_DATAIN_56_00110 = (DATA_IN[7:3] == 5'b00110);
  assign BP_DATAIN_56_00101 = (DATA_IN[7:3] == 5'b00101);
  assign BP_DATAIN_56_11111 = (DATA_IN[7:3] == 5'b11111);
  assign BP_DATAIN_56_00111 = (DATA_IN[7:3] == 5'b00111);

  assign BP_DATAIN_56_11XXX = (DATA_IN[7:6] == 2'b11);
  assign BP_DATAIN_56_XX00X = (DATA_IN[5:4] == 2'b00);





  
  assign DATA_OUT_56[5] = DATA_IN[7];

  assign DATA_OUT_56[4] = (DATA_IN[6] & ~L40) | L04;

  assign DATA_OUT_56[3] = DATA_IN[5] | L04 | BP_DATAIN_56_00011;

  assign DATA_OUT_56[2] = DATA_IN[4] & ~L40;

  assign DATA_OUT_56[1] = (DATA_IN[3] ^ L13_1) | (L13_8 | L13_4 | L13_2);

  assign DATA_OUT_56[0] = (BP_DATAIN_56_XX00X & (DATA_IN[3] ^ BP_DATAIN_56_11XXX)) |
                          ((DATA_IN[7] ^ DATA_IN[6]) & (DATA_IN[5] ^ DATA_IN[4]) & (~DATA_IN[3])) |
                          (BP_DATAIN_56_00110) |
                          (BP_DATAIN_56_00101) |
                          (BP_DATAIN_56_11111) |
                          (BP_DATAIN_56_00111  & KCodeIn_P2);





  assign BP_DATAIN_56_00000 = (DATA_IN[7:3] == 5'b00000);
  assign BP_DATAIN_56_10000 = (DATA_IN[7:3] == 5'b10000);
  assign BP_DATAIN_56_01000 = (DATA_IN[7:3] == 5'b01000);
  assign BP_DATAIN_56_00100 = (DATA_IN[7:3] == 5'b00100);
  assign BP_DATAIN_56_00010 = (DATA_IN[7:3] == 5'b00010);
  assign BP_DATAIN_56_11110 = (DATA_IN[7:3] == 5'b11110);

  assign PLUS_56_FLP_DISP   = BP_DATAIN_56_00000  |
                              BP_DATAIN_56_10000  |
                              BP_DATAIN_56_01000  |
                              BP_DATAIN_56_00100  |
                              BP_DATAIN_56_00010  |
                              BP_DATAIN_56_11110  |
                              BP_DATAIN_56_00011;




  assign MINUS_56_NEUT_DISP = (DATA_IN[7:3] == 5'b11100);


  assign BP_DATAIN_56_00001 = (DATA_IN[7:3] == 5'b00001);
  assign BP_DATAIN_56_11011 = (DATA_IN[7:3] == 5'b11011);
  assign BP_DATAIN_56_10111 = (DATA_IN[7:3] == 5'b10111);
  assign BP_DATAIN_56_11101 = (DATA_IN[7:3] == 5'b11101);
  assign BP_DATAIN_56_01111 = (DATA_IN[7:3] == 5'b01111);

  assign MINUS_56_FLP_DISP  = BP_DATAIN_56_00001 |
                              BP_DATAIN_56_11101 |
                              BP_DATAIN_56_11011 |
                              BP_DATAIN_56_10111 |
                              BP_DATAIN_56_01111 |
                              BP_DATAIN_56_11111 |
                             (BP_DATAIN_56_00111 & KCodeIn_P2);




  assign BP_DATAOUT_56_00XXXX = (DATA_OUT_810[5:4] == 2'b00);
  assign BP_DATAOUT_56_11XXXX = (DATA_OUT_810[5:4] == 2'b11);
  assign BP_DATAIN_34_111     = (DATA_IN[2:0] == 3'b111);
  assign BP_DATAIN_34_000     = (DATA_IN[2:0] == 3'b000);


    assign ALT_7 = ((DISPARITY_56 & BP_DATAOUT_56_00XXXX) |
                 (~DISPARITY_56 & BP_DATAOUT_56_11XXXX) |
                  KCodeIn_P2) & BP_DATAIN_34_111;

  assign DATA_OUT_34[3] = DATA_IN[2] & ~ALT_7;
  assign DATA_OUT_34[2] = DATA_IN[1] | BP_DATAIN_34_000;
  assign DATA_OUT_34[1] = DATA_IN[0];
  assign DATA_OUT_34[0] = ((DATA_IN[2] ^ DATA_IN[1]) & ~DATA_IN[0]) | ALT_7;




  assign BP_DATAIN_34_001  = (DATA_IN[2:0] == 3'b001);

  assign PLUS_34_FLP_DISP  = BP_DATAIN_34_000 | BP_DATAIN_34_001;
  assign PLUS_34_NEUT_DISP = BP_DATAIN_56_00111 & KCodeIn_P2 & (DATA_IN[2] ^ DATA_IN[1]);




  assign MINUS_34_NEUT_DISP = (DATA_IN[2:0] == 3'b110);
  assign MINUS_34_FLP_DISP  = (DATA_IN[2:0] == 3'b111);




    assign KCODE_OPT = BP_DATAIN_56_11101 | BP_DATAIN_56_11011 | BP_DATAIN_56_10111 |
                     BP_DATAIN_56_01111 | BP_DATAIN_56_00111;



    assign DISPARITY_56 = DISPARITY ^ (PLUS_56_FLP_DISP | MINUS_56_FLP_DISP);



    assign DISPARITY_P2 = ~Reset_P2 & (DISPARITY_56 ^ (PLUS_34_FLP_DISP | MINUS_34_FLP_DISP));


  assign DISPARITY = ~UseNegDisp_P2 & DISPARITY_P0;



  assign INVERT56 = ((~DISPARITY) & PLUS_56_FLP_DISP) |
                    (DISPARITY & (MINUS_56_NEUT_DISP | MINUS_56_FLP_DISP)) |
                    (~KCODE_OPT & KCodeIn_P2);


    assign INVERT34 = ((~DISPARITY_56) & (PLUS_34_FLP_DISP | PLUS_34_NEUT_DISP)) |
                    (DISPARITY_56 & (MINUS_34_NEUT_DISP | MINUS_34_FLP_DISP));



    assign DATA_OUT_810[9] = DATA_OUT_56[5] ^ INVERT56;
  assign DATA_OUT_810[8] = DATA_OUT_56[4] ^ INVERT56;
  assign DATA_OUT_810[7] = DATA_OUT_56[3] ^ INVERT56;
  assign DATA_OUT_810[6] = DATA_OUT_56[2] ^ INVERT56;
  assign DATA_OUT_810[5] = DATA_OUT_56[1] ^ INVERT56;
  assign DATA_OUT_810[4] = DATA_OUT_56[0] ^ INVERT56;

  assign DATA_OUT_810[3] = DATA_OUT_34[3] ^ INVERT34;
  assign DATA_OUT_810[2] = DATA_OUT_34[2] ^ INVERT34;
  assign DATA_OUT_810[1] = DATA_OUT_34[1] ^ INVERT34;
  assign DATA_OUT_810[0] = DATA_OUT_34[0] ^ INVERT34;





  assign DATA_OUT_FLP[9] = DATA_OUT_810[0]; 
  assign DATA_OUT_FLP[8] = DATA_OUT_810[1]; 
  assign DATA_OUT_FLP[7] = DATA_OUT_810[2]; 
  assign DATA_OUT_FLP[6] = DATA_OUT_810[3]; 
  assign DATA_OUT_FLP[5] = DATA_OUT_810[4]; 
  assign DATA_OUT_FLP[4] = DATA_OUT_810[5]; 
  assign DATA_OUT_FLP[3] = DATA_OUT_810[6]; 
  assign DATA_OUT_FLP[2] = DATA_OUT_810[7]; 
  assign DATA_OUT_FLP[1] = DATA_OUT_810[8]; 
  assign DATA_OUT_FLP[0] = DATA_OUT_810[9]; 


  assign DataOut_P2 = DATA_OUT_FLP;



endmodule

