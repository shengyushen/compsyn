# $^ all depend files
# #< first depend file
# $@ target file

# MINISATDIR=../../other/MiniSat-ocaml-0.2.v1.14_simproof/MiniSat/src
# search files in these dirs
# VPATH = ../share/:$(MINISATDIR)
#OCAMLC_OPT = -g str.cmxa unix.cmxa ../../other/caddie/libcaddie.cmxa -I /usr/local/lib  -I ../../other/caddie/ -I ../share



OCAMLC = ocamlc
OCAMLOPT = ocamlopt
OCAMLDEP = ocamldep
OCAMLFLAGS = -g str.cmxa unix.cmxa -I /usr/local/lib  -I ../../other/caddie/ 
# add other options for ocamlc here
OCAMLFLAGS_LINK = -cclib -lstdc++ -cclib -lasmrun -cc g++ 

OBJS	= verilogast.cmx parser.cmx  very.cmx misc.cmx  print_v.cmx main.cmx 

all : checker.exe

checker.exe :  $(OBJS) 
	$(OCAMLOPT)     \
		$(OCAMLFLAGS) \
		$(OCAMLFLAGS_LINK) \
		-o $@ \
		$(OBJS) 
	otags -r *.ml 

%.cmx: %.ml
	$(OCAMLOPT) $(OCAMLFLAGS) -c $<

parser.ml: parser.mly verilogast.cmx
	ocamlyacc -v -b parser $<
	$(OCAMLOPT) parser.mli

very.ml : very.mll verilogast.cmx parser.cmx
	ocamllex -o $@ $<

depend : 
	$(OCAMLDEP) -native *.ml > .depend

sinclude .depend

.PHONY : clean

clean : 
	rm -f  *.cmo *.a *.cmx *.cmxa *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe compsyn checker compsyn.exe checker.exe *.o
	rm -f ../share/*.cmx ../share/*.o ../share/*.cmi

