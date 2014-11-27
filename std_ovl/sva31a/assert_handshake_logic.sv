// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_HANDSHAKE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_HANDSHAKE_ACK_MIN_CYCLE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(req) |-> (!($rose(ack))) [*min_ack_cycle];
  endproperty

  property ASSERT_HANDSHAKE_ACK_MAX_CYCLE_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(req) && (!$rose(ack)) |-> (##[1:max_ack_cycle] ($rose(ack) || ($rose(req) && (req_drop == 1'b1))));
  endproperty
  
  property ASSERT_HANDSHAKE_ACK_MAX_LENGTH_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(ack) |-> (ack)[*deassert_count:max_ack_length] ##1 (!ack);
  endproperty 

  property ASSERT_HANDSHAKE_REQ_DROP_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(req) |-> (req[*1:$]) ##0 $rose(ack);
  endproperty

  property ASSERT_HANDSHAKE_MULTIPLE_REQ_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  not (($rose(req) && !ack) ##1 (req && !ack) [*0:$] ##1 (!req && !ack) [*1:$] ##1 ($rose(req)));
  endproperty

  property ASSERT_HANDSHAKE_REQ_DEASSERT_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  ($rose(ack) && (req)) |-> (##[0:deassert_count](!req));
  endproperty

  property ASSERT_HANDSHAKE_ACK_WITHOUT_REQ_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  $rose(ack) |-> req;
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        if (min_ack_cycle > 0) begin
          A_ASSERT_HANDSHAKE_ACK_MIN_CYCLE_P:
          assert property (ASSERT_HANDSHAKE_ACK_MIN_CYCLE_P)
          else ovl_error_t("Acknowledge asserted before elapse of specified minimum min_ack_cycle cycles from request");
        end
        if (max_ack_cycle > 0) begin
          A_ASSERT_HANDSHAKE_ACK_MAX_CYCLE_P:
          assert property (ASSERT_HANDSHAKE_ACK_MAX_CYCLE_P)
          else ovl_error_t("Acknowledge is not asserted within specified maximum max_ack_cycle cycles from request");
        end
        if ((max_ack_length > 0) && (max_ack_length >= deassert_count)) begin
          A_ASSERT_HANDSHAKE_ACK_MAX_LENGTH_P:
          assert property (ASSERT_HANDSHAKE_ACK_MAX_LENGTH_P)
          else ovl_error_t("Duration of continuous asserted state of acknowledge violates specified maximum ack_max_length cycles");
        end
        if (deassert_count > 0) begin
          A_ASSERT_HANDSHAKE_REQ_DEASSERT_P:
          assert property (ASSERT_HANDSHAKE_REQ_DEASSERT_P)
          else ovl_error_t("Duration of continuous asserted state of request violates specified deassert_count cycles");
        end
        if (req_drop > 0) begin
          A_ASSERT_HANDSHAKE_REQ_DROP_P:
          assert property (ASSERT_HANDSHAKE_REQ_DROP_P)
          else ovl_error_t("Request is deasserted before acknowledgement arrives");
        end
        A_ASSERT_HANDSHAKE_MULTIPLE_REQ_P:
        assert property (ASSERT_HANDSHAKE_MULTIPLE_REQ_P)
          else ovl_error_t("New request arrives before previous request is acknowledged");
        A_ASSERT_HANDSHAKE_ACK_WITHOUT_REQ_P:
        assert property (ASSERT_HANDSHAKE_ACK_WITHOUT_REQ_P)
          else ovl_error_t("Acknowledge arrives without a pending request");
      end
      `OVL_ASSUME : begin : ovl_assume
        if (min_ack_cycle > 0) begin
          M_ASSERT_HANDSHAKE_ACK_MIN_CYCLE_P:
          assume property (ASSERT_HANDSHAKE_ACK_MIN_CYCLE_P);
        end
        if (max_ack_cycle > 0) begin
          M_ASSERT_HANDSHAKE_ACK_MAX_CYCLE_P:
          assume property (ASSERT_HANDSHAKE_ACK_MAX_CYCLE_P);
        end
        if ((max_ack_length > 0) && (max_ack_length >= deassert_count)) begin
          M_ASSERT_HANDSHAKE_ACK_MAX_LENGTH_P:
          assume property (ASSERT_HANDSHAKE_ACK_MAX_LENGTH_P);
        end
        if (deassert_count > 0) begin
          M_ASSERT_HANDSHAKE_REQ_DEASSERT_P:
          assume property (ASSERT_HANDSHAKE_REQ_DEASSERT_P);
        end
        if (req_drop > 0) begin
          M_ASSERT_HANDSHAKE_REQ_DROP_P:
          assume property (ASSERT_HANDSHAKE_REQ_DROP_P);
        end
        M_ASSERT_HANDSHAKE_MULTIPLE_REQ_P:
        assume property (ASSERT_HANDSHAKE_MULTIPLE_REQ_P);
        M_ASSERT_HANDSHAKE_ACK_WITHOUT_REQ_P:
        assume property (ASSERT_HANDSHAKE_ACK_WITHOUT_REQ_P);
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

     cover_req_asserted:
     cover property (@(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && $rose(req)))
                     ovl_cover_t("req_asserted covered");

     cover_ack_asserted:
     cover property (@(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) && $rose(ack)))
                     ovl_cover_t("ack_asserted covered");
    end

  endgenerate

`endif // OVL_COVER_ON
