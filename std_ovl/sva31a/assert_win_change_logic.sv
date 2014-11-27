// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_WIN_CHANGE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  reg window = 0;

  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (!window && start_event == 1'b1)
        window <= 1'b1;
      else if (window && end_event == 1'b1)
        window <= 1'b0;
    end
    else begin
      window <= 1'b0;
    end
  end

`endif // OVL_SHARED_CODE

`ifdef OVL_ASSERT_ON

  property ASSERT_WIN_CHANGE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (start_event && !window) |=> (($stable(test_expr) && !end_event) [*0:$]) ##1
                               !$stable(test_expr);
                     
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_WIN_CHANGE_P: assert property (ASSERT_WIN_CHANGE_P)
                               else ovl_error_t("Test expression has not changed value before window is closed");
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_WIN_CHANGE_P: assume property (ASSERT_WIN_CHANGE_P);
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

  cover_window:
  cover property (@(posedge clk) (`OVL_RESET_SIGNAL != 1'b0) throughout
                                 ((start_event && !window) ##1
                                  (!end_event && window) [*0:$] ##1
                                  (end_event && window)) )
                 ovl_cover_t("window covered");

 end

endgenerate

`endif // OVL_COVER_ON
