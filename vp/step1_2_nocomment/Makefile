OCAMLC	= ocamlopt 
OBJS	= preproc.cmx  main.cmx


all : vp_step1_2.exe

vp_step1_2.exe : $(OBJS)
	$(OCAMLC) unix.cmxa $(OBJS) -o $@ 

%.cmx: %.ml
	$(OCAMLC) -c $< 
	
	
preproc.ml : preproc.mll
	ocamllex -o preproc.ml preproc.mll
	$(OCAMLC) -c preproc.ml  

clean : 
	rm -f *.o *.cmo *.cmx *.cmi preproc.ml a.out preproc preproc.exe vp_step1_2 vp_step1_2.exe *.bak *~
