# project depedent section to be modified by user
SRCFILE	= ../src/verilog/filelist.v
TOPMOD = PCIEXP_TX
DCINCPATH = ../src/verilog
INPUT = -Input TXDATA -Input TXDATAK -Input CNTL_TXEnable_P0  
OUTPUT = -Output HSS_TXD -Output HSS_TXBEACONCMD -Output HSS_TXELECIDLE
RESET_CONDITION = "CNTL_RESETN_P0==1'b0"

DECSRCFILE = ../src/verilog/PCIEXP_108DEC.v
DECTOPMOD = PCIEXP_108DEC

include ../../../vp/scr/Makefile.in
