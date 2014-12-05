MINISATDIR=../../other/MiniSat-ocaml-0.2.v1.14_simproof/MiniSat/src
OCAMLC	= ocamlopt -g 
OCAMLC_OPT = str.cmxa unix.cmxa ../../other/caddie/libcaddie.cmxa -I /usr/local/lib  -I ../../other/caddie/
OBJS	=  MultiMiniSAT.cmx intlist.cmx typedef.cmx misc.cmx bddssy.cmx clauseman.cmx dumpsat.cmx aig.cmx print_v.cmx statement.cmx  interp.cmx very.cmx  parser.cmx circuit_obj.cmx elabmod.cmx main.cmx 
CUDD_DIR = ../../other/cudd
GPP_OPT =  -g -O6  -I /usr/local/lib/ocaml -I /usr/local/lib/ocaml/caml -I /usr/lib/ocaml -I /usr/lib/ocaml/caml -I $(MINISATDIR)
TAGPROG = otags
CTAGS   = ctags

all : compsyn_pdr.exe

compsyn_pdr.exe: File.o Proof.o Solver.o MultiMiniSATWrap.o $(OBJS) 
	$(OCAMLC)     \
		-cclib -lstdc++ -cclib -lasmrun -cc g++ \
		-o $@ \
		str.cmxa unix.cmxa \
		../../other/caddie/libcaddie.cmxa ../../other/caddie/caddie.o \
		MultiMiniSATWrap.o File.o Proof.o Solver.o \
		../../other/cudd/cudd/libcudd.a \
		../../other/cudd/dddmp/libdddmp.a \
		../../other/cudd/epd/libepd.a \
		../../other/cudd/mtr/libmtr.a \
		../../other/cudd/util/libutil.a \
		../../other/cudd/st/libst.a \
		$(OBJS) 
	$(TAGPROG) -vi *.ml
	$(CTAGS) --append=yes $(MINISATDIR)/Solver.C $(MINISATDIR)/Proof.C  $(MINISATDIR)/File.C MultiMiniSATWrap.C 

Solver.o: $(MINISATDIR)/Solver.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/Solver.C

Proof.o: $(MINISATDIR)/Proof.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/Proof.C

File.o: $(MINISATDIR)/File.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/File.C

MultiMiniSATWrap.o: MultiMiniSATWrap.C
	g++ $(GPP_OPT) -c  MultiMiniSATWrap.C

%.cmx: %.ml
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


clean : 
	rm -f  *.cmo *.a *.cmx *.cmxa *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe compsyn_pdr  compsyn.exe compsyn_infer_multidec_not_charfirst_nowall_cnt.exe *.o  *.exe  tags TAGS *.session *.wv log
