OCAMLC	= ocamlopt
OBJS	= proc_inc.cmx  main.cmx


all : vp_step1.exe

vp_step1.exe : $(OBJS)
	$(OCAMLC) unix.cmxa $(OBJS) -o $@ 

%.cmx: %.ml
	$(OCAMLC) -c $< 
	
	
proc_inc.ml : proc_inc.mll
	ocamllex -o proc_inc.ml proc_inc.mll
	$(OCAMLC) -c proc_inc.ml  

clean : 
	rm -f  *.cmo *.cmx *.cmi proc_inc.ml a.out proc_inc proc_inc.exe vp_step1 vp_step1.exe *.bak *~ *.o
