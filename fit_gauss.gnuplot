reset
set term x11
set output

set grid

# x9mm_y6.71mm

# 1392 x 1040 px

mm(x) = 9./1392.*x

Ix = 250.
Iy = 250.

sigmax = 4.5
sigmay = 4.5
x0 = 4.
x1 = 4.

f(x) = Ix * exp(-(x - x0)**2/(2.*sigmax))
g(x) = Iy * exp(-(x - x1)**2/(2.*sigmay))

fit f(x) "Laser-Profile_2018-02-07/Straigh_low_Intensity_x.dat" u (mm($1)):2 via Ix,x0,sigmax
fit g(x) "Laser-Profile_2018-02-07/Straigh_low_Intensity_y.dat" u (mm($1)):2 via Iy,x1,sigmay

set ylabel "Intensitaet [bit]"
set xlabel "Laenge [mm]"

p "Laser-Profile_2018-02-07/Straigh_low_Intensity_x.dat" u (mm($1)):2 w l t "x-profil",\
  "Laser-Profile_2018-02-07/Straigh_low_Intensity_y.dat" u (mm($1)):2 w l t "y-profil",\
  f(x) t sprintf("x-profil fit, Breite = %.3f mm", sigmax),\
  g(x) t sprintf("y-profil fit, Breite = %.3f mm", sigmay)
  
set term postscript eps color enhanced solid
set output "fit_gauss_2018-02-07_Straigh_low_intensity.eps"
replot

!epstopdf fit_gauss_2018-02-07_Straigh_low_intensity.eps
!rm fit_gauss_2018-02-07_Straigh_low_intensity.eps