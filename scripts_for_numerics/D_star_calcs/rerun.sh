#!/bin/bash

a_date=$(date)

source $HOME/foam/foam-extend-3.2/etc/bashrc
 
bash Allclean
 
python rerun.py

bash Allrun
# 
b_date=$(date)
# 
echo    "script ran from ($a_date) till ($b_date)"
echo -e "\n\n######################### end #########################"
