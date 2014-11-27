// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_DELTA";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  reg [width-1:0] last_test_expr;
  reg [width:0] temp_expr1;
  reg [width:0] temp_expr2;
  reg r_reset_n;
  initial r_reset_n = 0;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      r_reset_n <= `OVL_RESET_SIGNAL;
      last_test_expr <= test_expr;

      // check second clock afer reset
      if (r_reset_n && (last_test_expr != test_expr)) begin  
        temp_expr1 = {1'b0,last_test_expr} - {1'b0,test_expr}; 
        temp_expr2 = {1'b0,test_expr} - {1'b0,last_test_expr}; 
        // 2's complement result
        if (!((temp_expr1[width-1:0]>=min && temp_expr1[width-1:0]<=max) ||
              (temp_expr2[width-1:0]>=min && temp_expr2[width-1:0]<=max))) 
          begin
            ovl_error_t("Test expression changed by a delta value not in the range specified by min and max");
          end
      end
    end 
    else begin
      r_reset_n <= 0;
    end
  end // always

`endif // ASSERT_ON

`ifdef OVL_COVER_ON

  reg [width-1:0] prev_test_expr;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin
      if (test_expr != prev_test_expr)
        ovl_cover_t("test_expr_change covered");
      prev_test_expr <= test_expr;
    end
  end

`endif // OVL_COVER_ON
