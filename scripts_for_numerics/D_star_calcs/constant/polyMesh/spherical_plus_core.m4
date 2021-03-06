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

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * rebuild * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * 2018-01-16 Max Koch spherical * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * (f/b)lt * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * (f/b)ct * * * * * * * rt* * * * * * * * * *(f/b)Rt* * * (F/B)Rt //
// * * * * * * * * _________Rmax___*__________________________ ________* * * //
// * * * * * * * < __|___A___)_____|____________B_____________|____C___| * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * (f/b)cd * (f/b)ld * * rd* * * * * * * * * *(f/b)Rd* * * (F/B)Rd //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * | * * * * * * * * | * * * * * * * * * * * * *|* * * * | * * //
// * * * * * * * 0 * * * * * * * * X * * * * * * * * * * * * *XF * * * XG* * //
// *necessary parameters:* * * * * * * * * * * * * * * * * * * * * * * * * * //
// *_RESOLUTION=deg90num * * * * * * * * * * * * * * * * * * * * * * * * * * //
// *_XPOS=X* _XFPOS=XF * * * * * * * * * * * * * * * * * * * * * * * * * * * //

changecom(//)changequote([,])
 
define(calc, [esyscmd(perl -e 'use Math::Trig;use Math::Round; printf ($1)')])
define(PI, 3.14159265358979323846264338327950288)
 
define(VCOUNT, 0)
 
define(vlabel, [[// ]Vertex $1 = VCOUNT define($1, VCOUNT)define([VCOUNT], incr(VCOUNT))])

convertToMeters 1;

define(GCPx, [calc(($1)*cos( ($2)/180.*PI ) *cos( ($3)/180.*PI ))])
define(GCPy, [calc(($1)*sin( ($2)/180.*PI ))])
define(GCPz, [calc(($1)*cos( ($2)/180.*PI ) *sin( ($3)/180.*PI ))])




define(Rmax, 0.000495)
define(C, 2e-05)
define(X, calc(1.01 * Rmax))                     // bubble domain im (domain B)
define(XF,calc(100 * Rmax))              // mesh end (domain C)
define(deg90num, 180)
define(cellsize, 1.5e-06)      // angular number of cells in B domain





define(XG,calc(1.4*XF))

define(cellWX,  calc(0.5*PI*X /deg90num))
define(cellWXF, calc(0.5*PI*XF/deg90num))
define(numA,calc(round(X/cellWX)))
define(numCore,calc(round(C/cellsize)))

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
    (                     0                0                      0)      vlabel(fcd)
    (                     0                0                      0)      vlabel(fct)
    (                     0                0                      0)      vlabel(bct)
    (                     0                0                      0)      vlabel(bcd)
    
    (GCPx(C ,-theta, theta) GCPy(C ,-theta)  GCPz(C ,-theta, theta))      vlabel(fld)
    (GCPx(C , theta, theta) GCPy(C , theta)  GCPz(C , theta, theta))      vlabel(flt)
    (GCPx(C , theta,-theta) GCPy(C , theta)  GCPz(C , theta,-theta))      vlabel(blt)
    (GCPx(C ,-theta,-theta) GCPy(C ,-theta)  GCPz(C ,-theta,-theta))      vlabel(bld)
    
    (GCPx(X ,-theta, theta) GCPy(X ,-theta)  GCPz(X ,-theta, theta))      vlabel(frd)
    (GCPx(X , theta, theta) GCPy(X , theta)  GCPz(X , theta, theta))      vlabel(frt)
    (GCPx(X , theta,-theta) GCPy(X , theta)  GCPz(X , theta,-theta))      vlabel(brt)
    (GCPx(X ,-theta,-theta) GCPy(X ,-theta)  GCPz(X ,-theta,-theta))      vlabel(brd)
    
    (GCPx(XF,-theta, theta) GCPy(XF,-theta)  GCPz(XF,-theta, theta))      vlabel(fRd)
    (GCPx(XF, theta, theta) GCPy(XF, theta)  GCPz(XF, theta, theta))      vlabel(fRt)
    (GCPx(XF, theta,-theta) GCPy(XF, theta)  GCPz(XF, theta,-theta))      vlabel(bRt)
    (GCPx(XF,-theta,-theta) GCPy(XF,-theta)  GCPz(XF,-theta,-theta))      vlabel(bRd)
    
    (GCPx(XG,-theta, theta) GCPy(XG,-theta)  GCPz(XG,-theta, theta))      vlabel(FRd)
    (GCPx(XG, theta, theta) GCPy(XG, theta)  GCPz(XG, theta, theta))      vlabel(FRt)
    (GCPx(XG, theta,-theta) GCPy(XG, theta)  GCPz(XG, theta,-theta))      vlabel(BRt)
    (GCPx(XG,-theta,-theta) GCPy(XG,-theta)  GCPz(XG,-theta,-theta))      vlabel(BRd)
);
 
blocks
(
  hex (fcd fld bld bcd   fct flt blt bct)   (numCore 1 1) simpleGrading (   1 1 1)
  hex (fld frd brd bld   flt frt brt blt)   (numA    1 1) simpleGrading (   1 1 1)       
  hex (frd fRd bRd brd   frt fRt bRt brt)   (numB    1 1) simpleGrading (grdB 1 1)      
  hex (fRd FRd BRd bRd   fRt FRt BRt bRt)   (numC    1 1) simpleGrading (grdC 1 1)
);

edges
(
);
 
patches
(
     wedge front
     (
           (fcd fld flt fct)
           (fld frd frt flt)    
           (frd fRd fRt frt)      
           (fRd FRd FRt fRt)   
     )
     
     wedge back
     (
           (bcd bct blt bld)
           (bld blt brt brd)
           (brd brt bRt bRd)
           (bRd bRt BRt BRd) 
     )
     
     wedge top
     (
           (fct flt blt bct)
           (flt frt brt blt)
           (frt fRt bRt brt)
           (fRt FRt BRt bRt)
     )
     
     wedge bottom
     (
           (fcd bcd bld fld)
           (fld bld brd frd)
           (frd brd bRd fRd)
           (fRd bRd BRd FRd)
     )
     
     patch side
     (
            (FRd BRd BRt FRt)
     )                   
     
     empty axis             
     (                      
            (fcd fct bct bcd)   
     )                      

);


mergePatchPairs
(
);


////# cellwidthAtXF:
//#cellWXF
////# smallest cell in C
//#calc(lenC*(grdC**(1./(numC-1))-1)/(grdC**(numC/(numC-1))-1))
