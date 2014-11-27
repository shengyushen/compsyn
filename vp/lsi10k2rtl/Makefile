OCAMLC	= ocamlopt
OCAMLC_OPT = str.cmxa unix.cmxa  -I /usr/local/lib  
OBJS	= misc.cmx typedef.cmx dependent.cmx statement.cmx expression.cmx print_v.cmx  misc2.cmx very.cmx  parser.cmx circuit_obj.cmx elabmod.cmx rtl.cmx main.cmx 
CUDD_DIR = ../../other/cudd


all : lsi10k2rtl.exe

lsi10k2rtl.exe : $(OBJS)
	$(OCAMLC) ${OCAMLC_OPT} \
		$(OBJS)  -o $@ 

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
	rm -f  *.cmo *.cmx *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe lsi10k2rtl lsi10k2rtl.exe *.o
