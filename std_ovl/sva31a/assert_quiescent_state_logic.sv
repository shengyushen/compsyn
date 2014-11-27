// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_QUIESCENT_STATE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  `ifdef OVL_END_OF_SIMULATION
    property ASSERT_QUIESCENT_STATE_P;
    @(posedge clk)
    disable iff (`OVL_RESET_SIGNAL != 1'b1)
    ($rose(`OVL_END_OF_SIMULATION) || $rose(sample_event)) |-> (state_expr == check_value);
    endproperty
  `else
    property ASSERT_QUIESCENT_STATE_P;
    @(posedge clk)
    disable iff (`OVL_RESET_SIGNAL != 1'b1)
    $rose(sample_event) |-> (state_expr == check_value);
    endproperty
  `endif // OVL_END_OF_SIMULATION

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_QUIESCENT_STATE_P: assert property (ASSERT_QUIESCENT_STATE_P)
                                    else ovl_error_t("State expression is not equal to check_value while sample event is asserted");
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_QUIESCENT_STATE_P: assume property (ASSERT_QUIESCENT_STATE_P);
      end
      `OVL_IGNORE : begin : ovl_ignore
        // do nothing ;
      end
      default     : initial ovl_error_t("");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON
