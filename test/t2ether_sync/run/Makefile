# project depedent section to be modified by user
SRCFILE	= ../src/t2src/filelist.v
TOPMOD = pcs_tx_dpath
DCINCPATH = ../src/t2src
INPUT = -Input txd -Input tx_enc_ctrl_sel 
OUTPUT = -Output tx_10bdata 
RESET_CONDITION = "reset_tx==1'b1"

DECSRCFILE	= ../src/t2src/filelist_dec.v
DECTOPMOD = pcs_decoder

include ../../../vp/scr/Makefile.in
