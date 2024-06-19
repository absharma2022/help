#!/bin/bash

# give it execute permissions  using chmod +x granular.sh
# run by following command ./granular.sh <init_arg> where <init_arg> =1 for 1 time
for (( i=1; i<=50; i=i+1 )); do
    # Create a directory named frac_<i>
    mkdir samp_${i}

    # Copy the Unifiedcode16a directory to the newly created directory
    cp -r UnifiedCode16a samp_${i}

    # Navigate to the maincode subdirectory of the copied Unifiedcode16a
    cd samp_${i}/UnifiedCode16a/maincode

    # Modify the area_1 value in param_1.f90 using sed
    sed -i "s/area_1=0.7d0/area_1=${i/100}.d0/" param_1.f90

        cd ../
    # Run make

    bash cleanall.sh
    make

    # Execute init.exe with the first argument passed to the script
    cd init
    echo $i |   ./init.exe

    cp ../../../config_1no8.in config_1no1.in #replacing by steady state config file

    # Go back to the maincode directory and run the simulations
    cd ../maincode
    nohup time mpiexec -n 16 ./simulate.exe > foo.out 2> foo.err < /dev/null

    # Return to the initial directory
    cd ../../../
done
