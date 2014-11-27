module SYNC_CELL(D,CP,Q);
 input  D;
 input  CP;
 output Q;

//`ifdef NEPTUNE

reg Q,sync1;

always @ (posedge CP)
  begin
    sync1 <=  D;
    Q     <=  sync1;
  end        
  

/*`else

   // vlint flag_dangling_net_within_module off
   // vlint flag_net_has_no_load off
   wire so;
   // vlint flag_net_has_no_load on
   // vlint flag_dangling_net_within_module on
   
   
 cl_a1_clksyncff_4x SYNC_CELL (.l1clk(CP),
                               .d(D),
                               .si(1'b0),
                               .siclk(1'b0),
                               .soclk(1'b0),
                               .q(Q),
                               .so(so) );

`endif 
  */
endmodule // SYNC_CELL
