# SimVision Command Script (Fri Dec 26 20:10:12 CST 2008)
#
# Version 05.50.p004
#
# You can restore this configuration with:
#
# ncverilog ../scrambler/fl_scrambler.v +access+rwc +tcl+../scrambler/scrambler.tcl +gui +tcl+restore.tcl
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
	simulator "ncverilog ../scrambler/fl_scrambler.v +access+rwc +tcl+../scrambler/scrambler.tcl +gui -input restore.tcl"
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
    -scope tb_scramble
browser yview see tb_scramble
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 974x600+498+67}] != ""} {
    window geometry "Waveform 1" 974x600+498+67
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
cursor set -using TimeA -time 950ns
waveform baseline set -time 0

set id [waveform add -signals [list tb_scramble.correct \
	{tb_scramble.din[63:0]} \
	{tb_scramble.dout[63:0]} \
	tb_scramble.rgen ]]

waveform xview limits 0 1024ns
