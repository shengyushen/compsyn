# $^ all depend files
# #< first depend file
# $@ target file
OCAMLC	= ocamlopt 
OCAMLC_OPT = -g str.cmxa unix.cmxa -I /usr/local/lib  -I ../../other/caddie/ 
OBJS	= preproc.cmx  main.cmx


all : step4_nodef.exe

step4_nodef.exe : $(OBJS)
	$(OCAMLC) $(OCAMLC_OPT) $(OBJS) -o $@ 

%.cmx: %.ml
	$(OCAMLC) $(OCAMLC_OPT) -c $< 
	
	
preproc.ml : preproc.mll
	ocamllex -o $@ $<

clean : 
	rm -f *.o *.cmo *.cmx *.cmi preproc.ml a.out preproc preproc.exe step4_nodef step4_nodef.exe *.bak *~
