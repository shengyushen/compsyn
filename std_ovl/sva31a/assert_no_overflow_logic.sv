// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_NO_OVERFLOW";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_NO_OVERFLOW_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (test_expr == max) |=> ((test_expr > min) && (test_expr <= max));
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_NO_OVERFLOW_P: assert property (ASSERT_NO_OVERFLOW_P)
                                else ovl_error_t("Test expression changed value from allowed maximum value max to a value in the range max+1 to min");
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_NO_OVERFLOW_P: assume property (ASSERT_NO_OVERFLOW_P);
      end
      `OVL_IGNORE : begin : ovl_ignore
        // do nothing ;
      end
      default     : initial ovl_error_t("");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

generate

 if (coverage_level != `OVL_COVER_NONE) begin

  cover_test_expr_change:
  cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                   !$stable(test_expr) ))
                 ovl_cover_t("test_expr_change covered");

  cover_test_expr_at_min:
  cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                   $rose(test_expr == min) ))
                 ovl_cover_t("test_expr_at_min covered");

  cover_test_expr_at_max:
  cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                   $rose(test_expr == max) ))
                 ovl_cover_t("test_expr_at_max covered");

 end

endgenerate

`endif // OVL_COVER_ON
