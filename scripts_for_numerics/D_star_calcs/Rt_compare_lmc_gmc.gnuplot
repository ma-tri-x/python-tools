
reset
set term x11 #postscript eps color enhanced solid #x11
set output   # "Rt.eps"
set grid
set ylabel "Radius [$\\mu$m]"
set xlabel "$t$ [$\\mu$s]"
set key #outside tmargin

deg90num=180
cellsize=2e-07 #90./deg90num
X=1.2 * 0.000747
#theta=atan(0.5*cellsize/X) #/pi*180.   #0.5*cellsize/180.*pi
theta=90./deg90num/2./180.*pi
theta_lmc=90./180./2./180.*pi
theta2=1.0/180.*pi    #90./deg90num/2./180.*pi



set title "$R(t)$ with global mass correction depending on $\\theta$ \nand tested with resolution $n_{90}$ variation\n $R_0$ = 0.000747, $R_{n,start}$ = 8e-05"


plot 'GilmoreSolver/gilmore.dat' using (($1)*1e6):(($2)*1e6) w l t "Gilmore solution",\
     'gmc_theta2.0_deg90num_360_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 2.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 2.0, n_{90}=360$",\
     'gmc_theta2.0_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 2.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 2.0, n_{90}=180$",\
     'gmc_theta2.5_deg90num_360_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 2.5/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 2.5, n_{90}=360$",\
     'gmc_theta4.0_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 4.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 4.0, n_{90}=180$",\
     'gmc_theta10.0_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan(10.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta=10.0, n_{90}=180$"
                            
    
    
pause -1

set term epslatex standalone color font ",8"
set output "Rt_gmc.tex"
replot
set output

!pdflatex Rt_gmc.tex
!rm *.aux *.log *inc*eps *inc*pdf

# 
set term x11 #postscript eps color enhanced solid #x11
set output

set title "$R(t)$ with local mass correction depending on $\\theta$ \nand tested with resolution $n_{90}$ variation\n $R_0$ = 0.000747, $R_{n,start}$ = 8e-05"
plot 'GilmoreSolver/gilmore.dat' using (($1)*1e6):(($2)*1e6) w l t "Gilmore solution",\
     'lmc_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan(theta_lmc   )**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 0.25, n_{90}=180$",\
     'lmc_theta1.0_deg90num_180_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 1.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 1.0, n_{90}=180$",\
     'lmc_theta1.0_deg90num_220_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 1.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 1.0, n_{90}=220$",\
     'lmc_theta1.0_deg90num_360_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan( 1.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 1.0, n_{90}=360$",\
     'lmc_theta2.0_deg90num_360_postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                            using ((($1))*1e6):((3.*($2)/(4.*tan(2.0/180.*pi)**2) )**(1/3.)*1e6) w l lw 1 t "$\\theta= 2.0, n_{90}=360$"
                            
pause -1

set term epslatex standalone color font ",8"
set output "Rt_lmc.tex"
replot
set output

!pdflatex Rt_lmc.tex
!rm *.aux *.log *inc*eps *inc*pdf