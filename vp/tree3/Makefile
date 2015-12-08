# $^ all depende files
# #< first depend file
# $@ tarhet file

# search files in these dirs
#VPATH = ../share/:$(MINISATDIR)

OBJS	= parse.o lex.o  t3.o 
GPP_OPT = -O3 -g
GPP = g++
GCC_OPT = -O3 -g
GCC = gcc

all : t3.exe

t3.exe :  $(OBJS) 
	$(GCC)     \
		$(GCC_OPT) \
		-o $@ \
		$(OBJS) 


%.o: %.c
	$(GCC) $(GCC_OPT) -c $< 

lex.c : lex.l parse.h
	flex -o $@ $<

parse.c : parse.y
	bison --defines=parse.h -o $@ $<

.PHONY : clean

clean : 
	rm -f *.o *.exe lex.yy.* lex.c parse.c parse.h
