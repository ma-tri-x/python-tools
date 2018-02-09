reset
set term x11 #postscript eps color enhanced solid #x11
set output   # "Rt.eps"
set grid
set ylabel "Radius [{/Symbol m}m]"
set xlabel "t [{/Symbol m}s]"
set key #outside tmargin

deg90num=180
cellsize=1.5e-06 #90./deg90num
X=1.01 * 0.000495
#theta=atan(0.5*cellsize/X) #/pi*180.   #0.5*cellsize/180.*pi
theta=90./deg90num/2./180.*pi
theta_lmc=90./180./2./180.*pi
theta2=2.0/180.*pi    #90./deg90num/2./180.*pi




set title "cell size = 1.5e-06, R_0 = 2.5e-05, R_{n,start} = 0.000184"

plot 'GilmoreSolver/gilmore.dat' using (($1)*1e6):(($2)*1e6) w l,\
     'lmc_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan(theta_lmc)**2) )**(1/3.)*1e6) w l lw 1 t "R(t) - OF - lmc",\
     'gmc_theta4.0_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan(4.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "R(t) - OF - gmc - theta=4.0",\
     'postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan(theta2)**2) )**(1/3.)*1e6) w l lw 1 t "R(t) - OF - gmc"
     
#                           using ((($1))*1e6):((($2)*3./(4.*theta))**(1/3.)*1e6) w l lw 1 t "R(t) - OF"
                           
                           #3.2267085e-18,\


#plot 'postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \

     #,\
     #"gilmore/gilmore747e-6_65e-6.dat" using (($1)*1e6):(($2)*1e6) w l t "gil"
     
     
#!epstopdf Rt.eps
#!rm Rt.eps