WM=gtk2

COMPILE = gcc -c -v -g
COMPILEPAS = fpc
COMPILEMOC = fpc -S2cghi -CX -O1 -TLinux -XX -vewnhi -l -k-L-dLCL -dLCL$(WM)
LINK = gcc -v

EMCDIR = /home/gtom/emc2-2.4.1
LAZDIR = /usr/lib/lazarus/0.9.30.4

INCLUDES = -I$(EMCDIR)/include
INCLUDES += -I$(EMCDIR)/src/emc/nml_intf
INCLUDES += -I$(EMCDIR)/src/emc/rs274ngc

LCL = -Fu.
LCL += -Fu../src
LCL += -Fu./lib
LCL += -Fu../pkg
LCL += -Fu../pkg/lib/i386-linux
LCL += -Fu$(LAZDIR)/lcl/units/i386-linux
LCL += -Fu$(LAZDIR)/lcl/units/i386-linux/$(WM)
LCL += -Fu$(LAZDIR)/components/custom
LCL += -Fu$(LAZDIR)/components/opengl
LCL += -Fu$(LAZDIR)/packager/units/i386-linux

emcpas.o: emcpas.cc
	$(COMPILE) $(INCLUDES) -o./lib/emcpas.o -UDSOHANDLE emcpas.cc

simcanon.o: simcanon.cc
	$(COMPILE) $(INCLUDES) -o./lib/simcanon.o -DVER_24 simcanon.cc

mocca.o: ../src/mocca.lpr
	$(COMPILEMOC) -k-L$(EMCDIR)/lib $(LCL) -dVER_24 -Fl./lib -FU./lib -o./mocca2.4 ../src/mocca.lpr
	cp ./mocca2.4 $(EMCDIR)/bin/mocca
	
clean:
	rm ./lib/*

all: simcanon.o emcpas.o mocca.o


          

