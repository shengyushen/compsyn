// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_ONE_COLD";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

  wire [width-1:0] test_expr_i = ~test_expr;
  wire [width-1:0] test_expr_i_1 = test_expr_i - {{width-1{1'b0}},1'b1};
  wire inactive_val=(inactive==`OVL_ALL_ONES)?1'b1:1'b0;

`ifdef OVL_ASSERT_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if ((test_expr ^ test_expr)=={width{1'b0}}) begin
        // OK, test_expr contains no X/Z.
        if ((inactive>`OVL_ALL_ONES) || (test_expr!={width{inactive_val}})) begin
          if (( test_expr_i == {width{1'b0}}) ||
              ((test_expr_i & test_expr_i_1) != {width{1'b0}})) begin
            ovl_error_t("Test expression contains more or less than 1 deasserted bits");
          end
        end
      end
      else begin
        `ifdef OVL_XCHECK_OFF
        // do nothing
        `else
        ovl_error_t("Test expression contains X/Z value");
        `endif // OVL_XCHECK_OFF
      end
    end
  end // always

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  reg [width-1:0] prev_test_expr;

  reg [width-1:0] one_colds_checked;
  reg [width-1:0] prev_one_colds_checked;

  initial begin
    one_colds_checked      = {width{1'b0}};
    prev_one_colds_checked = {width{1'b0}};
  end

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin

      if (test_expr != prev_test_expr) begin
        ovl_cover_t("test_expr_change covered");
        if (inactive == `OVL_ALL_ZEROS) begin
          if (test_expr == {width{inactive_val}})
            ovl_cover_t("test_expr_all_zeros covered");
        end
        if (inactive == `OVL_ALL_ONES) begin
          if (test_expr == {width{inactive_val}})
            ovl_cover_t("test_expr_all_ones covered");
        end
      end
      prev_test_expr <= test_expr;

      if ((test_expr ^ test_expr)=={width{1'b0}}) begin
        if ((inactive>`OVL_ALL_ONES) || (test_expr!={width{inactive_val}})) begin
          if (!((test_expr_i == {width{1'b0}}) ||
                (test_expr_i & test_expr_i_1) != {width{1'b0}})) begin
            one_colds_checked <= one_colds_checked | (~test_expr);
          end
        end
      end

      prev_one_colds_checked <= one_colds_checked;

      if ( (prev_one_colds_checked != one_colds_checked) &&
           (one_colds_checked == {width{1'b1}}) )
        ovl_cover_t("all_one_colds_checked covered");

    end
  end // always

`endif // OVL_COVER_ON
