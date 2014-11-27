// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_IMPLICATION";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (antecedent_expr  == 1'b1 && consequent_expr  == 1'b0) begin
        ovl_error_t("Antecedent does not have consequent");
      end
    end 
  end

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin

      if (antecedent_expr == 1'b1) begin
        ovl_cover_t("antecedent covered");
      end

    end
  end

`endif // OVL_COVER_ON
