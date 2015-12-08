# $^ all depend files
# #< first depend file
# $@ tarhet file

# search files in these dirs
#VPATH = ../share/:$(MINISATDIR)

#OBJS	= parse.o lex.o vlist.o  t3.o  main.o

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o, $(SRCS))

GPP_OPT = -O3 
GPP = g++
GCC_OPT = -O3
GCC = gcc
FLEX = flex
BISON = bison

all : t3.exe

t3.exe :  $(OBJS) 
	$(GCC)     \
		$(GCC_OPT) \
		-o $@ \
		$(OBJS) 

%.o: %.c
	$(GCC) $(GCC_OPT) -c $< 

lex.c : lex.l parse.h
	$(FLEX) -CF -o $@ $<

parse.c : parse.y
	$(BISON) --defines=parse.h -o $@ $<

depend:    
	gcc -E -MM *.c > .depend

sinclude .depend

.PHONY : clean

clean : 
	rm -f *.o *.exe lex.yy.* gmon.out
