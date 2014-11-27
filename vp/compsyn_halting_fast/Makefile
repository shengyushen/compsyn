MINISATDIR=../../other/MiniSat-ocaml-0.2.v1.14/MiniSat/src
OCAMLC	= ocamlopt
OCAMLC_OPT = str.cmxa unix.cmxa  -I /usr/local/lib  
OBJS	=  misc.cmx typedef.cmx dependent.cmx statement.cmx expression.cmx print_v.cmx  misc2.cmx very.cmx  parser.cmx circuit_obj.cmx elabmod.cmx rtl.cmx main.cmx 
CUDD_DIR = ../../other/cudd
GPP_OPT = -O3  -I /usr/local/lib/ocaml -I /usr/local/lib/ocaml/caml -I /usr/lib/ocaml -I /usr/lib/ocaml/caml -I $(MINISATDIR)

all : compsyn_halting_fast.exe

compsyn_halting_fast.exe : File.o Proof.o Solver.o MiniSATWrap.o MiniSAT.cmi MiniSAT.cmx $(OBJS) 
	$(OCAMLC)     \
		-cclib -lstdc++ -cclib -lasmrun -cc g++ \
		-o $@ \
		str.cmxa unix.cmxa MiniSATWrap.o File.o Proof.o Solver.o  MiniSAT.cmx   $(OBJS) 

Solver.o: $(MINISATDIR)/Solver.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/Solver.C

Proof.o: $(MINISATDIR)/Proof.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/Proof.C

File.o: $(MINISATDIR)/Proof.C
	g++ $(GPP_OPT) -c $(MINISATDIR)/File.C

MiniSATWrap.o: MiniSATWrap.C
	g++ $(GPP_OPT) -c  MiniSATWrap.C

MiniSAT.cmx: MiniSAT.ml MiniSAT.cmi
	ocamlopt -c MiniSAT.ml

MiniSAT.cmi: MiniSAT.mli
	ocamlopt -c MiniSAT.mli



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
	rm -f  *.cmo *.a *.cmx *.cmxa *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe compsyn* *.o *.exe


