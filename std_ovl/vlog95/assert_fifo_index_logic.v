// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_FIFO_INDEX";

  integer cnt;
  initial begin
    cnt=0;
    if (depth==0) ovl_error_t("Illegal value for parameter depth which must be set to value greater than 0");
  end

  `include "std_ovl_task.h"
  
  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  always @(posedge clk) begin
    `ifdef OVL_GLOBAL_RESET
      if (`OVL_GLOBAL_RESET != 1'b0) begin
    `else
      if (reset_n != 0) begin // active low reset
    `endif
        if ({push!=0,pop!=0} == 2'b10) begin // push
          `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE)
              ovl_cover_t("fifo_push covered");
          `endif // OVL_COVER_ON
          if ((cnt + push) > depth) begin
             ovl_error_t("Fifo overflow detected");
          end
          else begin
            cnt <= cnt + push;
            `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE)
                if ((cnt + push) == depth)
                  ovl_cover_t("fifo_full covered");
            `endif // OVL_COVER_ON
          end
        end
        else if ({push!=0,pop!=0} == 2'b01) begin // pop
          `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE)
              ovl_cover_t("fifo_pop covered");
          `endif // OVL_COVER_ON
          if (cnt < pop) begin
             ovl_error_t("Fifo underflow detected");
          end
          else begin
            cnt <= cnt - pop;
            `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE)
                if ((cnt - pop) == 0)
                  ovl_cover_t("fifo_empty covered");
            `endif // OVL_COVER_ON
          end
        end
        else if ({push!=0,pop!=0} == 2'b11) begin // push & pop
          `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE) begin
              ovl_cover_t("fifo_simultaneous_push_pop covered");
            end
          `endif // OVL_COVER_ON
          if (!simultaneous_push_pop) begin
             ovl_error_t("Illegal simultaneous push pop detected");
          end
          else begin
            if ((cnt + push - pop) > depth) begin
              ovl_error_t("Fifo overflow detected due to simultaneous push pop operations");
            end
            else if ((cnt + push) < pop) begin
              ovl_error_t("Fifo underflow detected due to simultaneous push pop operations");
            end
            else begin
              cnt <= cnt + push - pop;
              `ifdef OVL_COVER_ON
                if (coverage_level != `OVL_COVER_NONE) begin
                  if ((cnt + push - pop) == depth)
                    ovl_cover_t("fifo_full covered");
                  else if ((cnt + push - pop) == 0)
                    ovl_cover_t("fifo_empty covered");
                end
              `endif // OVL_COVER_ON
            end
          end
        end
      end
      else begin
        cnt <= 0;
      end
  end

`endif // OVL_SHARED_CODE
