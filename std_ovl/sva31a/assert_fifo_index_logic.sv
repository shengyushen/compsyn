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
          if ((cnt + push) <= depth) begin
            cnt <= cnt + push;
          end
        end
        else if ({push!=0,pop!=0} == 2'b01) begin // pop
          if (cnt >= pop) begin
            cnt <= cnt - pop;
          end
        end
        else if ({push!=0,pop!=0} == 2'b11) begin // push & pop
          if (!simultaneous_push_pop) begin
            //ILLEGAL PUSH AND POP
          end
          else begin
            if ((cnt + push - pop) > depth) begin
              //OVERFLOW"
            end
            else if ((cnt + push) < pop) begin
              //UNDERFLOW
            end
            else begin
              cnt <= cnt + push - pop;
            end
          end
        end
      end
      else begin
        cnt <= 0;
      end
  end

`endif // OVL_SHARED_CODE

`ifdef OVL_ASSERT_ON

  property ASSERT_FIFO_INDEX_OVERFLOW_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  push && !(!simultaneous_push_pop && push && pop) |-> ((cnt + push - pop) <= depth);
  endproperty

  property ASSERT_FIFO_INDEX_UNDERFLOW_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (pop && !(!simultaneous_push_pop && push && pop) && (push == 0 || (((cnt + push - pop) <= depth)))) |-> ((cnt + push) >= pop);
  endproperty

  property ASSERT_FIFO_INDEX_ILLEGAL_PUSH_POP_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  !(push && pop);
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert

        A_ASSERT_FIFO_INDEX_OVERFLOW_P:
        assert property (ASSERT_FIFO_INDEX_OVERFLOW_P)
        else ovl_error_t("Fifo overflow detected");

        A_ASSERT_FIFO_INDEX_UNDERFLOW_P:
        assert property (ASSERT_FIFO_INDEX_UNDERFLOW_P)
        else ovl_error_t("Fifo underflow detected");

        if (!simultaneous_push_pop) begin
          A_ASSERT_FIFO_INDEX_ILLEGAL_PUSH_POP_P:
          assert property (ASSERT_FIFO_INDEX_ILLEGAL_PUSH_POP_P)
          else ovl_error_t("Illegal simultaneous push pop detected");
        end
      end
      `OVL_ASSUME : begin : ovl_assume

        M_ASSERT_FIFO_INDEX_OVERFLOW_P:
        assume property (ASSERT_FIFO_INDEX_OVERFLOW_P);

        M_ASSERT_FIFO_INDEX_UNDERFLOW_P:
        assume property (ASSERT_FIFO_INDEX_UNDERFLOW_P);

        if (!simultaneous_push_pop) begin
          M_ASSERT_FIFO_INDEX_ILLEGAL_PUSH_POP_P:
          assume property (ASSERT_FIFO_INDEX_ILLEGAL_PUSH_POP_P);
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

  cover_fifo_full:
  cover property ( @(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && 
    // case where only push is true and fifo goes to full
    (((push !=0) && (cnt +push == depth) && (pop ==0)) || 

    // case with simultaneous push and pop and fifo goes to full
    ((pop != 0) && (push != 0) && ((cnt - pop + push) == depth) && 
    (simultaneous_push_pop)))
    ) )
    ovl_cover_t("fifo_full covered");

  cover_fifo_empty:
  cover property ( @(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) &&
    // case where only pop is true and fifo goes to empty
    (((pop != 0) && (push == 0) && ((cnt - pop) == 0)) || 

    // case with simultaneous push and pop and fifo goes to empty
    ((pop != 0) && (push != 0) && ((cnt - pop + push) == 0) && 
    (simultaneous_push_pop)))
    ) )
    ovl_cover_t("fifo_empty covered");

  cover_fifo_push:
  cover property ( @(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && 
    push && pop == 0))
    ovl_cover_t("fifo_push covered");

  cover_fifo_pop:
  cover property ( @(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && 
    pop && push == 0))
    ovl_cover_t("fifo_pop covered");

  cover_fifo_simultaneous_push_pop:
  cover property ( @(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && push && pop))
    ovl_cover_t("fifo_simultaneous_push_pop covered");

 end

endgenerate

`endif // OVL_COVER_ON
