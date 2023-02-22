//Mean square displacements

void msdf(int np,double **r,double dt,int nsi)
{
	//Index variables
	int i,j,k;
	
	//Index
	static int l=0;

	//Duration of the correlation function
	static double td;

	//Time grid
	static double tg;

	//Mean square displacements
	static double *msd;

	//Normalization factor
	static double *nf;

        //Time series of configurations
	static double ***g;

	////Flag variable
	static int flg=0;
	//Array size of correlation
	static int nt;



	if(flg==0){
		//Duration of the correlaton
		td=10.0;
		//Time grid
		tg=dt*((double)nsi);
		//Define nt
		nt=(int)(td/tg)+1;
		printf("nt=%d\n",nt);
		//Allocate memory for the mean square displacement
		msd=(double*)calloc(nt,sizeof(double));
		nf=(double*)calloc(nt,sizeof(double));

		//Memory of the time series
		g=(double***)calloc(nt,sizeof(double**));
		for(i=0;i<nt;i++){
			g[i]=(double**)calloc(np,sizeof(double*));
			for(j=0;j<np;j++)g[i][j]=(double*)calloc(3,sizeof(double));
		}//End of allocation of memory

	}//End of IF

	//Update the flag
	flg++;

	//Counter variable
	static int m=0;

	////exit(EXIT_SUCCESS);

	//Fill the time series
	if(m<nt){

		//Store configuration
		for(i=0;i<np;i++){
			g[m][i][0]=r[i][0];	
			g[m][i][1]=r[i][1];	
			g[m][i][2]=r[i][2];	
		}//End of for
		printf("m=%d\n",m);
		//Increment m
		m++;
	}else{
		//Create space for the new configuration
		//Shift of  time origin
		for(i=0;i<nt-1;i++){
			for(j=0;j<np;j++){
				g[i][j][0]=g[i+1][j][0];
				g[i][j][1]=g[i+1][j][1];
				g[i][j][2]=g[i+1][j][2];
			}//Transfer of np data
		}//End of loop over time series

		//Update the last configuration
		for(i=0;i<np;i++){
			g[nt-1][i][0]=r[i][0];
			g[nt-1][i][1]=r[i][1];
			g[nt-1][i][2]=r[i][2];
		}
	}//End of IF
	
	if(m<nt)return;

	//Compute time correlation function
	double dx,dy,dz,ds2;
	//Loop over time 
	for(i=0;i<nt;i++){
		//Loop over particles
		for(j=0;j<np;j++){
			//Vectorial `Displacement
			dx=g[0][j][0]-g[i][j][0];
			dy=g[0][j][1]-g[i][j][1];
			dz=g[0][j][2]-g[i][j][2];
			//Square of distance
			ds2=dx*dx+dy*dy+dz*dz;
			//printf("ds2 = %lf i=%d\n",ds2,i);
			msd[i]+=ds2;
		}
		//Noramlization factor
		nf[i]+=(double)np;
	}//Correlation loop ends

	l++;

	//Write out the output
	if(l%10==0){
		FILE* out=fopen("msd.dat","w");
		for(i=0;i<nt;i++){
			fprintf(out,"%lf %lf\n",(double)i*tg,msd[i]/nf[i]);
			//printf("%lf %lf\n",(double)i*tg,msd[i]/nf[i]);
		}//End of write
		fclose(out);
	}//End of if

	



	//exit(EXIT_SUCCESS);
	return;
}	




