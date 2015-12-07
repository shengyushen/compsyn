# $^ all depende files
# #< first depend file
# $@ tarhet file

# search files in these dirs
#VPATH = ../share/:$(MINISATDIR)

OBJS	= lex.yy.o tritree.o treeparser.o treelex.o
GPP_OPT = -O3   -Wno-unused-result
GPP = g++
GCC = gcc

all : tritree.exe

tritree.exe :  $(OBJS) 
	$(GPP)     \
		$(GPP_OPT) \
		-o $@ \
		$(OBJS) 


%.o: %.cpp
	$(GPP) $(GPP_OPT) -c $< 

treelex.c : treelex.lex 
	flex -o $@ $<

treelex.o : treelex.c
	$(GCC) $< -c -o $@

treeparser.c : treeparser.y
	bison -o $@ $<

treeparser.o : treeparser.c
	$(GCC) $< -c -o $@

.PHONY : clean

clean : 
	rm -f *.o *.exe lex.yy.*
