# $^ all depend files
# #< first depend file
# $@ target file
OCAMLC	= ocamlopt 
OBJS	= preproc.cmx  main.cmx


all : step2_nocomment.exe

step2_nocomment.exe : $(OBJS)
	$(OCAMLC) unix.cmxa $^ -o $@ 

%.cmx: %.ml
	$(OCAMLC) -c $< 
	
	
preproc.ml : preproc.mll
	ocamllex -o $@ $<

clean : 
	rm -f *.o *.cmo *.cmx *.cmi preproc.ml a.out preproc preproc.exe step2_nocomment step2_nocomment.exe *.bak *~
