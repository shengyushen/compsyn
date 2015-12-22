# $^ all depend files
# #< first depend file
# $@ target file
OCAMLC	= ocamlopt 
OBJS	= preproc.cmx  main.cmx

all : step3_noprotected.exe

step3_noprotected.exe : $(OBJS)
	$(OCAMLC) unix.cmxa $(OBJS) -o $@ 

%.cmx: %.ml
	$(OCAMLC) -c $< 
	
	
preproc.ml : preproc.mll
	ocamllex -o $@ $<

clean : 
	rm -f *.o *.cmo *.cmx *.cmi preproc.ml a.out preproc preproc.exe step3_noprotected step3_noprotected.exe *.bak *~
