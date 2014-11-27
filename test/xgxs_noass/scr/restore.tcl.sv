# SimVision Command Script (Sat Jan 10 21:20:34 CST 2009)
#
# Version 05.50.p004
#
# You can restore this configuration with:
#
# ncverilog -f ../xgxs/xgxs.f +tcl+restore.tcl
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
	simulator "ncverilog -f ../xgxs/xgxs.f -input restore.tcl"
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
    -scope tb \
    -showassertions 0 \
    -showfibers 0 \
    -showinputs 0 \
    -showlive 0 \
    -showoutputs 0
browser yview see tb
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1010x600+644+264}] != ""} {
    window geometry "Waveform 1" 1010x600+644+264
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
cursor set -using TimeA -time 87,153,000ps
waveform baseline set -time 0

set id [waveform add -signals [list {tb.encode_data_reg[7:0]} \
	tb.konstant_reg \
	{tb.edc[9:0]} \
	{tb.decode_data_res[7:0]} \
	tb.konstant_res \
	{tb.decode_data_res_gen[7:0]} \
	tb.konstant_res_gen \
	tb.correct ]]

waveform xview limits 87129170ps 87176830ps

#
# Source Browser windows
#
if {[catch {window new SrcBrowser -name "Source Browser 1" -geometry 700x500+391+524}] != ""} {
    window geometry "Source Browser 1" 700x500+391+524
}
window target "Source Browser 1" on
srcbrowser using {Source Browser 1}
srcbrowser set \
    -primarycursor TimeA \
    -units ps \
    -radix default \
    -showstrength 1 \
    -showcallstack 0 \
    -displayvalues 0

srcbrowser open -scope tb

srcbrowser sidebar visibility partial
