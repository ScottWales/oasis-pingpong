program a
    use mod_prism_proto
    use mod_prism_grids_writing
    use mod_prism_def_partition_proto
    use mod_prism_get_proto
    use mod_prism_put_proto
    implicit none
    integer,parameter :: nlon = 20, nlat = 10
    real(kind=8),dimension(nlon,nlat) :: lat, lon
    integer,dimension(nlon,nlat) :: mask
    real(kind=8),dimension(nlon,nlat) :: outfield, infield
    integer :: outid,inid,compid,partid

    integer ierr,info,needsgrids,i,j,period,time
    integer,dimension(3) :: partition
    integer,dimension(2) :: ndims
    integer,dimension(4) :: dims

    do j=1,nlat 
        do i=1,nlon
            lon(i,j) = nlon/20.0 * i
            lat(i,j) = nlat/10.0 * j
        end do
    end do

    call prism_init_comp_proto(compid,"B",ierr)

    call prism_start_grids_writing(needsgrids)
    if (needsgrids .eq. 1) then
        call prism_write_grid("bxxx",nlon,nlat,lon,lat)
        mask = 0
        call prism_write_mask("bxxx",nlon,nlat,mask)
        call prism_terminate_grids_writing()
    end if

    partition = (/0,0,nlon*nlat/)
    call prism_def_partition_proto(partid,partition,ierr)

    ndims = (/2,1/)
    dims = (/1,nlon,1,nlat/)
    call prism_def_var_proto(outid,"boutxxxx",partid,ndims,PRISM_Out,dims,PRISM_Real,ierr)
    call prism_def_var_proto(inid,"binxxxxx",partid,ndims,PRISM_In,dims,PRISM_Real,ierr)
    call prism_enddef_proto(ierr)

    do time=0,145,5
        call prism_get_proto(inid,time,infield,info)
        write(*,*) "B get status ",time,info
        call prism_put_proto(outid,time+5,outfield,info)
        write(*,*) "B put status ",time,info
    end do

    call prism_terminate_proto(ierr)
end program
