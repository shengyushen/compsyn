# $^ all depende files
# #< first depend file
# $@ tarhet file

MINISATDIR=../../other/MiniSat-ocaml-0.2.v1.14_simproof/MiniSat/src

# search files in these dirs
VPATH = ../share/:$(MINISATDIR)

OCAMLC	= ocamlopt
OCAMLC_OPT = str.cmxa unix.cmxa ../../other/caddie/libcaddie.cmxa -I /usr/local/lib  -I ../../other/caddie/ -I ../share
OBJS	= intlist.cmx typedef.cmx misc.cmx very.cmx parser.cmx print_v.cmx circuit_obj.cmx main.cmx 
GPP_OPT = -O6  -I /usr/local/lib/ocaml -I /usr/local/lib/ocaml/caml -I /usr/lib/ocaml -I /usr/lib/ocaml/caml -I $(MINISATDIR) -Wno-unused-result


all : lsi10k2blif.exe

lsi10k2blif.exe :  $(OBJS) 
	$(OCAMLC)     \
		$(OCAMLC_OPT) \
		-cclib -lstdc++ -cclib -lasmrun -cc g++ \
		-o $@ \
		../../other/caddie/caddie.o \
		../../other/cudd/cudd/libcudd.a \
		../../other/cudd/dddmp/libdddmp.a \
		../../other/cudd/epd/libepd.a \
		../../other/cudd/mtr/libmtr.a \
		../../other/cudd/util/libutil.a \
		../../other/cudd/st/libst.a \
		$(OBJS) 


very.ml : very.mll parser.cmx typedef.cmx
	ocamllex -o very.ml $<

parser.ml: parser.mly typedef.cmx
	ocamlyacc -v -b parser $<
	$(OCAMLC) $(OCAMLC_OPT) -c parser.mli


%.o: %.C
	g++ $(GPP_OPT) -c $< 

%.cmx: %.ml
	$(OCAMLC) $(OCAMLC_OPT) -c $<  

#%.cmi: %.mli
#	$(OCAMLC) $(OCAMLC_OPT) -c $<  

.PHONY : clean

clean : 
	rm -f  *.cmo *.a *.cmx *.cmxa *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe compsyn lsi10k2blif compsyn.exe lsi10k2blif.exe *.o
	rm -f ../share/*.cmx ../share/*.o ../share/*.cmi

