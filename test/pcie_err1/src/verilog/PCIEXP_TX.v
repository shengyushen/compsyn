

`include "defines.v"






`timescale 1 ns / 10 ps

module PCIEXP_TX
    (


      PCLK250                                    ,



      RST_BeaconEnable_R0                        ,



      CNTL_RESETN_P0                             ,
      CNTL_Loopback_P0                           ,
      CNTL_TXEnable_P0                           ,



      RX_LoopbackData_P2                         ,



      TXCOMPLIANCE                               ,
      TXDATA                                     ,
      TXDATAK                                    ,
      TXELECIDLE                                 ,



      HSS_TXBEACONCMD                            ,
      HSS_TXD                                    ,
      HSS_TXELECIDLE				,
      
      assertion_shengyushen

    );





input              PCLK250                       ;



input              RST_BeaconEnable_R0           ;



input              CNTL_RESETN_P0                ;
input              CNTL_Loopback_P0              ;
input              CNTL_TXEnable_P0              ;



input     [9:0]    RX_LoopbackData_P2            ;



input              TXCOMPLIANCE                  ;
input     [7:0]    TXDATA                        ;
input              TXDATAK                       ;
input              TXELECIDLE                    ;



output             HSS_TXBEACONCMD               ;
output    [9:0]    HSS_TXD                       ;
output             HSS_TXELECIDLE                ;

output		assertion_shengyushen;












wire               InputDataEnable_P2            ;
reg                InputDataEnable_P0            ;
reg       [7:0]    InputData_P0                  ;
reg                InputDataK_P0                 ;
reg                InputCompliance_P0            ;
wire               Reset810_P2                   ;



wire      [9:0]    EncodedData_P2                ;



wire      [9:0]    MuxedData_P2                  ;



wire               OutputDataEnable_P2           ;
reg       [9:0]    OutputData_P0                 ;
wire               OutputElecIdle_P2             ;
reg                OutputElecIdle_P0             ;






  assign HSS_TXBEACONCMD = RST_BeaconEnable_R0 & ~TXELECIDLE;







  assign InputDataEnable_P2 = CNTL_TXEnable_P0 & ~TXELECIDLE;

  always @(posedge PCLK250)
    if (InputDataEnable_P2)
      begin
        InputData_P0       <= TXDATA;
        InputDataK_P0      <= TXDATAK;
        InputCompliance_P0 <= TXCOMPLIANCE;
      end






  always @(posedge PCLK250)
    if (CNTL_RESETN_P0 == 1'b0) InputDataEnable_P0 <= 1'b0;
    else                        InputDataEnable_P0 <= InputDataEnable_P2;

  assign Reset810_P2 = ~InputDataEnable_P0;






  PCIEXP_810ENC U_ENC
    (
      .PCLK250               (PCLK250            ),
      .Reset_P2              (Reset810_P2        ),
      .DataIn_P2             (InputData_P0       ),
      .KCodeIn_P2            (InputDataK_P0      ),
      .UseNegDisp_P2         (InputCompliance_P0 ),

      .DataOut_P2            (EncodedData_P2     )
    );





  
  assign MuxedData_P2 = (CNTL_Loopback_P0 ? RX_LoopbackData_P2 : EncodedData_P2);





  
  assign OutputDataEnable_P2 = InputDataEnable_P0;

  always @(posedge PCLK250)
    if (OutputDataEnable_P2) OutputData_P0 <= MuxedData_P2;





  
  assign OutputElecIdle_P2 = ~InputDataEnable_P0;

  always @(posedge PCLK250)
    if (CNTL_RESETN_P0 == 1'b0) OutputElecIdle_P0 <= 1'b1;
    else                        OutputElecIdle_P0 <= OutputElecIdle_P2;





  
  assign HSS_TXD        = OutputData_P0;
  assign HSS_TXELECIDLE = OutputElecIdle_P0;


//  assign assertion_shengyushen=(TXDATAK==1'b0) && (CNTL_RESETN_P0==1'b1) && (CNTL_TXEnable_P0==1'b1) && (TXELECIDLE==1'b0) && (CNTL_Loopback_P0==1'b0) && (TXCOMPLIANCE==1'b1);
  assign assertion_shengyushen=(TXDATAK==1'b0 || (TXDATAK==1'b1 && (TXDATA==8'h1C  || TXDATA==8'h3C  || TXDATA==8'h5C  || TXDATA==8'h9C  || TXDATA==8'hBC  || TXDATA==8'hDC  || TXDATA==8'hFC  || TXDATA==8'hF7  || TXDATA==8'hFB  || TXDATA==8'hFD  || TXDATA==8'hFE  ))) && (CNTL_RESETN_P0==1'b1) && (CNTL_TXEnable_P0==1'b1) && (TXELECIDLE==1'b0) && (CNTL_Loopback_P0==1'b0) && (TXCOMPLIANCE==1'b1);

endmodule


