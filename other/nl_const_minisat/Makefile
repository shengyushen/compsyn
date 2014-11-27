#CC = CC
#CC = g++-3.2
CC=g++ -Wall -O3
# this is for debuging the resolving process 
#CC=g++ -Wall -O3 -DDEBUG_RESOLVE
#CC=g++ -O3 -Wall -m32
#CC=g++ -Wall -pg -O3
#CC=g++ -Wall -pg -O3
#CC=g++ -Wall -ggdb -O3
#CC=g++
#CFLAGS = -O
#CFLAGS = -Wall -g 
#CFLAGS = -O -g 
#CFLAGS = -O3 -pg 
#CFLAGS = -O3
#CFLAGS = -Wall -O3
#CFLAGS = -DNDEBUG -O3 

MFLAGS = 
#LINKFLAGS = --static

ifeq (solaris, $(OSTYPE))
  MFLAGS = -D_NEED_REDEFINE_RAND_MAX_
endif

RANLIB = ranlib
AR = ar

.SUFFIXES: .o .cpp 

SOLVER_SRCS = $(wildcard *.cpp)
SOLVER_OBJS = $(SOLVER_SRCS:.cpp=.o)

nl_const_minisat:   $(SOLVER_OBJS) 
	  $(CC) $(LINKFLAGS) $(CFLAGS) $(MFLAGS) $(SOLVER_OBJS) ../MiniSat114_enhance/libsat.a -o $@

.cpp.o:
	@echo Compiling: $<
	$(CC) $(CFLAGS) $(MFLAGS) -c $< 

clean:	
	rm -f *.o libsat.a nl_const* *wrapper.cpp zminimal zcore zverify_bf zverify_df cnf_stats SAT_C.h

all: nl_const_minisat
	 	  




