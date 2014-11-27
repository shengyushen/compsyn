SHELL        = /bin/sh



C_C          = gcc
CPP_C        = g++

# To make the foci stuff working under OS different from linux.
ifeq ($(OSTYPE), linux)
  C_CPP_OPT = -O3
else
  C_CPP_OPT = -O1
endif

ifdef DEBUG
  C_CPP_FLAGS  = $(C_CPP_OPT) -g
endif

C_LD         = $(C_C)
CPP_LD       = $(CPP_C)

C_YACC       = bison
C_LEX        = flex

AR           = ar
RANLIB       = ranlib

OCAML_C      = ocamlc
OCAML_OPT_C  = ocamlopt
OCAML_LD     = $(OCAML_C)
OCAML_OPT_LD = $(OCAML_OPT_C)
ifndef DEBUG
OCAML_C_FLAGS     = -dtypes
OCAML_OPT_C_FLAGS = -unsafe -noassert -dtypes
else
OCAML_C_FLAGS     = -g -dtypes
OCAML_OPT_C_FLAGS = -dtypes
endif
OCAML_MKTOP  = ocamlmktop
OCAML_CP     = ocamlcp
OCAML_DEP    = ocamldep
OCAML_LEX    = ocamllex
OCAML_YACC   = ocamlyacc

OCAML_C_CPP_INC = -I $(shell $(OCAML_C) -v | tail -1 | sed -e \
                             's/^Standard library directory: //')
