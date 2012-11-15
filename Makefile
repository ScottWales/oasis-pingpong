all:a b rsta.nc rstb.nc
	rm anaisout
	mpiexec -n 1 oasis3.MPI1.x : -n 1 a : -n 1 b

FC=mpif90
LD=$(FC)
LDLIBS+=-lpsmile.MPI1 -lmpp_io -lnetcdff -lnetcdf

rsta.nc:rst_in.nc
	cp $< $@
rstb.nc:rst_in.nc
	cp $< $@

%.o:%.f90
	$(FC) $(FFLAGS) -c -o $@ $<
%:%.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
