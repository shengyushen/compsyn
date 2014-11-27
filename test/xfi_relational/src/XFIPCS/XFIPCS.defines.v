

//-----------------------------------------------------------------------------
// Start of definitions
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// 1. Module Names
// The following configuration items control the module names of modules
// which contain other configuration settings.  This enables the user to
// generate multiple configurations of the core and instantiate them in
// one design without configuration and module name collisions.
//
// The definitions below describe the module (and file) names of the logic
// as provided.

`define XFIPCS_TOPLEVELNAME                     XFIPCS
`define XFIPCS_TOPLEVELNAME_ASYNC_DRS           XFIPCS_ASYNC_DRS
`define XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS       XFIPCS_ASYNC_BUS_DRS
`define XFIPCS_TOPLEVELNAME_BER_FSM             XFIPCS_BER_FSM
`define XFIPCS_TOPLEVELNAME_BER_MONITOR         XFIPCS_BER_MONITOR
`define XFIPCS_TOPLEVELNAME_64B66B_DEC          XFIPCS_64B66B_DEC
`define XFIPCS_TOPLEVELNAME_64B66B_ENC          XFIPCS_64B66B_ENC
`define XFIPCS_TOPLEVELNAME_LOCK_FSM            XFIPCS_LOCK_FSM
`define XFIPCS_TOPLEVELNAME_MDIO                XFIPCS_MDIO
`define XFIPCS_TOPLEVELNAME_RESET               XFIPCS_RESET
`define XFIPCS_TOPLEVELNAME_RX_BLOCK_SYNC       XFIPCS_RX_BLOCK_SYNC
`define XFIPCS_TOPLEVELNAME_RX_FIFO             XFIPCS_RX_FIFO
`define XFIPCS_TOPLEVELNAME_RX_FLOW             XFIPCS_RX_FLOW
`define XFIPCS_TOPLEVELNAME_RX_FSM              XFIPCS_RX_FSM
`define XFIPCS_TOPLEVELNAME_RX_LPI_FSM          XFIPCS_RX_LPI_FSM
`define XFIPCS_TOPLEVELNAME_RX_PCS              XFIPCS_RX_PCS
`define XFIPCS_TOPLEVELNAME_RX_SDR_TO_DDR       XFIPCS_RX_SDR_TO_DDR
`define XFIPCS_TOPLEVELNAME_RX_TPC              XFIPCS_RX_TPC
`define XFIPCS_TOPLEVELNAME_TX_DDR_TO_SDR       XFIPCS_TX_DDR_TO_SDR
`define XFIPCS_TOPLEVELNAME_TX_FIFO             XFIPCS_TX_FIFO
`define XFIPCS_TOPLEVELNAME_TX_FLOW             XFIPCS_TX_FLOW
`define XFIPCS_TOPLEVELNAME_TX_FSM              XFIPCS_TX_FSM
`define XFIPCS_TOPLEVELNAME_TX_GEARBOX          XFIPCS_TX_GEARBOX
`define XFIPCS_TOPLEVELNAME_TX_PCS              XFIPCS_TX_PCS
`define XFIPCS_TOPLEVELNAME_TX_LPI_FSM          XFIPCS_TX_LPI_FSM
`define XFIPCS_TOPLEVELNAME_TX_TPG              XFIPCS_TX_TPG

//-----------------------------------------------------------------------------
// 2. SDR vs DDR operation.
// The next define makes the XGMII data buses TXD and RXD 32 bits wide, and
// makes the XGMII control buses TXC and RXC 4 bits wide, and makes all four synchronous to both edges of
// XGMII_CLK. This is the IEEE specification as defined in IEEE 802.3ae-2002 Clause 46.
// If left undefined the core is assumed to be running in SDR mode.
//`define XFIPCS_TOPLEVELNAME_DDR

//-----------------------------------------------------------------------------
// 3. WIS Mode.
// If enabled, makes the core a WAN XFI PCS, conforming to the right-hand side
// of the Ethernet Stack Diagram in IEEE 802.3ae-2002 Figure 49-1 and connecting
// at the PMA interface to a WIS device of the customers choosing. This conforms
// to the WIS descriptions in IEEE 802.3ae-2002 Clause 49.
// If left undefined the core will be configured as a LAN XFI PCS.
//`define XFIPCS_TOPLEVELNAME_WIS_ENABLED

//-----------------------------------------------------------------------------
// 4. Alternate encode mode.
//`define XFIPCS_TOPLEVELNAME_ALTERNATE_ENCODE_INPUT

//-----------------------------------------------------------------------------
// 5. Default timing parameters for the HSS QUIET and REFRESH signals.
// These values define the behavior of the HSS QUIET and REFRESH signals as
// the TX and RX flow through the various LPI states.
// See section 5.1 in the databook for more details.

// The TX values assume a 299.52Mhz PMA_TX_CLK clock in WIS mode
// and a 322.265625Mhz clock otherwise.
`ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
 `define XFIPCS_TX_HSS_T1_VALUE_DEFAULT 11'h0A4  // 550ns
 `define XFIPCS_TX_HSS_T2_VALUE_DEFAULT 16'h00A4 // 550ns
 `define XFIPCS_TX_HSS_T3_VALUE_DEFAULT 16'h012B // 1us
`else
 `define XFIPCS_TX_HSS_T1_VALUE_DEFAULT 11'h0B1 // 550ns
 `define XFIPCS_TX_HSS_T2_VALUE_DEFAULT 16'h00B1 // 550ns
 `define XFIPCS_TX_HSS_T3_VALUE_DEFAULT 16'h0142 // 1us
`endif

// The RX values are given in cycles and assume a 156.25Mhz XGMII_CLK.
`define XFIPCS_RX_HSS_T1_VALUE_DEFAULT 16'hF424 // 400us
`define XFIPCS_RX_HSS_T3_VALUE_DEFAULT 16'h0092 // 1us
`define XFIPCS_RX_HSS_T6_VALUE_DEFAULT 16'h021C // 3.46us

//-----------------------------------------------------------------------------
// 6. Timer specifications as defined in the 802.3-az addendum
// NOTE: These values are specified in the IEEE 802.3-az specification
// and should not be altered beyond what is specified.
// Doing so can produce undesirable results.

// The following timer max values are given as clock cycles and
// assume a 156.25Mhz XGMII_CLK. The relative times are defined
// in table 49-3 of the IEEE 802.3az spec.
// <IEEE specified time> * clock_rate = value
`define XFIPCS_RX_TQ_TIMER_MAX        19'h7270E  // Tqr  = 3ms
`define XFIPCS_RX_WF_TIMER_MAX        21'h17D784 // Twtf = 10ms
`define XFIPCS_RX_TW_TIMER_MAX        12'h704    // Twr  = 11.5us

// The Twr timer defined here is only used when a FEC is being used.
// For this value we need to take into account the latency through
// the FEC. The resulting value should be the IEEE specified value
// plus this latency + 50ns.
// Worse case latency per the IEEE spec is 6144BT or around 641ns.
// 13.7us + 0.641us + .05us =
`define XFIPCS_RX_TW_TIMER_MAX_BYPASS 12'h8C8    // Twr  = 14.39us

// The following timer max values are given as clock cycles and
// assume a 299.52Mhz PMA_TX_CLK clock in WIS mode and a
// 322.265625Mhz clock otherwise. The relative times are defined
// in table 49-2 of the IEEE 802.3az spec.
// <IEEE specified time> * clock_rate = value
`ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
 `define XFIPCS_TX_TS_TIMER_MAX 11'h5D8   // Tsl = 5us
 `define XFIPCS_TX_TQ_TIMER_MAX 20'h7FF7F // Tql = 1.75ms
 `define XFIPCS_TX_TW_TIMER_MAX 12'hCDD   // Tul = 11us
 `define XFIPCS_ONE_US_TIMER_MAX 9'h166   // 1.2us
`else
 `define XFIPCS_TX_TS_TIMER_MAX 11'h64B   // Tsl = 5us
 `define XFIPCS_TX_TQ_TIMER_MAX 20'h89AFB // Tql = 1.75ms
 `define XFIPCS_TX_TW_TIMER_MAX 12'hDD7   // Tul = 11us
 `define XFIPCS_ONE_US_TIMER_MAX 9'h181   // 1.2us
`endif

// This defines the minimum Tql that the attached Link Partner can have, and
// is defined in the 802.3az spec to be 1.7ms
// Altering this value will alter the HSS RXxQUIET/RXxREFRESH timing relationships.
// See section 5.1 in the core databook for more information.
// The value is given in 156.25Mhz XGMII_CLK cycles and is calculated as follows:
// Tql * clock_rate = value
// So in this case:
// 1.7ms * 156.25M = 256.625k = 0x40D99
`define XFIPCS_LP_TX_TQL_MIN 19'h40D99 // Tql = 1.7ms

//-------------------------------------------------------------------
// DO NOT EDIT BELOW THIS LINE
//-------------------------------------------------------------------
// The following code is used to support the choices selected above.
// If modified by the user, the results may be unpredictable.
//-------------------------------------------------------------------

//`define XFIPCS_TOPLEVELNAME_WAM_ON
//`define XFIPCS_TOPLEVELNAME_SHORT_BER_DELAY
