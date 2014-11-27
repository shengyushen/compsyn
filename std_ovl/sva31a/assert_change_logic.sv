// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_CHANGE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

  initial begin
    if (~((action_on_new_start == `OVL_IGNORE_NEW_START) ||
          (action_on_new_start == `OVL_RESET_ON_NEW_START) ||
          (action_on_new_start == `OVL_ERROR_ON_NEW_START))) begin
      ovl_error_t("Illegal value set for parameter action_on_new_start");
    end
  end

`ifdef OVL_SHARED_CODE

  reg window = 0;
  integer i = 0;

  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (!window && start_event == 1'b1) begin
        window <= 1'b1;
        i <= num_cks;
      end
      else if (window) begin
        if (i == 1 && (action_on_new_start != `OVL_RESET_ON_NEW_START || start_event != 1'b1))
          window <= 1'b0;

        if (action_on_new_start == `OVL_RESET_ON_NEW_START && start_event == 1'b1)
          i <= num_cks;
        else if (i != 1)
          i <= i - 1;
      end // if (window)
    end
    else begin
      window <= 1'b0;
      i <= 0;
    end
  end

`endif // OVL_SHARED_CODE

`ifdef OVL_ASSERT_ON

  property ASSERT_CHANGE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (start_event && !window) |-> (##[1:num_cks] !$stable(test_expr));
  endproperty

  property ASSERT_CHANGE_RESET_ON_START_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (start_event) |=> (1'b1 [*0:num_cks-1] ##1
                     (!$stable(test_expr) || start_event));
  endproperty

  property ASSERT_CHANGE_ERR_ON_START_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  window |-> !start_event;
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (action_on_new_start != `OVL_RESET_ON_NEW_START)
          A_ASSERT_CHANGE_P:
          assert property (ASSERT_CHANGE_P)
          else ovl_error_t("Test expression did not change value within num_cks cycles after start event");
        if (action_on_new_start == `OVL_RESET_ON_NEW_START)
          A_ASSERT_CHANGE_RESET_ON_START_P:
          assert property (ASSERT_CHANGE_RESET_ON_START_P)
          else ovl_error_t("Start event evaluated TRUE before test expression changed");
        if (action_on_new_start == `OVL_ERROR_ON_NEW_START)
          A_ASSERT_CHANGE_ERR_ON_START_P:
          assert property (ASSERT_CHANGE_ERR_ON_START_P)
          else ovl_error_t("Illegal re-occurance of start event");
      end
      `OVL_ASSUME : begin : ovl_assume
        if (action_on_new_start != `OVL_RESET_ON_NEW_START)
          M_ASSERT_CHANGE_P:
          assume property (ASSERT_CHANGE_P);
        if (action_on_new_start == `OVL_RESET_ON_NEW_START)
          M_ASSERT_CHANGE_RESET_ON_START_P:
          assume property (ASSERT_CHANGE_RESET_ON_START_P);
        if (action_on_new_start == `OVL_ERROR_ON_NEW_START)
          M_ASSERT_CHANGE_ERR_ON_START_P:
          assume property (ASSERT_CHANGE_ERR_ON_START_P);
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

  cover_window_open:
  cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                   start_event && !window) )
                 ovl_cover_t("window_open covered");

  cover_window_close:
  cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                   window && (i == 1 && (action_on_new_start != `OVL_RESET_ON_NEW_START || start_event != 1'b1))
                                 )
                 )
                 ovl_cover_t("window_close covered");

  if (action_on_new_start == `OVL_RESET_ON_NEW_START)
    cover_window_resets:
    cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                                     start_event && window) )
                   ovl_cover_t("window_resets covered");

 end

endgenerate

`endif // OVL_COVER_ON
