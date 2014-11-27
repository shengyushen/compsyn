// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_ALWAYS_ON_EDGE";

  `include "std_ovl_task.h"
  
  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  reg sampling_event_prev;
  reg r_reset_n;
  initial r_reset_n = 1'b0;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      r_reset_n <= reset_n;
// Capture Sampling Event @Clock for rising edge detections
      sampling_event_prev <= sampling_event; 
      if ((edge_type == `OVL_NOEDGE) && (!test_expr))
        ovl_error_t("Test expression is FALSE irrespective of sampling event");
      else if ((edge_type == `OVL_POSEDGE) && (!sampling_event_prev) && 
	       (sampling_event) && (!test_expr) && r_reset_n)
        ovl_error_t("Test expression is FALSE on posedge of sampling event");
      else if ((edge_type == `OVL_NEGEDGE) && (sampling_event_prev) && 
	       (!sampling_event) && (!test_expr) && r_reset_n)
        ovl_error_t("Test expression is FALSE on negedge of sampling event");
      else if ((edge_type == `OVL_ANYEDGE) && 
	       (sampling_event_prev != sampling_event) && (!test_expr) &&
               r_reset_n)
        ovl_error_t("Test expression is FALSE on any edge of sampling event");
    end
    else
      r_reset_n <= 1'b0;
  end

`endif // OVL_ASSERT_ON
