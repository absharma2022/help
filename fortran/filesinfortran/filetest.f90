program filetest
	
	implicit none
	integer :: i,j,n_tot,n_skip,n_left
	real :: a, b
	
	open(unit = 10, file = "data.dat", status = "Unknown",action ="write")
	n_tot = 20; j = 20; n_skip = 10
	n_left = n_tot - n_skip
	do i = 1,n_tot
		
		a = i*j
		b = j/i
		write(10,*)a,b
	end do
	close(10)
	open(unit = 10, file = "data.dat", status = "Unknown",action ="read")
	open(unit = 11, file = "halfdata.dat",status = "unknown",action ="write")
	open(unit = 12, file = "nexthalfdata.dat",status = "unknown",action ="write")
	do i = 1, n_skip
		!read(10,*)a,b
		!write(11,*)a,b
	end do
	close(11)
	do i = n_skip, n_left
		read(10,*)a,b
		write(12,*)a,b
	end do
	close(12)
	close(10)
end program
