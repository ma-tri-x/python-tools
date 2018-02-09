#!/bin/bash

# echo "# cellsize  courantNo  percentage_dissipation_amplitudes" >> resolution_research_results.dat
for cellsize in 60e-6
do
    for courantNo in 0.2
    do
        echo "------------------------------------------- $cellsize       $courantNo ------------------------------------------------"
        cp conf_dict.json.org conf_dict.json
        sed -i "s/CELLSIZE/$cellsize/g" conf_dict.json
        sed -i "s/COURANTNO/$courantNo/g" conf_dict.json
        bash rerun.sh
        rm srun.log
        bigNo=$(python find_biggestNumber.py -p processor0)
        reconstructPar -time $bigNo
        sample -time $bigNo
        maxCo=$(python find_max_CoNum.py -p processor0/CoNum.dat)
        echo "$cellsize  $courantNo $maxCo  $(python get_amplitude_dissipation_percentage.py -p sets/$bigNo/lineX1_p_rgh_rhoBubble.xy)" >> resolution_research_results.dat
        python find_local_maxima.py -p sets/$bigNo/lineX1_p_rgh_rhoBubble.xy
        mv  sets/$bigNo/lineX1_p_rgh_rhoBubble_local_maxima.dat sets/$bigNo/lineX1_p_rgh_rhoBubble_local_maxima_${cellsize}_${courantNo}.dat
        echo "-----------------------------------------------------------------------------------------------------------------------"
    done
done