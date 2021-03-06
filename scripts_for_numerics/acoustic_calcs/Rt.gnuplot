reset
set term x11 #postscript eps color enhanced solid #x11
set output   # "Rt.eps"
set grid
set ylabel "Radius [{/Symbol m}m]"
set xlabel "t [{/Symbol m}s]"
set key #outside tmargin

deg90num=180
cellsize=8e-06 #90./deg90num
X=1.5 * 0.0002
theta=atan(0.5*cellsize/X) #/pi*180.   #0.5*cellsize/180.*pi
#theta=90./deg90num/2./180.*pi




set title "cell size = 8e-06, R_0 = 0.0002, R_{n,start} = 5e-05"

plot 'postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                           using ((($1))*1e6):((($2)*3./(4.*theta))**(1/3.)*1e6) w l lw 1 t "R(t) - OF"
     
#                            using ((($1))*1e6):((3.*($2)/(4.*tan(theta)**2) )**(1/3.)*1e6) w l lw 1 t "R(t) - OF"
                           
                           #3.2267085e-18,\


#plot 'postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \

     #,\
     #"gilmore/gilmore747e-6_65e-6.dat" using (($1)*1e6):(($2)*1e6) w l t "gil"
     
     
#!epstopdf Rt.eps
#!rm Rt.eps