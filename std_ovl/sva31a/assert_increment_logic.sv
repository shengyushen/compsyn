// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  `include "std_ovl_task.h"

  parameter assert_name = "ASSERT_INCREMENT";

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_INCREMENT_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (!($stable(test_expr)) && $past(`OVL_RESET_SIGNAL) ) |-> ( (test_expr > $past(test_expr)) ?
                                                               (test_expr - $past(test_expr) == value) :
                                                               (test_expr + ({width{1'b1}} - $past(test_expr)) + 1'b1 == value)
                                                           );
  endproperty

  generate 

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_INCREMENT_P:
          assert property (ASSERT_INCREMENT_P) else ovl_error_t("Test expression is increased by a value other than specified");
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_INCREMENT_P: assume property (ASSERT_INCREMENT_P); 
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
    end

  endgenerate

`endif // OVL_COVER_ON
