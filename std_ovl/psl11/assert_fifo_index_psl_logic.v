// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_fifo_index.vlib

`include "std_ovl_task.h"

 parameter assert_name = "ASSERT_FIFO_INDEX";

 initial
  begin
    if (depth==0) ovl_error_t("Depth parameter value must be > 0");
  end

 parameter fifo_used_depth_reg_width = `log(depth + 1); 

`ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

 reg [fifo_used_depth_reg_width-1 : 0] fifo_used_depth;
 always @ (posedge clk)
  begin
   if (`OVL_RESET_SIGNAL != 1'b1)
    fifo_used_depth <= 0;
   else
    fifo_used_depth <= (pop == 0 && push != 0) ? (fifo_used_depth < depth ? fifo_used_depth + 1 : fifo_used_depth) : //only push
                       (pop != 0 && push == 0) ? (fifo_used_depth > 0 ? fifo_used_depth - 1 : fifo_used_depth) : //only pop
                       (pop !=0 && push != 0) ? fifo_used_depth + push - pop : //simultaneous push pop
                       fifo_used_depth; //no push no pop
  end

`ifdef OVL_ASSERT_ON
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
         assert_fifo_index_assert #(
                       .depth(depth),
                       .push_width(push_width),
                       .pop_width(pop_width),
                       .simultaneous_push_pop(simultaneous_push_pop),
                       .fifo_used_depth_reg_width(fifo_used_depth_reg_width)) 
                assert_fifo_index_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .push(push),
                       .pop(pop),
                       .fifo_used_depth(fifo_used_depth));
                  end
     `OVL_ASSUME: begin: assume_checks
         assert_fifo_index_assume #(
                       .depth(depth),
                       .push_width(push_width),
                       .pop_width(pop_width),
                       .simultaneous_push_pop(simultaneous_push_pop),
                       .fifo_used_depth_reg_width(fifo_used_depth_reg_width))
                assert_fifo_index_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .push(push),
                       .pop(pop),
                       .fifo_used_depth(fifo_used_depth));
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t("");
   endcase
 endgenerate
`endif

`ifdef OVL_COVER_ON
 generate
  if (coverage_level != `OVL_COVER_NONE)
   begin: cover_checks
          assert_fifo_index_cover #(
                       .depth(depth),
                       .push_width(push_width),
                       .pop_width(pop_width),
                       .simultaneous_push_pop(simultaneous_push_pop),
                       .fifo_used_depth_reg_width(fifo_used_depth_reg_width))
                assert_fifo_index_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .push(push),
                       .pop(pop),
                       .fifo_used_depth(fifo_used_depth));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_fifo_index.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_fifo_index_assert (clk, reset_n, push, pop, fifo_used_depth );
       parameter depth=1;
       parameter push_width = 1;
       parameter pop_width = 1;
       parameter simultaneous_push_pop = 1;
       parameter fifo_used_depth_reg_width = 1;
       input clk, reset_n;
       input [push_width-1:0] push;
       input [pop_width-1:0] pop; 
       input [fifo_used_depth_reg_width-1:0] fifo_used_depth;

//Any required modeling layer code for asserted properties here

endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_fifo_index_assume (clk, reset_n, push, pop, fifo_used_depth );
       parameter depth=1;
       parameter push_width = 1;
       parameter pop_width = 1;
       parameter simultaneous_push_pop = 1;
       parameter fifo_used_depth_reg_width = 1;
       input clk, reset_n;
       input [push_width-1:0] push;
       input [pop_width-1:0] pop;
       input [fifo_used_depth_reg_width-1:0] fifo_used_depth;

//Any required modeling layer code for assumed properties here

endmodule


//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_fifo_index_cover (clk, reset_n, push, pop, fifo_used_depth);
       parameter depth=1;
       parameter push_width = 1;
       parameter pop_width = 1;
       parameter simultaneous_push_pop = 1;
       parameter fifo_used_depth_reg_width = 1;
       input clk, reset_n;
       input [push_width-1:0] push;
       input [pop_width-1:0] pop;
       input [fifo_used_depth_reg_width-1:0] fifo_used_depth;

//Any only coverage related modeling layer code for properties here

endmodule
