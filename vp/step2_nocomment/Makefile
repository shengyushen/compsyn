OCAMLC	= ocamlopt 
OBJS	= preproc.cmx  main.cmx


all : step2_nocomment.exe

step2_nocomment.exe : $(OBJS)
	$(OCAMLC) unix.cmxa $(OBJS) -o $@ 

%.cmx: %.ml
	$(OCAMLC) -c $< 
	
	
preproc.ml : preproc.mll
	ocamllex -o preproc.ml preproc.mll
	$(OCAMLC) -c preproc.ml  

clean : 
	rm -f *.o *.cmo *.cmx *.cmi preproc.ml a.out preproc preproc.exe step2_nocomment step2_nocomment.exe *.bak *~
