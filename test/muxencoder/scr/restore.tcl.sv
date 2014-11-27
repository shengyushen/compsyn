# SimVision Command Script (Fri Apr 24 22:38:18 CST 2009)
#
# Version 05.50.p004
#
# You can restore this configuration with:
#
# ncverilog -f ../scr/t2ether.f +tcl+restore.tcl
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
	simulator "ncverilog -f ../scr/t2ether.f -input restore.tcl"
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
if {[catch {window new WatchList -name "Design Browser 1" -geometry 700x500+5+49}] != ""} {
    window geometry "Design Browser 1" 700x500+5+49
}
window target "Design Browser 1" on
browser using {Design Browser 1}
browser set \
    -scope tb
browser yview see tb
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1010x600+10+73}] != ""} {
    window geometry "Waveform 1" 1010x600+10+73
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar select designbrowser
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ps \
    -valuewidth 75
cursor set -using TimeA -time 198,147,000ps
waveform baseline set -time 0

set id [waveform add -signals [list tb.correct \
	{tb.decode_data_res_gen[7:0]} \
	{tb.encode_data_reg[7:0]} ]]

waveform xview limits 198135130ps 198174670ps
