reset
set term x11
set output

set grid

p 'resolution_research_results.dat' u (($2)==0.1  ? (($1)*1e6) : NaN):($3)  lw 2 pt 2 t "maxCo = 0.1",\
  ''                                u (($2)==0.05 ? (($1)*1e6) : NaN):($3)  lw 4 pt 3 t "maxCo = 0.05",\
  ''                                u (($2)==0.01 ? (($1)*1e6) : NaN):($3)  lw 2 pt 4 t "maxCo = 0.01"
