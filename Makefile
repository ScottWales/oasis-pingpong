all:a b rsta.nc rstb.nc
	rm -f anaisout
	mpiexec -n 1 oasis3.MPI1.x : -n 1 a : -n 1 b
debug:a b rsta.nc rstb.nc
	rm -f anaisout
	mpiexec --debug -n 1 $$(which oasis3.MPI1.x) : -n 1 a : -n 1 b

clean:
	rm -f *.prt* a b *out *weights rsta.nc rstb.nc grids.nc masks.nc
	

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
