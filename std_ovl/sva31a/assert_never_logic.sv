// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_NEVER";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_NEVER_XZ_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (!($isunknown(test_expr)));
  endproperty

  property ASSERT_NEVER_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  !($isunknown(test_expr)) |-> (test_expr != 1'b1);
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_NEVER_P:
        assert property (ASSERT_NEVER_P)
        else ovl_error_t("Test expression is not FALSE");

        `ifdef OVL_XCHECK_OFF
        // do nothing
        `else
        A_ASSERT_NEVER_XZ_P:
        assert property (ASSERT_NEVER_XZ_P)
        else ovl_error_t("Test expression contains X/Z value");
        `endif // OVL_XCHECK_OFF
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_NEVER_P:    assume property (ASSERT_NEVER_P);
        `ifdef OVL_XCHECK_OFF
        // do nothing
        `else
        M_ASSERT_NEVER_XZ_P: assume property (ASSERT_NEVER_XZ_P);
        `endif // OVL_XCHECK_OFF
      end
      `OVL_IGNORE : begin : ovl_ignore
        // do nothing ;
      end
      default     : initial ovl_error_t("");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON
