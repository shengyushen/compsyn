# project depedent section to be modified by user
SRCFILE	= ../src/XGXSPCS/XGXSSYNTH_ENC_8B10B.v
TOPMOD = XGXSSYNTH_ENC_8B10B
DCINCPATH = ../src/XGXSPCS
# bad_disp can not be uniquelly determined
# it is just flipped instantely to generate DC balanced output
# it is not used in upper lever of protocol 
#INPUT = -Input encode_data_in -Input konstant -Input bad_code -Input bad_disp
INPUT = -Input encode_data_in -Input konstant -Input bad_code
#INPUT = -Input encode_data_in -Input konstant -Input bad_disp
OUTPUT = -Output encode_data_out 


DECSRCFILE	= ../src/XGXSPCS/XGXSSYNTH_DEC_8B10B.v
DECTOPMOD = XGXSSYNTH_DEC_8B10B


include ../../../vp/scr/Makefile.in
