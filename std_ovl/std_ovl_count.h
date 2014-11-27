// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

// Support for printing of count of OVL assertions

`ifdef OVL_INIT_COUNT
  integer ovl_init_count;
  initial begin
    // Reset, prior to counting
    ovl_init_count = 0;

    // Display total number of OVL instances, just after initialization
    $monitor("\nOVL_METRICS: %d OVL assertions initialized\n",ovl_init_count);  
  end
`endif
