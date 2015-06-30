# project depedent section to be modified by user
SRCFILE	= /home/syshen/compsyn_ips/pcie_sync/src/verilog/filelist.v
TOPMOD = PCIEXP_TX
DCINCPATH = /home/syshen/compsyn_ips/pcie_sync/src/verilog
INPUT = -Input TXDATA -Input TXDATAK -Input CNTL_TXEnable_P0  
#OUTPUT = -Output HSS_TXD -Output HSS_TXBEACONCMD -Output HSS_TXELECIDLE
OUTPUT = -Output HSS_TXD 
RESET_CONDITION = "CNTL_RESETN_P0==1'b0"

DECSRCFILE = /home/syshen/compsyn_ips/pcie_sync/src/verilog/PCIEXP_108DEC.v
DECTOPMOD = PCIEXP_108DEC

include ../../../vp/scr/Makefile.in
