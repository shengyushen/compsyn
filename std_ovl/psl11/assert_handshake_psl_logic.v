// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_handshake.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_HANDSHAKE";

`ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_handshake_assert #(
                       .min_ack_cycle(min_ack_cycle),
                       .max_ack_cycle(max_ack_cycle),
                       .req_drop(req_drop),
                       .deassert_count(deassert_count),
                       .max_ack_length(max_ack_length))
                   assert_handshake_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .req(req),
                       .ack(ack));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_handshake_assume #(
                       .min_ack_cycle(min_ack_cycle),
                       .max_ack_cycle(max_ack_cycle),
                       .req_drop(req_drop),
                       .deassert_count(deassert_count),
                       .max_ack_length(max_ack_length))
                   assert_handshake_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .req(req),
                       .ack(ack));
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
          assert_handshake_cover
          assert_handshake_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .req(req),
                       .ack(ack));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_handshake.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_handshake_assert (clk, reset_n, req, ack);
       parameter min_ack_cycle = 0;
       parameter max_ack_cycle = 0;
       parameter req_drop = 0;
       parameter deassert_count = 0;
       parameter max_ack_length = 0; 
       input clk, reset_n, req, ack; 
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_handshake_assume (clk, reset_n, req, ack);
       parameter min_ack_cycle = 0;
       parameter max_ack_cycle = 0;
       parameter req_drop = 0;
       parameter deassert_count = 0;
       parameter max_ack_length = 0;
       input clk, reset_n, req, ack;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_handshake_cover (clk, reset_n, req, ack);
       input clk, reset_n, req, ack;
endmodule
