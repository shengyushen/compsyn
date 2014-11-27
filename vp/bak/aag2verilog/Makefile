OCAMLC	= ocamlopt
OCAMLC_OPT = str.cmxa unix.cmxa  -I /usr/local/lib  
OBJS	= main.cmx 


all : aag2verilog.exe

aag2verilog.exe : $(OBJS)
	$(OCAMLC) ${OCAMLC_OPT} \
		$(OBJS)  -o $@ 

%.cmx: %.ml
	$(OCAMLC) ${OCAMLC_OPT} -c $< 
	
clean : 
	rm -f  *.cmo *.cmx *.cmi very.ml a.out *.bak *~ parser.ml parser.mli parser.output sdf main main.exe aag2verilog aag2verilog.exe *.o
