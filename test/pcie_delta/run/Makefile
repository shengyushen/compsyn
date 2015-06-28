# project depedent section to be modified by user
SRCDIR = /home/syshen/compsyn_ips/pcie_delta/src/verilog
SRCFILE	= $(SRCDIR)/filelist.v
TOPMOD = PCIEXP_TX
DCINCPATH = $(SRCDIR)
INPUT = -Input TXDATA -Input TXDATAK -Input CNTL_TXEnable_P0  
OUTPUT = -Output HSS_TXD -Output HSS_TXBEACONCMD -Output HSS_TXELECIDLE
RESET_CONDITION = "CNTL_RESETN_P0==1'b0"

DECSRCFILE = $(SRCDIR)/PCIEXP_108DEC.v
DECTOPMOD = PCIEXP_108DEC

include ../../../vp/scr/Makefile.in
