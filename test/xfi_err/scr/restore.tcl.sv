# SimVision Command Script (Sat Apr 18 16:32:36 CST 2009)
#
# Version 05.50.p004
#
# You can restore this configuration with:
#
# ncverilog ../src/fl_xfi.v +tcl+../src/sim_xfi.tcl +gui +access+rwc +incdir+../src/XFIPCS -y ../../../std_ovl -y ../../../std_ovl/vlog95 +libext+.vlib +incdir+../../../std_ovl +tcl+restore.tcl
#

#
# preferences
#
preferences set toolbar-Windows-AssertionBrowser {
  usual
  hide icheck
}
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
	simulator "ncverilog ../src/fl_xfi.v +tcl+../src/sim_xfi.tcl +gui +access+rwc +incdir+../src/XFIPCS -y ../../../std_ovl -y ../../../std_ovl/vlog95 +libext+.vlib +incdir+../../../std_ovl -input restore.tcl"
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
if {[catch {window new WatchList -name "Design Browser 1" -geometry 700x500+0+25}] != ""} {
    window geometry "Design Browser 1" 700x500+0+25
}
window target "Design Browser 1" on
browser using {Design Browser 1}
browser set \
    -scope tb_xfi
browser yview see tb_xfi
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1010x600+237+143}] != ""} {
    window geometry "Waveform 1" 1010x600+237+143
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ps \
    -valuewidth 75
cursor set -using TimeA -time 6,760,000ps
cursor set -using TimeA -marching 1
waveform baseline set -time 0

set id [waveform add -signals [list tb_xfi.correct ]]

waveform xview limits 0 6760000ps
