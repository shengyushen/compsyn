// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_ODD_PARITY";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_ODD_PARITY_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (^(test_expr));
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_ODD_PARITY_P: assert property (ASSERT_ODD_PARITY_P)
                               else ovl_error_t("Test expression does not exhibit odd parity");
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_ODD_PARITY_P: assume property (ASSERT_ODD_PARITY_P);
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
                                   !$stable(test_expr) ) )
                 ovl_cover_t("test_expr_change covered");

 end

endgenerate

`endif // OVL_COVER_ON
