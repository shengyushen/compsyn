// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_FRAME";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  // local parameters
  parameter num_cks = (max_cks>min_cks)?max_cks:min_cks;
  parameter FRAME_START = 1'b0;
  parameter FRAME_CHECK = 1'b1;
  parameter START_flag=action_on_new_start & 2'b11;
  parameter EDGE_flag=action_on_new_start & 3'b100;

  reg r_state;
  reg r_start_event;

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
    r_state=FRAME_START;
    r_start_event = 1'b0;
  end

  integer ii;

  reg r_test_expr;
  initial r_test_expr = 1'b0;

  always @(posedge clk) begin
    r_start_event <= start_event;
    if (EDGE_flag) r_test_expr <= test_expr;
  end

  always @(posedge clk) begin
    `ifdef OVL_GLOBAL_RESET
      if (`OVL_GLOBAL_RESET != 1'b0) begin
    `else
      if (reset_n != 0) begin  // active low reset
    `endif
        case (r_state)
          FRAME_START:
            // assert_frame() behaves like assert_implication()
            //     when min_cks==0 and max_cks==0
            if ((min_cks==0) && (max_cks==0)) begin
              if ((r_start_event == 1'b0) && (start_event==1'b1) &&
                  (test_expr==1'b0)) begin
                // FAIL, it does not behave like assert_implication()
                ovl_error_t("Test expression is not TRUE while start event is asserted when both parameters min_cks and max_cks are set to 0");
              end
            end
            // wait for start_event (0->1)
            else if ((r_start_event == 1'b0) && (start_event == 1'b1)) begin
              if ((min_cks != 0) && (test_expr==1'b1)) begin
                // FAIL, test_expr should not happen before min_cks
                ovl_error_t("Test expression is TRUE before elapse of specified minimum min_cks cycles from start event");
              end
              else if (!(min_cks == 0 && test_expr == 1'b1)) begin
                r_state <= FRAME_CHECK;
                ii <= 1;
              end
            end
          FRAME_CHECK:
            // start_event (0->1) has occurred
            // start checking
            begin
              // Count clock ticks
              if ((r_start_event == 1'b0) && (start_event == 1'b1)) begin
                if ((min_cks != 0) && (test_expr==1'b1) &&
                    (action_on_new_start == `OVL_RESET_ON_NEW_START)) begin
                  // FAIL, test_expr should not happen before min_cks
                  ovl_error_t("Test expression is TRUE before elapse of specified minimum min_cks cycles from start event");
                  r_state <= FRAME_START;
                end
                // start_event (0->1) happens again -- re-started!!!
                else if (action_on_new_start == `OVL_IGNORE_NEW_START) begin
                  if (max_cks) ii <= ii + 1;
                  else if (ii < min_cks) ii <= ii + 1;
                end
                else if (action_on_new_start == `OVL_RESET_ON_NEW_START)
                  ii <= 1;
                else if (action_on_new_start == `OVL_ERROR_ON_NEW_START) begin
                  ovl_error_t("Illegal start event which has reoccured before completion of current window");
                  if (max_cks) ii <= ii + 1;
                  else if (ii < min_cks) ii <= ii + 1;
                end
              end
              else begin
                  if (max_cks) ii <= ii + 1;
                  else if (ii < min_cks) ii <= ii + 1;
              end

              // Check for (0,0), (0,M), (m,0), (m,M) conditions
              if (min_cks == 0) begin
                if (max_cks == 0) begin
                  // (0,0): (min_cks==0, max_cks==0)
                  // This condition is UN-REACHABLE!!!
                  ovl_error_t("Test expression is not TRUE while start event is asserted when both parameters min_cks and max_cks are set to 0");
                  r_state <= FRAME_START;
                end
                else begin // max_cks > 0
                  // (0,M): (min_cks==0, max_cks>0)
                  if ((r_test_expr==1'b0) && (test_expr == 1'b1)) begin
                    // OK, ckeck is done. Go to FRAME_START state for next check.
                    r_state <= FRAME_START;
                  end
                  else begin
                    if (ii == max_cks &&
                        !(r_start_event == 1'b0 && start_event == 1'b1 &&
                          action_on_new_start == `OVL_RESET_ON_NEW_START)
                       ) begin
                      // FAIL, test_expr does not happen at/before max_cks
                      ovl_error_t("Test expression is not TRUE within specified maximum max_cks cycles from start event");
                      r_state <= FRAME_START;
                    end
                  end
                end
              end
              else begin // min_cks > 0
                if (max_cks == 0) begin
                  // (m,0): (min_cks>0, max_cks==0)
                  if (ii == min_cks) begin
                      // OK, test_expr does not happen before min_cks
                      r_state <= FRAME_START;
                  end
                  else begin
                    if ((r_test_expr==1'b0) && (test_expr == 1'b1) &&
                        !(r_start_event == 1'b0 && start_event == 1'b1 &&
                          action_on_new_start == `OVL_RESET_ON_NEW_START)
                       ) begin
                      // FAIL, test_expr should not happen before min_cks
                      ovl_error_t("Test expression is TRUE before elapse of specified minimum min_cks cycles from start event");
                      r_state <= FRAME_START;
                    end
                  end
                end
                else begin // max_cks > 0
                  // (m,M): (min_cks>0, max_cks>0)
                  if ((r_test_expr==1'b0) && (test_expr == 1'b1)) begin
                    r_state <= FRAME_START;
                    if (ii < min_cks &&
                        !(r_start_event == 1'b0 && start_event == 1'b1 &&
                          action_on_new_start == `OVL_RESET_ON_NEW_START)
                       ) begin
                      // FAIL, test_expr should not happen before min_cks
                      ovl_error_t("Test expression is TRUE before elapse of specified minimum min_cks cycles from start event");
                    end
                    // else OK, we are done!!!
                  end
                  else begin
                    if (ii == max_cks &&
                        !(r_start_event == 1'b0 && start_event == 1'b1 &&
                          action_on_new_start == `OVL_RESET_ON_NEW_START)
                       ) begin
                      // FAIL, test_expr does not happen at/before max_cks
                      ovl_error_t("Test expression is not TRUE within specified maximum max_cks cycles from start event");
                      r_state <= FRAME_START;
                    end
                  end
                end
              end
            end
        endcase
      end
      else begin
         r_state <= FRAME_START;
      end
  end // always            

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  reg prev_start_event;

  initial begin
    prev_start_event = 1'b0;
  end

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin
      if ((start_event != prev_start_event) && (prev_start_event == 1'b0)) begin
        ovl_cover_t("start_event covered");
      end
      prev_start_event <= start_event;
    end
  end

`endif // OVL_COVER_ON
