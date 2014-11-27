// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_CYCLE_SEQUENCE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

  parameter NC0 = (necessary_condition == `OVL_TRIGGER_ON_MOST_PIPE);
  parameter NC1 = (necessary_condition == `OVL_TRIGGER_ON_FIRST_PIPE);
  parameter NC2 = (necessary_condition == `OVL_TRIGGER_ON_FIRST_NOPIPE);
  parameter NUM_CKS_1 = (num_cks-1);
  parameter NUM_CKS_2 = (NUM_CKS_1 > 0) ? (NUM_CKS_1 - 1) : 0; 
  parameter LSB_1 = (NUM_CKS_1 > 0) ? 1 : 0; 

  reg [num_cks-1:0]  seq_queue;

  initial begin
    if (num_cks < 2) begin
      ovl_error_t("Illegal value for parameter num_cks which must be set to value greater than 1");
    end
  end

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

`ifdef OVL_ASSERT_ON

  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (NC1 || NC2) begin
        if (&((seq_queue[num_cks-1:LSB_1] & event_sequence[NUM_CKS_2:0]) | ~(seq_queue[num_cks-1:LSB_1])) == 1'b0)
          ovl_error_t("First event occured but it is not followed by the rest of the events in sequence");
      end
      if (NC0) begin
        if ((!seq_queue[1] || ((seq_queue[1] && event_sequence[0]))) == 1'b0) 
          ovl_error_t("First num_cks-1 events occured but they are not followed by the last event in sequence");
      end
    end
  end

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin
      if ((((NC1 || NC2) && event_sequence[num_cks-1]) || (NC0 && &seq_queue[1]))) begin
        ovl_cover_t("sequence_trigger covered");
      end
    end
  end

`endif // OVL_COVER_ON
