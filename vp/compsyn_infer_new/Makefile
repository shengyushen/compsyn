MINISATDIR=../../other/MiniSat-ocaml-0.2.v1.14_simproof/MiniSat/src
OCAMLC	= ocamlopt
OCAMLC_OPT = -p str.cmxa unix.cmxa ../../other/caddie/libcaddie.cmxa -I /usr/local/lib  -I ../../other/caddie/
OBJS	=  typedef.cmx misc.cmx intlist.cmx dumpsat.cmx interp.cmx very.cmx parser.cmx elabmod.cmx rtl.cmx main.cmx 
CUDD_DIR = ../../other/cudd
GPP_OPT = -O6  -I /usr/local/lib/ocaml -I /usr/local/lib/ocaml/caml -I /usr/lib/ocaml -I /usr/lib/ocaml/caml -I $(MINISATDIR)


all : compsyn_infer_multidec_not_charfirst_nowall_cnt.exe

compsyn_infer_multidec_not_charfirst_nowall_cnt.exe : File.o Proof.o Solver.o MiniSATcommondef.cmx MiniSATWrap.o MiniSAT.cmi MiniSAT.cmx $(OBJS) 
	$(OCAMLC)     \
		-cclib -lstdc++ -cclib -lasmrun -cc g++ \
		-o $@ \
		str.cmxa unix.cmxa \
		../../other/caddie/libcaddie.cmxa ../../other/caddie/caddie.o \
		MiniSATWrap.o File.o Proof.o Solver.o  MiniSAT.cmx \
		../../other/cudd/cudd/libcudd.a \
		../../other/cudd/dddmp/libdddmp.a \
		../../other/cudd/epd/libepd.a \
		../../other/cudd/mtr/libmtr.a \
		../../other/cudd/util/libutil.a \
		../../other/cudd/st/libst.a \
		$(OBJS) 

Solver.o: $(MINISATDIR)/Solver.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/Solver.C

Proof.o: $(MINISATDIR)/Proof.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/Proof.C

File.o: $(MINISATDIR)/Proof.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/File.C

MiniSATWrap.o: ../share/MiniSATWrap.C
	g++ $(GPP_OPT) -c  $<

MiniSATcommondef.cmx : ../share/MiniSATcommondef.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 


MiniSAT.cmx: ../share/MiniSAT.ml MiniSAT.cmi
	ocamlopt -c ../share/MiniSAT.ml

MiniSAT.cmi: ../share/MiniSAT.mli
	ocamlopt -c $<

typdef.cmx : ../share/typedef.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 
	
misc.cmx : ../share/misc.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 

interp.cmx : ../share/interp.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 

dumpsat.cmx : ../share/dumpsat.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 

intlist.cmx : ../share/intlist.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 
	$(OCAMLC) ${OCAMLC_OPT} -c $< 
	
	
very.ml : very.mll parser.mly typedef.ml
	$(OCAMLC) ${OCAMLC_OPT} -c typedef.ml
	ocamlyacc -v -b parser parser.mly
	$(OCAMLC) ${OCAMLC_OPT} -c parser.mli
	$(OCAMLC) ${OCAMLC_OPT} -c parser.ml  
	ocamllex -o very.ml very.mll
	$(OCAMLC) ${OCAMLC_OPT} -c very.ml  

parser.ml: parser.mly typedef.ml
	$(OCAMLC) ${OCAMLC_OPT} -c typedef.ml
	ocamlyacc -v -b parser parser.mly
	$(OCAMLC) ${OCAMLC_OPT} -c parser.mli
	$(OCAMLC) ${OCAMLC_OPT} -c parser.ml  


%.cmx: %.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 




clean : 
	rm -f  *.cmo *.a *.cmx *.cmxa *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe compsyn compsyn_infer_multidec_not_charfirst_nowall_cnt compsyn.exe compsyn_infer_multidec_not_charfirst_nowall_cnt.exe *.o

