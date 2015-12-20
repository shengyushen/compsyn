# $^ all depend files
# #< first depend file
# $@ tarhet file

# MINISATDIR=../../other/MiniSat-ocaml-0.2.v1.14_simproof/MiniSat/src

# search files in these dirs
# VPATH = ../share/:$(MINISATDIR)

OCAMLC	= ocamlopt
#OCAMLC_OPT = -g str.cmxa unix.cmxa ../../other/caddie/libcaddie.cmxa -I /usr/local/lib  -I ../../other/caddie/ -I ../share
OCAMLC_OPT = -g str.cmxa unix.cmxa -I /usr/local/lib  -I ../../other/caddie/ 
OBJS	= typedef.cmx  very.cmx parser.cmx misc.cmx  print_v.cmx main.cmx 


all : checker.exe

checker.exe :  $(OBJS) 
	$(OCAMLC)     \
		$(OCAMLC_OPT) \
		-cclib -lstdc++ -cclib -lasmrun -cc g++ \
		-o $@ \
		$(OBJS) 
	otags -r *.ml 


parser.ml: parser.mly typedef.cmx
	ocamlyacc -v -b parser $<
	$(OCAMLC) $(OCAMLC_OPT) -c parser.mli


very.ml : very.mll typedef.cmx parser.cmx
	ocamllex -o very.ml $<

%.cmx: %.ml
	$(OCAMLC) $(OCAMLC_OPT) -c $<  

depend : 
	ocamldep *.ml > .depend

sinclude .depend

.PHONY : clean

clean : 
	rm -f  *.cmo *.a *.cmx *.cmxa *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe compsyn checker compsyn.exe checker.exe *.o
	rm -f ../share/*.cmx ../share/*.o ../share/*.cmi

