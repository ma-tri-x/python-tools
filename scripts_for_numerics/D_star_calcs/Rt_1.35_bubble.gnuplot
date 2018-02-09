reset
set term x11 #postscript eps color enhanced solid #x11
set output   # "Rt.eps"
set grid
set ylabel "Radius [$\\mu$m]"
set xlabel "$t$ [$\\mu$s]"
set key #outside tmargin

deg90num=180
cellsize=6e-06 #90./deg90num
X=2.2 * 0.000495
theta=atan(0.5*cellsize/X) #/pi*180.   #0.5*cellsize/180.*pi
#theta=90./deg90num/2./180.*pi




set title "cell size = 6$\\mu$m, $R_0$ = 25$\\mu$m, $R_{n,\\mathrm{start}}$ = 184$\\mu$m, $R_{n,\\mathrm{end}}$ = 80$\\mu$m"

plot 'postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \
                          using ((($1))*1e6):((($2)*3./(4.*theta))**(1/3.)*1e6) w l lw 1 t ""
     
#                             using ((($1))*1e6):((3.*($2)/(4.*tan(theta)**2) )**(1/3.)*1e6) w l lw 1 t "R(t) - OF - gmc"
                           
                           #3.2267085e-18,\


#plot 'postProcessing/volumeIntegrate_volumeIntegral/0/alpha2' \

     #,\
     #"gilmore/gilmore747e-6_65e-6.dat" using (($1)*1e6):(($2)*1e6) w l t "gil"
     
     
#!epstopdf Rt.eps
#!rm Rt.eps

pause -1

set term epslatex standalone color font ",8"
set output "Rt_1-35_bubble.tex"
replot
set output

!pdflatex Rt_1-35_bubble.tex
!rm *.aux *.log *inc*eps *inc*pdf