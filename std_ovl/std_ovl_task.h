// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  integer error_count;
  initial error_count = 0;

  task ovl_error_t;
    input [8*128-1:0] err_msg;
    reg   [8*16-1:0] err_typ;
  begin
    error_count = error_count + 1;
    `ifdef OVL_SYNTHESIS_OFF
    `else
      case (severity_level)
        `OVL_FATAL   : err_typ = "OVL_FATAL";
        `OVL_ERROR   : err_typ = "OVL_ERROR";
        `OVL_WARNING : err_typ = "OVL_WARNING";
        `OVL_INFO    : err_typ = "OVL_INFO";
        default      : begin
                         err_typ = "OVL_ERROR";
                         $display("OVL_ERROR: Illegal option used in parameter 'severity_level'");
                       end
      endcase
      `ifdef OVL_MAX_REPORT_ERROR
        if (error_count <= `OVL_MAX_REPORT_ERROR) begin
      `endif
          case (property_type) 
            `OVL_ASSERT,
            `OVL_ASSUME : $display("%s : %s : %s : %0s : severity %0d : time %0t : %m",
                    err_typ, assert_name, msg, err_msg, severity_level, $time);
            default     : $display("OVL_ERROR: Illegal option used in parameter 'property_type'");
          endcase
      `ifdef OVL_MAX_REPORT_ERROR
        end
      `endif
      if (severity_level == `OVL_FATAL) ovl_finish_t;
    `endif // OVL_SYNTHESIS_OFF
    end
  endtask

  task ovl_finish_t;
    begin
    `ifdef OVL_SYNTHESIS_OFF
    `else
      #100 $finish; 
    `endif // OVL_SYNTHESIS_OFF
    end
  endtask

  task ovl_init_msg_t;
   case (property_type)
     `OVL_ASSERT,
     `OVL_ASSUME :
       begin
        `ifdef OVL_SYNTHESIS_OFF
        `else
          `ifdef OVL_INIT_COUNT
            #0.1 `OVL_INIT_COUNT = `OVL_INIT_COUNT + 1;
          `else
            $display("OVL_NOTE: %s: %s initialized @ %m Severity: %0d, Message: %s", `OVL_VERSION, assert_name,severity_level, msg);
          `endif
        `endif // OVL_SYNTHESIS_OFF
       end
     `OVL_IGNORE :
       begin
        // do nothing 
       end
     default : $display("OVL_ERROR: Illegal option used in parameter 'property_type'");
   endcase
  endtask

  integer cover_count;
  initial cover_count = 0;

  task ovl_cover_t;
    input [8*64-1:0] cvr_msg;
  begin
   cover_count = cover_count + 1;
   `ifdef OVL_SYNTHESIS_OFF
   `else
     `ifdef OVL_MAX_REPORT_COVER_POINT
       if (cover_count <= `OVL_MAX_REPORT_COVER_POINT) begin
     `endif
         case (coverage_level)
           `OVL_COVER_NONE : ; // do nothing
           `OVL_COVER_ALL  : $display("OVL_COVER_POINT : %s : %0s : time %0t : %m", assert_name, cvr_msg, $time);
           default         : $display("OVL_ERROR: Illegal option used in parameter 'coverage_level'");
         endcase
     `ifdef OVL_MAX_REPORT_COVER_POINT
       end
     `endif
   `endif // OVL_SYNTHESIS_OFF
  end
  endtask
