OBJS = main.o 
GPP = g++
TCLOPT = -I/usr/include/tcl8.6 -L/usr/lib/x86_64-linux-gnu -ltcl8.6
GPPOPT = -std=gnu++11 $(TCLOPT)

main.exe : $(OBJS)
	$(GPP)  $^ -o $@  $(GPPOPT)

%.o : %.cpp
	$(GPP) $(GPPOPT) -c $<

depend :
	$(GPP) -E -MM *.cpp > .depend

sinclude .depend

clean : 
	rm -f *.exe *.o */*.exe */*.o

