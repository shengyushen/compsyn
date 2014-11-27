# SimVision Command Script (Mon Jun 14 17:33:48 CST 2010)
#
# Version 05.50.p004
#
# You can restore this configuration with:
#
# ncsim worklib.tb:v -input ../scr/restore.tcl -input ../scr/start.tcl -gui -64BIT -input restore.tcl
#

#
# preferences
#
preferences set toolbar-Windows-SrcBrowser {
  usual
  hide icheck
}
preferences set toolbar-Windows-WaveWindow {
  usual
  hide icheck
  position -pos 3
}
preferences set toolbar-Windows-WatchList {
  usual
  hide icheck
}

#
# Simulator
#

database require simulator -hints {
	simulator "ncsim worklib.tb:v -input ../scr/restore.tcl -input ../scr/start.tcl -gui -64BIT -input restore.tcl"
}

#
# mmaps
#
mmap new -reuse -name {Boolean as Logic} -contents {
{%c=FALSE -edgepriority 1 -shape low}
{%c=TRUE -edgepriority 1 -shape high}
}
mmap new -reuse -name {Example Map} -contents {
{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}
}

#
# Design Browser windows
#
if {[catch {window new WatchList -name "Design Browser 1" -geometry 700x500+698+254}] != ""} {
    window geometry "Design Browser 1" 700x500+698+254
}
window target "Design Browser 1" on
browser using {Design Browser 1}
browser set \
    -scope testbench_pcie.inst_tx
browser yview see testbench_pcie.inst_tx
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1262x600+507+199}] != ""} {
    window geometry "Waveform 1" 1262x600+507+199
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar select designbrowser
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
cursor set -using TimeA -time 220,600,000ps
waveform baseline set -time 0

set id [waveform add -signals [list testbench_pcie.inst_tx.PCLK250 \
	testbench_pcie.inst_tx.CNTL_RESETN_P0 \
	{testbench_pcie.inst_tx.TXDATA[7:0]} \
	testbench_pcie.inst_tx.TXDATAK \
	testbench_pcie.inst_rx.PCLK250 \
	testbench_pcie.inst_rx.RESETN \
	testbench_pcie.inst_rx.HSS_RXDCLK \
	{testbench_pcie.inst_rx.RXDATA[7:0]} \
	testbench_pcie.inst_rx.RXDATAK \
	{testbench_pcie.inst_rx.RXSTATUS[2:0]} \
	testbench_pcie.inst_tx.assertion_shengyushen \
	testbench_pcie.correct \
	{testbench_pcie.inst_rx_dualsyn.TXDATA[7:0]} \
	testbench_pcie.inst_rx_dualsyn.TXDATAK ]]

waveform xview limits 0 500000ns
