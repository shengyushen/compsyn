# project depedent section to be modified by user
SRCFILE	= ../src/t2src/filelist.v
TOPMOD = pcs_tx_dpath
DCINCPATH = ../src/t2src
INPUT = -Input txd -Input tx_enc_ctrl_sel -Input tx_en -Input tx_er 
OUTPUT = -Output tx_10bdata -Output txd_eq_crs_ext -Output tx_er_d -Output tx_en_d -Output pos_disp_tx_p

DECSRCFILE	= ../src/t2src/filelist_dec.v
DECTOPMOD = pcs_decoder

include ../../../vp/scr/Makefile.in
