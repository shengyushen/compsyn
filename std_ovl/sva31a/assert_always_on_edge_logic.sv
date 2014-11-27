// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_ALWAYS_ON_EDGE";

  `include "std_ovl_task.h"
  
  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_ALWAYS_ON_EDGE_NOEDGE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  test_expr;
  endproperty

  property ASSERT_ALWAYS_ON_EDGE_POSEDGE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (##1 $rose(sampling_event)) |-> test_expr;
  endproperty

  property ASSERT_ALWAYS_ON_EDGE_NEGEDGE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (##1 $fell(sampling_event)) |-> test_expr;
  endproperty

  property ASSERT_ALWAYS_ON_EDGE_ANYEDGE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (##1 !($stable(sampling_event))) |-> test_expr;
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (edge_type == `OVL_NOEDGE) begin
          A_ASSERT_ALWAYS_ON_EDGE_NOEDGE_P:
          assert property (ASSERT_ALWAYS_ON_EDGE_NOEDGE_P)
          else ovl_error_t("Test expression is FALSE irrespective of sampling event");
        end

        if (edge_type == `OVL_POSEDGE) begin
          A_ASSERT_ALWAYS_ON_EDGE_POSEDGE_P:
          assert property (ASSERT_ALWAYS_ON_EDGE_POSEDGE_P)
          else ovl_error_t("Test expression is FALSE on posedge of sampling event");
        end

        if (edge_type == `OVL_NEGEDGE) begin
          A_ASSERT_ALWAYS_ON_EDGE_NEGEDGE_P:
          assert property (ASSERT_ALWAYS_ON_EDGE_NEGEDGE_P)
          else ovl_error_t("Test expression is FALSE on negedge of sampling event");
        end

        if (edge_type == `OVL_ANYEDGE) begin
          A_ASSERT_ALWAYS_ON_EDGE_ANYEDGE_P:
          assert property (ASSERT_ALWAYS_ON_EDGE_ANYEDGE_P)
          else ovl_error_t("Test expression is FALSE on any edge of sampling event");
        end
      end
      `OVL_ASSUME : begin : ovl_assume
        if (edge_type == `OVL_NOEDGE) begin
          M_ASSERT_ALWAYS_ON_EDGE_NOEDGE_P:
          assume property (ASSERT_ALWAYS_ON_EDGE_NOEDGE_P);
        end

        if (edge_type == `OVL_POSEDGE) begin
          M_ASSERT_ALWAYS_ON_EDGE_POSEDGE_P:
          assume property (ASSERT_ALWAYS_ON_EDGE_POSEDGE_P);
        end

        if (edge_type == `OVL_NEGEDGE) begin
          M_ASSERT_ALWAYS_ON_EDGE_NEGEDGE_P:
          assume property (ASSERT_ALWAYS_ON_EDGE_NEGEDGE_P);
        end

        if (edge_type == `OVL_ANYEDGE) begin
          M_ASSERT_ALWAYS_ON_EDGE_ANYEDGE_P:
          assume property (ASSERT_ALWAYS_ON_EDGE_ANYEDGE_P);
        end
      end
      `OVL_IGNORE : begin : ovl_ignore
        // do nothing ;
      end
      default     : initial ovl_error_t("");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON
