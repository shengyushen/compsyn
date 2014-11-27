// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_QUIESCENT_STATE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  reg r_sample_event;

  always @(posedge clk) r_sample_event <= sample_event;

  `ifdef OVL_END_OF_SIMULATION
    reg r_EOS;
    always @(posedge clk) r_EOS <= `OVL_END_OF_SIMULATION;
  `endif

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      `ifdef OVL_END_OF_SIMULATION
        if (((r_EOS == 1'b0 && `OVL_END_OF_SIMULATION ==1'b1) || 
             (r_sample_event == 1'b0 && sample_event == 1'b1)) && 
		(state_expr  != check_value)) begin
      `else
        if ((r_sample_event == 1'b0 && sample_event == 1'b1) && 
		(state_expr  != check_value)) begin
      `endif
          ovl_error_t("State expression is not equal to check_value while sample event is asserted");
        end
    end
  end

`endif // OVL_ASSERT_ON
