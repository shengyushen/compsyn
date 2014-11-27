#CC = CC
#CC = g++-3.2
CC=g++ -Wall -O3
#CC=g++ -O3 
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

HEADERS = zchaff_base.h zchaff_clsgen.h zchaff_header.h zchaff_version.h zchaff_dbase.h zchaff_solver.h 

LIB_SRCS =  zchaff_utils.cpp \
	    zchaff_solver.cpp\
	    zchaff_base.cpp \
	    zchaff_dbase.cpp \
	    zchaff_c_wrapper.cpp \
	    zchaff_cpp_wrapper.cpp 

LIB_OBJS = $(LIB_SRCS:.cpp=.o)


all:   libsat.a

$(LIB_OBJS): $(HEADERS) Makefile

zchaff_c_wrapper.cpp:	zchaff_wrapper.wrp
		sed 's/EXTERN/extern \"C\"/' zchaff_wrapper.wrp > zchaff_c_wrapper.cpp

zchaff_cpp_wrapper.cpp:	zchaff_wrapper.wrp
		sed 's/EXTERN//' zchaff_wrapper.wrp > zchaff_cpp_wrapper.cpp
SAT_C.h:
	sed 's/gid = 0/gid/' SAT.h > SAT_C.h

libsat.a:   $(LIB_OBJS)
	@rm -f libsat.a
	$(AR) cr libsat.a $(LIB_OBJS)
	$(RANLIB) libsat.a

.cpp.o:
	$(CC) $(CFLAGS) $(MFLAGS) -c $< 

clean:	
	rm -f *.o libsat.a nl_const *wrapper.cpp zminimal zcore zverify_bf zverify_df cnf_stats SAT_C.h

	 	  




