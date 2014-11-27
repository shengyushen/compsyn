ifndef BLASTHOME
BLASTHOME=$(shell pwd)/../blast/
export BLASTHOME
$(warning Warning: BLASTHOME environment variable is not set!)
$(warning Warning: *guessing* it should be $(BLASTHOME))
endif


# Configuration

include $(BLASTHOME)/config.make

C_CPP_LIB      = libcaddie-c-part
OCAML_LIB      = libcaddie
OCAML_TPL_EXE  = caddie

C_CPP_LIB_OBJ  = caddie
C_CPP_EXE_OBJ  = caddie
OCAML_LIB_OBJ  = caddieBdd
OCAML_EXE_OBJ  = caddieBdd

C_CPP_INCLUDES = -I ../  $(OCAML_C_CPP_INC) 
OCAML_INCLUDES =

C_CPP_LD_FLAGS = -L ../cudd/cudd -L ../cudd/dddmp -L ../cudd/epd -L ../cudd/mtr -L ../cudd/util -L ../cudd/st 
C_CPP_LD_LIBS  = -lcudd -ldddmp -lutil -lst -lmtr -lepd
OCAML_LD_LIBS  =


TODO           = $(OCAML_TPL_EXE).byte \
                 $(OCAML_LIB).cma $(OCAML_LIB).cmxa $(OCAML_LIB).a \
                 $(C_CPP_LIB).a


all:: $(TODO)

clean: default-clean

distclean: clean
	rm -f *.cmi $(TODO)


.PHONY : all clean distclean


# Implicit rules

include $(BLASTHOME)/rules.make


# Dependencies

caddieBdd.cmo: caddieBdd.cmi
