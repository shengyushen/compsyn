// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_NEXT";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

  initial begin
    if (num_cks <= 0) begin
      ovl_error_t("Illegal value for parameter num_cks which must be set to value greater than 0");
    end
  end

`ifdef OVL_SHARED_CODE

  integer i = 0;

  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (start_event == 1'b1) begin
        i <= num_cks;
      end 
      else if (i != 1) begin
        i <= i - 1;
      end
    end
    else begin
      i <= 0;
    end
  end

`endif // OVL_SHARED_CODE

`ifdef OVL_ASSERT_ON

  property ASSERT_NEXT_START_WITHOUT_TEST_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  start_event |-> ##num_cks test_expr;
  endproperty

  property ASSERT_NEXT_TEST_WITHOUT_START_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  not ((!start_event) ##num_cks test_expr);
  endproperty

  property ASSERT_NEXT_NO_OVERLAP_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  start_event |-> (i <= 1);
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (num_cks > 0) begin
          A_ASSERT_NEXT_START_WITHOUT_TEST_P:
          assert property (ASSERT_NEXT_START_WITHOUT_TEST_P)
          else ovl_error_t("Test expression is not asserted after elapse of num_cks cycles from start event");

          if (check_missing_start) begin
            A_ASSERT_NEXT_TEST_WITHOUT_START_P:
            assert property (ASSERT_NEXT_TEST_WITHOUT_START_P)
            else ovl_error_t("Test expresson is asserted  without a corresponding start_event");
          end
          if (!check_overlapping) begin
            A_ASSERT_NEXT_NO_OVERLAP_P:
            assert property (ASSERT_NEXT_NO_OVERLAP_P)
            else ovl_error_t("Illegal overlapping condition of start event is detected");
          end
        end
      end
      `OVL_ASSUME : begin : ovl_assume
        if (num_cks > 0) begin
          M_ASSERT_NEXT_START_WITHOUT_TEST_P:
          assume property (ASSERT_NEXT_START_WITHOUT_TEST_P);

          if (check_missing_start) begin
            M_ASSERT_NEXT_TEST_WITHOUT_START_P:
            assume property (ASSERT_NEXT_TEST_WITHOUT_START_P);
          end
          if (!check_overlapping) begin
            M_ASSERT_NEXT_NO_OVERLAP_P:
            assume property (ASSERT_NEXT_NO_OVERLAP_P);
          end
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

    cover_start_event:
    cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                     start_event) )
                   ovl_cover_t("start_event covered");

    if (check_overlapping)
      cover_overlapping_start_events:
      cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                       (i > 1) && start_event) )
                     ovl_cover_t("overlapping_start_events covered");
  end

endgenerate

`endif // OVL_COVER_ON
