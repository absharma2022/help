!This is fortran program to get idea about an error while not using end after start with do

! while compling with ifort it will give following error

!!!	err_unterminated_block_exists.f90(15): error #6321: An unterminated block exists.
!!!		DO i = 1, 3
!!!	^
!!!	compilation aborted for err_unterminated_block_exists.f90 (code 1)

! while compiling with gfortran it will give following error

!!!	err_unterminated_block_exists.f90:29:3:

!!!  	 13 | END PROGRAM temp
!!! 	     |   1
!!!	Error: Expecting END DO statement at (1)
!!!	f951: Error: Unexpected end of file in ‘err_unterminated_block_exists.f90’


PROGRAM err_unterminated_block_exists
	implicit none
	INTEGER :: i, j, product
	DO i = 1, 3
		DO j = 1, 3
			product = i * j
			WRITE (*,*) i, ' * ', j, ' = ', product
		!END DO
	END DO
END PROGRAM err_unterminated_block_exists
