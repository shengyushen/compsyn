MINISATDIR=../MiniSat/src

all: lib solver

lib: MiniSAT.cmxa MiniSAT.cmi

solver: solver.cmx MiniSAT.cmxa
	ocamlopt -o solver MiniSAT.cmxa solver.cmx
	
MiniSAT.cmxa: File.o Proof.o Solver.o MiniSATWrap.o MiniSAT.cmx
	ocamlopt -o MiniSAT.cmxa -a  File.o Proof.o Solver.o MiniSATWrap.o MiniSAT.cmx  -cclib -lstdc++

Solver.o: $(MINISATDIR)/Solver.C
	g++ -c -I $(MINISATDIR) $(MINISATDIR)/Solver.C

Proof.o: $(MINISATDIR)/Proof.C
	g++ -c -I $(MINISATDIR) $(MINISATDIR)/Proof.C

File.o: $(MINISATDIR)/Proof.C
	g++ -c -I $(MINISATDIR) $(MINISATDIR)/File.C

MiniSATWrap.o: MiniSATWrap.C
	g++ -c -I /usr/local/lib/ocaml -I $(MINISATDIR) MiniSATWrap.C

MiniSAT.cmx: MiniSAT.ml MiniSAT.cmi
	ocamlopt -c MiniSAT.ml

MiniSAT.cmi: MiniSAT.mli
	ocamlopt -c MiniSAT.mli

solver.cmx: solver.ml MiniSAT.cmi
	ocamlopt -c solver.ml

clean:
	rm -f *.o *.cmo *.cma *.cmx *.cmxa *.cmi *~ solver
