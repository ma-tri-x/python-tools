reset
set term x11
set output
set ytics nomirror
set y2tics nomirror

set y2range [*:*]

set key above

set ylabel  "U^y [m/s]"
set y2label "distance [micrometer]"

plot 'postProcessing/swakExpression_minUyPosition/0/minUyPosition' using (($1)*1e6):(($2)*1e6) "%lf (%lf %lf %lf)" axis x1y2 w l title "x-position of min U^y",\
     'postProcessing/swakExpression_minUyPosition/0/minUyPosition' using (($1)*1e6):(($3)*1e6) "%lf (%lf %lf %lf)" axis x1y2 w l title "y-position of min U^y", \
     'postProcessing/swakExpression_extremeUy/0/extremeUy' using (($1)*1e6):2 w l title "min(U^y), left axis"