!this fortran program will produced an error named as input statement requires too much data
! this is beacuse of when we read a file and during this data written style is not matched vraibles
! decleared to read that data

program input_statement_requires_too_much_data
	implicit none
	integer :: i, n, file_id,j,k,kk,t
	double precision::x,y
	file_id = 33
	j=1
	n=10
	open(file_id,file="test1.dat",status='unknown')
	
	do i=1,n
		t=i+j
		write(file_id,*)i,t
		!write(file_id,*)i+j
	end do
	
	close(file_id)
	file_id = file_id +1  ! we want to open with different id to read
	
	open(file_id,file="test1.dat",status='unknown')
	do 
		read(file_id,*,end=10)k,kk ! if I don't use end =10 then it through an 					   error named Fortran runtime error: End of file
		!read(file_id,*)kk
		print*,k,kk
	end do
	10 close(file_id)	
end program

