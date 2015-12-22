# $^ all depend files
# #< first depend file
# $@ target file
OCAMLC	= ocamlopt
OBJS	= proc_inc.cmx  main.cmx


all : step1_noinc.exe

step1_noinc.exe : $(OBJS)
	$(OCAMLC) unix.cmxa $^ -o $@ 

%.cmx: %.ml
	$(OCAMLC) -c $< 
	
proc_inc.ml : proc_inc.mll
	ocamllex -o $@ $<

clean : 
	rm -f  *.cmo *.cmx *.cmi proc_inc.ml a.out proc_inc proc_inc.exe step1_noinc step1_noinc.exe *.bak *~ *.o
