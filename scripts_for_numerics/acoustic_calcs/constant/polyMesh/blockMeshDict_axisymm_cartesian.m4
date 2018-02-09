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
define(wd, 0.00064155)              // distance of bubble center to rigid wall (only for comparison)
define(X, 570e-6)                     // bubble domain im (domain B)
define(Rmax, 550e-6)
define(XF,80e-3)              // mesh end (domain C)
define(cellsize, 4e-6)      // angular number of cells in B domain



//################### domain A
define(theta, calc(atan(0.5*cellsize/X)/PI*180.))
define(Y, calc(wd + Rmax + 15e-6))
define(AnumX, calc(round(X/cellsize)))
define(AnumY, calc(round(Y/cellsize)))
define(ratioYtX, calc(AnumY/(AnumX+AnumY)))
define(ang, calc(90.*ratioYtX))

//################### domain B
//# length of B domain
define(l_B, calc(XF-X)) 
//# grading of B domain
define(Bgrd,calc(9.*XF/X)) 
//# computing radial number of cells
define(logarg, calc((cellsize/l_B-1.)/(cellsize/l_B*Bgrd - 1.)))
define(_Bnum, calc(1+log(Bgrd)/log(logarg)  ))
define(Bnum, calc(round(_Bnum)))

//# l=left,r=right,f=front,b=back,t=top,d=down; Teildomänen durchnummeriert von oben nach unten
//# Reihenfolge: domain-nummer-left/right-top/down-front/back
vertices
(

    (                    0              0                     0)      vlabel(A1ldf)
    (                    0              0                     0)      vlabel(A1ldb)
    (                    0              Y                     0)      vlabel(A1ltf)
    (                    0              Y                     0)      vlabel(A1ltb)
    (GCPx(X  ,  0., theta)              Y GCPz(X  ,  0., theta))      vlabel(A1rtf)
    (GCPx(X  ,  0., theta)              Y GCPz(X  ,  0.,-theta))      vlabel(A1rtb)
    (GCPx(X  ,  0., theta)              0 GCPz(X  ,  0., theta))      vlabel(A1rdf)
    (GCPx(X  ,  0., theta)              0 GCPz(X  ,  0.,-theta))      vlabel(A1rdb)
    
    (                    0             XF                     0)      vlabel(B1rtf)
    (                    0             XF                     0)      vlabel(B1rtb)
    (GCPx(XF , ang, theta) GCPy(XF , ang) GCPz(XF , ang, theta))      vlabel(B1rdf)
    (GCPx(XF , ang,-theta) GCPy(XF , ang) GCPz(XF , ang,-theta))      vlabel(B1rdb)
            
    (GCPx(XF ,  0., theta)              0 GCPz(XF ,  0., theta))      vlabel(B2rdf)
    (GCPx(XF ,  0.,-theta)              0 GCPz(XF ,  0.,-theta))      vlabel(B2rdb)
);
 
blocks
(
  hex (A1ldf A1rdf A1rdb A1ldb   A1ltf A1rtf A1rtb A1ltb)  (AnumX 1 AnumY) simpleGrading (1 1 1) //# A1
                                                                   
  //# B                                                            
  hex (A1rtf B1rdf B1rdb A1rtb   A1ltf B1rtf B1rtb A1ltb)  (Bnum 1  AnumX) simpleGrading (Bgrd 1 1) //# B1
  hex (A1rdf B2rdf B2rdb A1rdb   A1rtf B1rdf B1rdb A1rtb)  (Bnum 1  AnumY) simpleGrading (Bgrd 1 1) //# B2
);


edges                  
(
  arc B1rdf  B1rtf  (GCPx(XF ,  80., theta) GCPy(XF ,  80.) GCPz(XF ,  80., theta))
  arc B1rdb  B1rtb  (GCPx(XF ,  80.,-theta) GCPy(XF ,  80.) GCPz(XF ,  80.,-theta))
                                                      
  arc B2rdf  B1rdf  (GCPx(XF ,  10., theta) GCPy(XF ,  10.) GCPz(XF ,  10., theta))   
  arc B2rdb  B1rdb  (GCPx(XF ,  10.,-theta) GCPy(XF ,  10.) GCPz(XF ,  10.,-theta))
);
 
patches
(
     wedge front
     (    
           (A1ldf A1rdf A1rtf A1ltf) //#A1
           
           (A1ltf A1rtf B1rdf B1rtf) //#B1
           (A1rdf B2rdf B1rdf A1rtf) //#B2
     )     
           

     wedge back
     (
           (A1ldb A1rdb A1rtb A1ltb) //#A1
           
           (A1ltb A1rtb B1rdb B1rtb) //#B1
           (A1rdb B2rdb B1rdb A1rtb) //#B2
     )
     
     patch side
     (            
            (B1rdf B1rdb B1rtb B1rtf) //#C1
            (B2rdf B2rdb B1rdb B1rdf) //#C2
     )

     empty axis
     (
           (A1ltb A1ltf B1rtf B1rtb)
           (A1ldb A1ldf A1ltf A1ltb)
     )
);   
     

mergePatchPairs
(
);                       

//// cell width at Xi:
//cw_Xi
//// meaning a timestep of...
//calc(0.4*cw_Xi/200)
//// ... for 200 m/s at smallest cell and maxCo=0.4


