# project depedent section to be modified by user
SRCFILE	= ~/compsyn_ips/pcie/src/verilog/filelist.v
TOPMOD = PCIEXP_TX
DCINCPATH = ~/compsyn_ips/pcie/src/verilog
#INPUT = -Input TXDATA -Input TXDATAK  -Input RST_BeaconEnable_R0 -Input CNTL_RESETN_P0 -Input CNTL_Loopback_P0 -Input CNTL_TXEnable_P0 -Input RX_LoopbackData_P2 -Input TXCOMPLIANCE -Input TXELECIDLE
INPUT = -Input TXDATA -Input TXDATAK  -Input CNTL_TXEnable_P0 -Input RX_LoopbackData_P2 -Input TXCOMPLIANCE 
#OUTPUT = -Output HSS_TXD -Output HSS_TXELECIDLE -Output HSS_TXBEACONCMD
OUTPUT = -Output HSS_TXD 

include ../../../vp/scr/Makefile.in
