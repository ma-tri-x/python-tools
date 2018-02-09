reset
set term x11
set output
set ytics nomirror
set y2tics nomirror

set key above


set yrange [*:*]
set ylabel "max(p) [Pa]"
set y2label "distance [micrometer]"
set xlabel "time [microseconds]"

plot 'postProcessing/swakExpression_maxPPosition/0/maxPPosition' using (($1)*1e6):(($2)*1e6) "%lf (%lf %lf %lf)" axis x1y2 w l title "x-position of max p",\
     'postProcessing/swakExpression_maxPPosition/0/maxPPosition' using (($1)*1e6):(($3)*1e6) "%lf (%lf %lf %lf)" axis x1y2 w l title "y-position of max p" , \
     'postProcessing/swakExpression_extremeP/0/extremeP'         using (($1)*1e6):3 axis x1y1 w l title "max(p), left axis"
