// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_WIDTH";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

  initial begin
    if ( (min_cks > 0) && (max_cks > 0) ) begin
      if (min_cks > max_cks) ovl_error_t("Illegal parameter values set where min_cks > max_cks");
    end
  end

`ifdef OVL_ASSERT_ON

  property ASSERT_WIDTH_MIN_CHECK_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(test_expr) |-> (test_expr[*min_cks]);
  endproperty

  property ASSERT_WIDTH_MAX_CHECK_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(test_expr) |-> (test_expr[*1:max_cks]) ##1 (!test_expr);
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (min_cks > 0) begin
          A_ASSERT_WIDTH_MIN_CHECK_P: assert property (ASSERT_WIDTH_MIN_CHECK_P)
                                      else ovl_error_t("Test expression was held TRUE for less than specified minimum min_cks cycles");
        end
        if (max_cks > 0) begin
          A_ASSERT_WIDTH_MAX_CHECK_P: assert property (ASSERT_WIDTH_MAX_CHECK_P)
                                      else ovl_error_t("Test expression was held TRUE for more than specified maximum max_cks cycles");
        end
      end
      `OVL_ASSUME : begin : ovl_assume
        if (min_cks > 0) begin
          M_ASSERT_WIDTH_MIN_CHECK_P: assume property (ASSERT_WIDTH_MIN_CHECK_P);
        end
        if (max_cks > 0) begin
          M_ASSERT_WIDTH_MAX_CHECK_P: assume property (ASSERT_WIDTH_MAX_CHECK_P);
        end
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

  cover_test_expr_asserts:
  cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                   $rose(test_expr)
                                 )
                 )
                 ovl_cover_t("test_expr_asserts covered");

  if (min_cks > 0) begin
    cover_test_expr_asserted_for_min_cks:
    cover property (@(posedge clk) (`OVL_RESET_SIGNAL != 1'b0) throughout 
                                   ($rose(test_expr)
                                    ##0
                                    (test_expr[*min_cks])
                                    ##1
                                    (!test_expr)
                                   )
                   )
                   ovl_cover_t("test_expr_asserted_for_min_cks covered");
  end

  if (max_cks > 0) begin
    cover_test_expr_asserted_for_max_cks:
    cover property (@(posedge clk) (`OVL_RESET_SIGNAL != 1'b0) throughout
                                   ($rose(test_expr)
                                    ##0
                                   (test_expr[*max_cks])
                                    ##1
                                   (!test_expr)
                                   )
                   )
                   ovl_cover_t("test_expr_asserted_for_max_cks covered");
  end

 end

endgenerate

`endif // OVL_COVER_ON
