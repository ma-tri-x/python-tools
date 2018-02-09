reset
set term x11
set output
set key right
# set y2tics
set grid
set encoding utf8

set xlabel "time [µs]"
set ylabel "equivalent bubble radii [µm]"
#set ylabel "bubble mass normalized"
#set multiplot layout 2,1
# set y2label "interface volume normalized"

# file1="postProcessing/volumeIntegrate_volumeIntegral/0/rhoBubbleMules"          
# file2="postProcessing/volumeIntegrate_volumeIntegral/0/rhoBubbleAfterContinuity"
# file3="postProcessing/volumeIntegrate_volumeIntegral/0/rhoBubbleBeforeEOS"      
file4="postProcessing/volumeIntegrate_volumeIntegral/0/rhoBubble"
file_rad="postProcessing/volumeIntegrate_volumeIntegral/0/alpha2"
file_rad2="~/2016WiSe2017/foamProjects/0041_higherViscosity_sameEnergy/postProcessing/volumeIntegrate_volumeIntegral/0/alpha2"
# file5="postProcessing/volumeIntegrate_volumeIntegral/0/rhoInterface"
# file6="postProcessing/volumeIntegrate_volumeIntegral/0/rhoBubbleInterface"
# file7="postProcessing/volumeIntegrate_volumeIntegral/0/massSourceInterface"
# file8="postProcessing/volumeIntegrate_volumeIntegral/0/alpha2"
# file9="postProcessing/volumeIntegrate_volumeIntegral/0/alphaInterface"

# value1=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file1))
# value2=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file2))
# value3=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file3))
value4=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file4))
valuer=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file_rad))
valuer2=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file_rad2))
# value5=system(sprintf("head -n 22 %s | awk '{print $2}' | tail -n 1",file5))
# value7=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file7))
# value8=system(sprintf("head -n 2 %s | awk '{print $2}' | tail -n 1",file8))
# value9=system(sprintf("head -n 3 %s | awk '{print $2}' | tail -n 1",file9))

# system(sprintf("paste %s %s > rhoBubbleInterface",file4,file5))

# p sprintf("%s",file1) u ($1):($2)/value1 w l lw 3 t "Mules",\
#   sprintf("%s",file2) u ($1):($2)/value2 w l lw 2 t "AfterCont",\
#   sprintf("%s",file3) u ($1):($2)/value3 w l      t "BeforeEOS",\
#   sprintf("%s",file9) u ($1):($2)/value9 w l axis x1y2     t "InterfaceVol" #,\
#   sprintf("%s",file7) u ($1):($2)/value7 w l axis x1y2 lt 6    t "massSourceInterf"
#   sprintf("%s",file6) u ($1):((value4-$4)/($2) ) w l      t "1-(Interface/Final)"
  #,\
  #"intU.dat"                             w l axis x1y2     t "int.Vel."
  
#   sprintf("%s",file5) u ($1):($2)/value5 w l      t "Interface",\
  #sprintf("%s",file0) u ($1):($2)/value0 w l lt 6 t "Reference 0.4"

#set y2tics

p  sprintf("%s",file_rad)  u (($1)*1e6):((($2)/valuer)**(1./3.)  *50) w l lw 3 t "water",\
   sprintf("%s",file_rad2) u (($1)*1e6):((($2)/valuer2)**(1./3.) *50) w l lw 3 t "PA 85\%"
   
   
set term postscript eps enhanced color solid font ",14" #png enhanced large font ",14"
set output "DAGA-compare-water-PA.eps"
replot
