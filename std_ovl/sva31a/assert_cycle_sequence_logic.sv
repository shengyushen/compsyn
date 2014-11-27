// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  `include "std_ovl_task.h"

  parameter assert_name = "ASSERT_CYCLE_SEQUENCE";
  parameter NC0 = (necessary_condition == `OVL_TRIGGER_ON_MOST_PIPE);
  parameter NC1 = (necessary_condition == `OVL_TRIGGER_ON_FIRST_PIPE);
  parameter NC2 = (necessary_condition == `OVL_TRIGGER_ON_FIRST_NOPIPE);
  parameter NUM_CKS_1 = (num_cks-1);
  parameter NUM_CKS_2 = (NUM_CKS_1 > 0) ? (NUM_CKS_1 - 1) : 0; 

`ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

  initial begin
    if (num_cks < 2) begin
      ovl_error_t("Illegal value for parameter num_cks which must be set to value greater than 1");
    end
  end

`ifdef OVL_SHARED_CODE

  reg [num_cks-1:0] seq_queue;

  initial begin
    seq_queue = {num_cks{1'b0}};
  end

  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b1) begin
      seq_queue <= {num_cks{1'b0}};
    end
    else begin
      seq_queue[num_cks-1] <= NC2 ? (~(|seq_queue[num_cks-1:1])) && event_sequence[num_cks-1] :
                                    event_sequence[num_cks-1];
      seq_queue[NUM_CKS_2:0] <= (seq_queue >> 1) & event_sequence[NUM_CKS_2:0];
    end
  end

`endif // OVL_SHARED_CODE

`ifdef OVL_ASSERT_ON

  property ASSERT_SEQUENCE_TRIGGER_ON_FIRST_P;
    @(posedge clk)
    disable iff (`OVL_RESET_SIGNAL != 1'b1)
      not (&((seq_queue[num_cks-1:1] & event_sequence[num_cks-2:0]) | ~(seq_queue[num_cks-1:1]))) != 1'b1;
  endproperty

  property ASSERT_SEQUENCE_TRIGGER_ON_MOST_P;
    @(posedge clk)
    disable iff (`OVL_RESET_SIGNAL != 1'b1)
    seq_queue[1] |-> event_sequence[0];
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (NC0) begin 
          A_ASSERT_SEQUENCE_TRIGGER_ON_MOST_P:
          assert property (ASSERT_SEQUENCE_TRIGGER_ON_MOST_P) else ovl_error_t("First num_cks-1 events occured but they are not followed by the last event in sequence");
        end
        if (NC1 || NC2) begin 
          A_ASSERT_SEQUENCE_TRIGGER_ON_FIRST_P:
          assert property (ASSERT_SEQUENCE_TRIGGER_ON_FIRST_P) else ovl_error_t("First event occured but it is not followed by the rest of the events in sequence");
        end
      end
      `OVL_ASSUME : begin : ovl_assume
        if (NC0) begin 
          M_ASSERT_SEQUENCE_TRIGGER_ON_MOST_P:
          assume property (ASSERT_SEQUENCE_TRIGGER_ON_MOST_P); 
        end
        if (NC1 || NC2) begin 
          M_ASSERT_SEQUENCE_TRIGGER_ON_FIRST_P:
          assume property (ASSERT_SEQUENCE_TRIGGER_ON_FIRST_P); 
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

      cover_sequence_trigger:
      cover property (@(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && 
                                      (((NC1 || NC2) && event_sequence[num_cks-1]) ||
                                       (NC0 && &seq_queue[1]))))
                     ovl_cover_t("sequence_trigger covered");
    end

  endgenerate

`endif // OVL_COVER_ON
