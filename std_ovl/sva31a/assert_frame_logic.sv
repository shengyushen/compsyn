// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  `include "std_ovl_task.h"

  parameter assert_name = "ASSERT_FRAME";

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

  initial begin
    // *** NEW STATIC CHECK FOR MIN/MAX and action_on_new_start ***
    if (~((action_on_new_start == `OVL_IGNORE_NEW_START) ||
          (action_on_new_start == `OVL_RESET_ON_NEW_START) ||
          (action_on_new_start == `OVL_ERROR_ON_NEW_START))) begin
      ovl_error_t("Illegal value set for parameter action_on_new_start");
    end

    if (max_cks && (max_cks < min_cks)) begin
      ovl_error_t("Illegal parameter values set where min_cks > max_cks");
    end
  end

`ifdef OVL_ASSERT_ON

  integer ii;
  reg win;
  reg r_start_event;

  initial begin
    ii = 0;
    win = 0;
    r_start_event = 1'b0;
  end

  always @(posedge clk) begin
    r_start_event <= start_event;
  end

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b1) begin
      ii <= 0;
      win <= 0;
    end
    else begin
      if (max_cks > 0) begin
        case (win) 
          0: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                (test_expr != 1'b1)) begin
              win <= 1'b1;
              ii <= max_cks;
            end
          end
          1: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                action_on_new_start == `OVL_RESET_ON_NEW_START &&
                test_expr != 1'b1) begin
              ii <= max_cks;
            end
            else if (ii <= 1 || test_expr == 1'b1) begin
              win <= 1'b0;
            end
            else begin
              ii <= ii -1;
            end
          end
        endcase
      end
      else if (min_cks > 0) begin
        case (win) 
          0: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                (test_expr != 1'b1)) begin
              win <= 1'b1;
              ii <= min_cks;
            end
          end
          1: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 && 
                action_on_new_start == `OVL_RESET_ON_NEW_START &&
                test_expr != 1'b1) begin
              ii <= min_cks;
            end
            else if (ii <= 1 || test_expr == 1'b1) begin
              win <= 1'b0;
            end
            else begin
              ii <= ii -1;
            end
          end
        endcase
      end
    end
  end

  property ASSERT_FRAME_MIN0_MAX0_P;
  @(posedge clk) 
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(start_event) |-> test_expr;
  endproperty

  property ASSERT_FRAME_ERR_ON_START_P;
  @(posedge clk) 
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  !($rose(start_event) && win);
  endproperty

  property ASSERT_FRAME_MIN_CHECK_P;
  @(posedge clk) 
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  ($rose(start_event) && !win) |-> ((!test_expr[*min_cks]));
  endproperty

  property ASSERT_FRAME_MAX_CHECK_P;
  @(posedge clk) 
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  ($rose(start_event) && !win) |-> (!test_expr[*0:max_cks] ##1 test_expr);
  endproperty

  property ASSERT_FRAME_RESET_ON_START_MIN_CHECK_P;
  @(posedge clk) 
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(start_event) |-> (!test_expr ##1
                          ((!test_expr[*min_cks-1]) or
                           (!test_expr[*0:min_cks-1] ##0 $rose(start_event)))
                         );
  endproperty

  property ASSERT_FRAME_RESET_ON_START_MAX_CHECK_P;
  @(posedge clk) 
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  ($rose(start_event) && !test_expr) |=> (!test_expr[*0:max_cks-1] ##1
                                          (test_expr || ($rose(start_event)))
                                         );
  endproperty


  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (min_cks == 0 && max_cks == 0) begin
          A_ASSERT_FRAME_MIN0_MAX0_P:
          assert property (ASSERT_FRAME_MIN0_MAX0_P)
          else ovl_error_t("Test expression is not TRUE while start event is asserted when both parameters min_cks and max_cks are set to 0");
        end
        if (action_on_new_start == `OVL_IGNORE_NEW_START ||
            action_on_new_start == `OVL_ERROR_ON_NEW_START) begin
          if (min_cks > 0) begin
            A_ASSERT_FRAME_MIN_CHECK_P:
            assert property (ASSERT_FRAME_MIN_CHECK_P) 
            else ovl_error_t("Test expression is TRUE before elapse of specified minimum min_cks cycles from start event");
          end
          if (max_cks > 0) begin
            A_ASSERT_FRAME_MAX_CHECK_P:
            assert property (ASSERT_FRAME_MAX_CHECK_P) 
            else ovl_error_t("Test expression is not TRUE within specified maximum max_cks cycles from start event");
          end
        end
        if (action_on_new_start == `OVL_RESET_ON_NEW_START) begin
          if (min_cks > 0) begin
            A_ASSERT_FRAME_RESET_ON_START_MIN_CHECK_P:
            assert property (ASSERT_FRAME_RESET_ON_START_MIN_CHECK_P)
            else ovl_error_t("Test expression is TRUE before elapse of specified minimum min_cks cycles from start_event");
          end
          if (max_cks > 0) begin
            A_ASSERT_FRAME_RESET_ON_START_MAX_CHECK_P:
            assert property (ASSERT_FRAME_RESET_ON_START_MAX_CHECK_P)
            else ovl_error_t("Test expression is not TRUE within specified maximum max_cks cycles from start event");
          end
        end
        if (action_on_new_start == `OVL_ERROR_ON_NEW_START) begin
          A_ASSERT_FRAME_ERR_ON_START_P:
          assert property (ASSERT_FRAME_ERR_ON_START_P)
          else ovl_error_t("Illegal start event which has reoccured before completion of current window");
        end
      end
      `OVL_ASSUME : begin : ovl_assume
        if (min_cks == 0 && max_cks == 0) begin
          M_ASSERT_FRAME_MIN0_MAX0_P:
          assume property (ASSERT_FRAME_MIN0_MAX0_P);
        end
        if (action_on_new_start == `OVL_IGNORE_NEW_START ||
            action_on_new_start == `OVL_ERROR_ON_NEW_START) begin
          if (min_cks > 0) begin
            M_ASSERT_FRAME_MIN_CHECK_P:
            assume property (ASSERT_FRAME_MIN_CHECK_P);
          end
          if (max_cks > 0) begin
            M_ASSERT_FRAME_MAX_CHECK_P:
            assume property (ASSERT_FRAME_MAX_CHECK_P);
          end
        end
        if (action_on_new_start == `OVL_RESET_ON_NEW_START) begin
          if (min_cks > 0) begin
            M_ASSERT_FRAME_RESET_ON_START_MIN_CHECK_P:
            assume property (ASSERT_FRAME_RESET_ON_START_MIN_CHECK_P);
          end
          if (max_cks > 0) begin
            M_ASSERT_FRAME_RESET_ON_START_MAX_CHECK_P:
            assume property (ASSERT_FRAME_RESET_ON_START_MAX_CHECK_P);
          end
        end
        if (action_on_new_start == `OVL_ERROR_ON_NEW_START) begin
          M_ASSERT_FRAME_ERR_ON_START_P:
          assume property (ASSERT_FRAME_ERR_ON_START_P);
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

      cover_frame_start:
      cover property (@(posedge clk) (`OVL_RESET_SIGNAL != 1'b0 &&
                                      ($rose(start_event))))
                     ovl_cover_t("start_event covered");
    end

  endgenerate

`endif // OVL_COVER_ON
