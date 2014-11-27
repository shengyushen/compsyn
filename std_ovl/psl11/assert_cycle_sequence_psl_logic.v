// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_cycle_sequence.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_CYCLE_SEQUENCE";
  parameter NUM_CKS_1 = (num_cks-1);
  parameter NUM_CKS_2 = (NUM_CKS_1 > 0) ? (NUM_CKS_1 - 1) : 0;
 
 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
  reg [num_cks-1:0]  seq_queue;
                                                                                                           
  initial begin
    if (num_cks < 2) begin
      ovl_error_t("Illegal value for parameter num_cks which must be set to value greater than 1");
    end
  end
                                                                                                           
  initial begin
    seq_queue = {num_cks{1'b0}};
  end
                                                                                                           
  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b1) begin
      seq_queue <= {num_cks{1'b0}};
    end
    else begin
      seq_queue[num_cks-1] <= (necessary_condition == `OVL_TRIGGER_ON_FIRST_NOPIPE) ? 
                              (~(|seq_queue[num_cks-1:1])) && event_sequence[num_cks-1] : event_sequence[num_cks-1];
      seq_queue[NUM_CKS_2:0] <= (seq_queue >> 1) & event_sequence[NUM_CKS_2:0];
    end
  end

 
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_cycle_sequence_assert #(
                       .num_cks(num_cks),
                       .necessary_condition(necessary_condition))
                   assert_cycle_sequence_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .event_sequence(event_sequence),
                       .seq_queue(seq_queue));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_cycle_sequence_assume #(
                       .num_cks(num_cks),
                       .necessary_condition(necessary_condition))
                   assert_cycle_sequence_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .event_sequence(event_sequence),
                       .seq_queue(seq_queue));
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
    assert_cycle_sequence_cover #(
                       .num_cks(num_cks),
                       .necessary_condition(necessary_condition))
    assert_cycle_sequence_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .event_sequence(event_sequence),
                       .seq_queue(seq_queue));
 
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_cycle_sequence.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_cycle_sequence_assert (clk, reset_n, event_sequence, seq_queue);
       parameter num_cks = 2;
       parameter necessary_condition = 0;
       input clk, reset_n;
       input [num_cks-1:0] event_sequence, seq_queue;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_cycle_sequence_assume (clk, reset_n, event_sequence, seq_queue);
       parameter num_cks = 2;
       parameter necessary_condition = 0;
       input clk, reset_n;
       input [num_cks-1:0] event_sequence, seq_queue;
endmodule


//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_cycle_sequence_cover (clk, reset_n, event_sequence, seq_queue);
       parameter num_cks = 4;
       parameter necessary_condition = 0;
       input clk, reset_n;
       input [num_cks-1:0] event_sequence, seq_queue;
endmodule
