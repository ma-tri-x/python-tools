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



define(Rmax, 0.0002)
define(X, calc(1.5 * Rmax))                     // bubble domain im (domain B)
define(XF,calc(166.301751592 * Rmax))              // mesh end (domain C)
define(deg90num, 180)
define(cellsize, 8e-06)


define(XG,calc(1.4*XF))



//#define(cellWX,  calc(0.5*PI*X /deg90num))
define(cellWX,  calc(0.5*cellsize))
define(cellWXF, calc(0.5*PI*XF/deg90num))
define(numA,calc(round(X/cellWX)))

define(lenB, calc(XF-X))
define(grdB, calc(1.2*XF/X))
define(logarg, calc((cellWX/lenB-1.)/(cellWX/lenB*grdB - 1.)))
define(NB, calc(1+log(grdB)/log(logarg)  ))
define(numB,calc(round(NB)))

define(lenC, calc(XG-XF))
define(grdC, calc(5.25*XG/XF))
//#define(logarg, calc((cellWXF/lenC-1.)/(cellWXF/lenC*grdC - 1.)))
//#define(NC, calc(1+log(grdC)/log(logarg)  ))
define(numC, 14) //#calc(round(NC)))

define(theta, calc(90./deg90num/2.))

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

    (XF -cellWX  cellWX)      vlabel(fRd)
    (XF  cellWX  cellWX)      vlabel(fRt)
    (XF  cellWX -cellWX)      vlabel(bRt)
    (XF -cellWX -cellWX)      vlabel(bRd)

    (XG -cellWX  cellWX)      vlabel(FRd)
    (XG  cellWX  cellWX)      vlabel(FRt)
    (XG  cellWX -cellWX)      vlabel(BRt)
    (XG -cellWX -cellWX)      vlabel(BRd)
);
 
blocks
(
  hex (fld frd brd bld   flt frt brt blt)   (calc(round( X     /(cellsize))) 1 1) simpleGrading (1 1 1)       
  hex (frd fRd bRd brd   frt fRt bRt brt)   (calc(round((XF-X) /(cellsize))) 1 1) simpleGrading (1 1 1)      
  hex (fRd FRd BRd bRd   fRt FRt BRt bRt)   (calc(round((XG-XF)/(cellsize))) 1 1) simpleGrading (1 1 1)
);

edges
(
);
 
patches
(
     empty axis
     (
           (fld frd frt flt)    
           (frd fRd fRt frt)      
           (fRd FRd FRt fRt)   
//      )
//      
//      empty back
//      (
           (bld blt brt brd)
           (brd brt bRt bRd)
           (bRd bRt BRt BRd) 
//      )
//      
//      empty top
//      (
           (flt frt brt blt)
           (frt fRt bRt brt)
           (fRt FRt BRt bRt)
//      )
//      
//      empty bottom
//      (
           (fld bld brd frd)
           (frd brd bRd fRd)
           (fRd bRd BRd FRd)
     )
     
     patch side
     (
            (fld flt blt bld)   
     )                   
     
     patch transducer
     (                      
            (FRd BRd BRt FRt)
     )                      

);


mergePatchPairs
(
);


////# cellwidthAtXF:
//#cellWXF
////# smallest cell in C
//#calc(lenC*(grdC**(1./(numC-1))-1)/(grdC**(numC/(numC-1))-1))
