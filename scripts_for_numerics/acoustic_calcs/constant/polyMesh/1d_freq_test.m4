/*--------------------------------*- C++ -*----------------------------------*\
| =========                 |                                                 |
| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |
|  \\    /   O peration     | Version:  2.0.0                                 |
|   \\  /    A nd           | Web:      www.OpenFOAM.com                      |
|    \\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/

FoamFile
{
    version         2.0;
    format          ascii;
 
    root            "";
    case            "";
    instance        "";
    local           "";
 
    class           dictionary;
    object          blockMeshDict;
}
 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

changecom(//)changequote([,])
 
define(calc, [esyscmd(perl -e 'use Math::Trig;use Math::Round; printf ($1)')])
define(PI, 3.14159265358979323846264338327950288)
 
define(VCOUNT, 0)
 
define(vlabel, [[// ]Vertex $1 = VCOUNT define($1, VCOUNT)define([VCOUNT], incr(VCOUNT))])

convertToMeters 1;

define(GCPx, [calc(($1)*cos( ($2)/180.*PI ) *cos( ($3)/180.*PI ))])
define(GCPy, [calc(($1)*sin( ($2)/180.*PI ))])
define(GCPz, [calc(($1)*cos( ($2)/180.*PI ) *sin( ($3)/180.*PI ))])



define(freq, 25120.0)
define(rho, 1574.0)                     // bubble domain im (domain B)
define(C,1671.0)              // mesh end (domain C)
define(cellsize, 8e-06)


define(X,calc(C/freq))



//#define(cellWX,  calc(0.5*PI*X /deg90num))
define(cellWX,  calc(0.5*cellsize))
define(numA,calc(round(X/cellsize)))

vertices
(
    (0  -cellWX  cellWX)      vlabel(fld)
    (0   cellWX  cellWX)      vlabel(flt)
    (0   cellWX -cellWX)      vlabel(blt)
    (0  -cellWX -cellWX)      vlabel(bld)
    
    (X  -cellWX  cellWX)      vlabel(frd)
    (X   cellWX  cellWX)      vlabel(frt)
    (X   cellWX -cellWX)      vlabel(brt)
    (X  -cellWX -cellWX)      vlabel(brd)
);
 
blocks
(
  hex (fld frd brd bld   flt frt brt blt)   (numA 1 1) simpleGrading (1 1 1)
);

edges
(
);
 
patches
(
     empty axis
     (
           (fld frd frt flt)
           (bld blt brt brd)
           (flt frt brt blt)
           (fld bld brd frd)
     )
     
     patch wall
     (
            (fld flt blt bld)   
     )
     
     patch wall2
     (                      
            (brd brt frt frd)
     )                      

);


mergePatchPairs
(
);


////# cellwidthAtXF:
//#cellWXF
////# smallest cell in C
//#calc(lenC*(grdC**(1./(numC-1))-1)/(grdC**(numC/(numC-1))-1))
