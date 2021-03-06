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
// * * * * * * * 2017-08-24 Max Koch microchannel      * * * * * * * * * * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * LT* _wave-transmissive* * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * | * * | RT* * * * ^ XF* * * * * * * * * * * * * * //
// * * * * * * * * * * * * | B * | * * * * * | * * * * * * * * * * * * * * * //
// * * * * * * * * * * lt* ------| rt* * * * ^ Y * * * * * * * * * * * * * * //
// * * * * * * * * * * * * |_* * | * * * * * | * * * * * * * * * * * * * * * //
// * * * * * * * * *axis * |_) A | wall* * * 0 * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * | * * | * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * ld* ------| rd* * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * | B * | * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * | * * | * * * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * LD* |_____| RD* * * * * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * wave-transmissive * * * * * * * * * * * * * * * * //
// * * * * * * * * * * * * 0 ->  X * * * * * * * * * * * * * * * * * * * * * //


changecom(//)changequote([,])
 
define(calc, [esyscmd(perl -e 'use Math::Trig; use Math::Round; printf ($1)')])
define(PI, 3.14159265358979323846264338327950288)

//# define function to get circle point coordinates when having origin in (0 0 0)
//# GCP = getCirclePoint
//# GCPx = R * cos(phi [deg]) * cos(theta [rad]
define(GCPx, [calc(($1)*cos( ($2)/180.*PI ) *cos(($3)/180.*PI))])
define(GCPy, [calc(($1)*sin( ($2)/180.*PI ))])
define(GCPz, [calc(($1)*cos( ($2)/180.*PI ) *sin(($3)/180.*PI))])

define(VCOUNT, 0)
 
define(vlabel, [[// ]Vertex $1 = VCOUNT define($1, VCOUNT)define([VCOUNT], incr(VCOUNT))])

convertToMeters 1;




//# parameters that drive the mesh:
define(Rmax, 0.000495)
define(X, calc(1.01 * Rmax))
define(XF,calc(100 * Rmax))
define(cellsize, 1.5e-06)



//################### domain A
define(theta, calc(atan(0.5*cellsize/X)/PI*180.))
define(Y, calc(Rmax + 15e-6))
define(AnumX, calc(round(X/cellsize)))
define(AnumY, calc(round(2.*Y/cellsize)))

//################### domain B
//# length of B domain
define(l_B, calc(XF-Y)) 
//# grading of B domain
define(Bgrd,calc(9.*XF/Y)) 
//# computing radial number of cells
define(logarg, calc((cellsize/l_B-1.)/(cellsize/l_B*Bgrd - 1.)))
define(_Bnum, calc(1+log(Bgrd)/log(logarg)  ))
define(Bnum, calc(round(_Bnum)))

vertices
(

    (                    0             -Y                     0)      vlabel(ldf)
    (                    0             -Y                     0)      vlabel(ldb)
    
    (                    0              Y                     0)      vlabel(ltf)
    (                    0              Y                     0)      vlabel(ltb)
    
    (GCPx(X  ,  0., theta)              Y GCPz(X  ,  0., theta))      vlabel(rtf)
    (GCPx(X  ,  0., theta)              Y GCPz(X  ,  0.,-theta))      vlabel(rtb)
    
    (GCPx(X  ,  0., theta)             -Y GCPz(X  ,  0., theta))      vlabel(rdf)
    (GCPx(X  ,  0., theta)             -Y GCPz(X  ,  0.,-theta))      vlabel(rdb)
    
    (                    0             XF                     0)      vlabel(LTF)
    (                    0             XF                     0)      vlabel(LTB)
    
    (GCPx(X  ,  0., theta)             XF GCPz(X  ,  0., theta))      vlabel(RTF)
    (GCPx(X  ,  0.,-theta)             XF GCPz(X  ,  0.,-theta))      vlabel(RTB)

    (                    0            -XF                     0)      vlabel(LDF)
    (                    0            -XF                     0)      vlabel(LDB)

    (GCPx(X  ,  0., theta)            -XF GCPz(X  ,  0., theta))      vlabel(RDF)
    (GCPx(X  ,  0.,-theta)            -XF GCPz(X  ,  0.,-theta))      vlabel(RDB)    
);
 
blocks
(
  hex (ldf rdf rdb ldb  ltf rtf rtb ltb)  (AnumX 1 AnumY) simpleGrading (1 1    1)
  hex (ltf rtf rtb ltb  LTF RTF RTB LTB)  (AnumX 1  Bnum) simpleGrading (1 1 Bgrd)
  hex (rdf ldf ldb rdb  RDF LDF LDB RDB)  (AnumX 1  Bnum) simpleGrading (1 1 Bgrd)
);


edges                  
(
);
 
patches
(
     wedge front
     (    
           (ltf rtf RTF LTF)
           (ldf rdf rtf ltf)
           (LDF RDF rdf ldf)
     )     
           

     wedge back
     (
           (LTB RTB rtb ltb)
           (ltb rtb rdb ldb)
           (ldb rdb RDB LDB)
     )
     
     patch upside
     (            
            (LTF RTF RTB LTB)
     )
     
     patch downside
     (            
            (RDF LDF LDB RDB)
     )
     
     patch wall
     (            
            (RDF RDB rdb rdf)
            (rtf rdf rdb rtb)
            (RTF rtf rtb RTB)
     )

     empty axis
     (
           (ltf LTF LTB ltb)
           (ldf ltf ltb ldb)
           (ldf ldb LDB LDF)
     )
);   
     

mergePatchPairs
(
);