# project depedent section to be modified by user
SRCFILE	= /home/syshen/compsyn_ips/pcie_rel_pipe/src/verilog/filelist.v
TOPMOD = PCIEXP_TX
DCINCPATH = /home/syshen/compsyn_ips/pcie_rel_pipe/src/verilog
INPUT = -Input TXDATA -Input TXDATAK -Input CNTL_TXEnable_P0  
OUTPUT = -Output HSS_TXD  -Output HSS_TXELECIDLE
RESET_CONDITION = "CNTL_RESETN_P0==1'b0"

DECSRCFILE = /home/syshen/compsyn_ips/pcie_rel_pipe/src/verilog/PCIEXP_108DEC.v
DECTOPMOD = PCIEXP_108DEC

include ../../../vp/scr/Makefile.in
