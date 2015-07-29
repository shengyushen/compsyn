module latchinout(
   encode_data_in , 
   konstant , 
   encode_data_out , 
   clk
);

  output [7:0] encode_data_in ; 
  output konstant ; 
  input  [9:0] encode_data_out ; 
input clk;



  reg  [9:0] encode_data_out_pipe ; 
  reg [7:0] encode_data_in_pipe ; 
  reg konstant_pipe ; 
  wire [7:0] encode_data_in_w ; 
  wire konstant_w ; 


always @(posedge clk) begin
	encode_data_out_pipe <= encode_data_out ;
	encode_data_in_pipe <= encode_data_in_w ;
	konstant_pipe <= konstant_w ;
end


assign encode_data_in = encode_data_in_pipe ;
assign konstant = konstant_pipe ;

 resulting_dual inst_dec(
   .encode_data_in(encode_data_in_w) , 
   .konstant (konstant_w), 
   .encode_data_out (encode_data_out_pipe), 
   .clk(clk)
);

endmodule
