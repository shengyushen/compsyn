// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_TRANSITION";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  reg [width-1:0] r_start_state, r_next_state;

  reg assert_state;
  initial assert_state = 1'b0;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (assert_state == 1'b0) begin // INIT_STATE
        if (test_expr == start_state) begin
          `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE)
              ovl_cover_t("start_state covered");
          `endif // OVL_COVER_ON
          assert_state  <= 1'b1; // CHECK_STATE
          r_start_state <= start_state;
          r_next_state  <= next_state;
        end
      end
      else begin                      // CHECK_STATE
        if (test_expr == r_next_state) begin
          if (test_expr == start_state) begin
            `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE)
                ovl_cover_t("start_state covered");
            `endif // OVL_COVER_ON
            assert_state  <= 1'b1; // CHECK_STATE
            r_start_state <= start_state;
            r_next_state  <= next_state;
          end
          else
            assert_state <= 1'b0; // done ok.
        end
        else if (test_expr != r_start_state) begin
          `ifdef OVL_ASSERT_ON
            ovl_error_t("Test expression transitioned from value start_state to a value other than next_state");    // test_expr moves to unexpected state
          `endif // OVL_ASSERT_ON
          if (test_expr == start_state) begin
            `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE)
                ovl_cover_t("start_state covered");
            `endif // OVL_COVER_ON
            assert_state  <= 1'b1; // CHECK_STATE
            r_start_state <= start_state;
            r_next_state  <= next_state;
          end
          else
            assert_state <= 1'b0; // done error.
        end
      end
    end
    else begin
      assert_state <= 1'b0;
    end
  end // always

`endif // OVL_SHARED_CODE
