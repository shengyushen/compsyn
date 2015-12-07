# $^ all depende files
# #< first depend file
# $@ tarhet file

# search files in these dirs
#VPATH = ../share/:$(MINISATDIR)

OBJS	= tritree.o
GPP_OPT = -O3   -Wno-unused-result
GPP = g++

all : tritree.exe

tritree.exe :  $(OBJS) 
	$(GPP)     \
		$(GPP_OPT) \
		-o $@ \
		$(OBJS) 


%.o: %.cpp
	g++ $(GPP_OPT) -c $< 

.PHONY : clean

clean : 
	rm -f *.o *.exe
