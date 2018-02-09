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
define(Xi, 80e-6)                   // core rim (domain A)
define(Xir,calc(sqrt(2)*Xi*0.86))   // core rim points distance to origin on 45 degrees
define(X, 80e-3)                     // bubble domain im (domain B)
define(XF,calc(1.4*X))              // mesh end (domain C)
define(Bnum90deg, 180)      // angular number of cells in B domain



//################### domain A
define(Bnum45deg, calc(round(Bnum90deg/2.)))
define(Cnum45deg, Bnum45deg)
define(Anum, Bnum45deg)
//# cell width at x=Xi
define(cw_Xi, calc(Xi/Anum))

//################### domain B
//# length of B domain
define(l_B, calc(X-Xi)) 
//# grading of B domain
define(Bgrd,calc(X/Xi)) 
//# computing radial number of cells
define(logarg, calc((cw_Xi/l_B-1.)/(cw_Xi/l_B*Bgrd - 1.)))
define(_Bnum, calc(1+log(Bgrd)/log(logarg)  ))
define(Bnum, calc(round(_Bnum)))
//# cell width at x=X
define(cw_X, calc(cw_Xi*Bgrd))

//################### domain C
//# same for domain C
define(l_C, calc(XF-X)) 
define(Cgrd,calc(5.25*XF/X)) 
//# we take double the size of the cell in C domain and half the amount of cells in angular direction
//define(cw_X_C, cw_X)
//define(Cnum90deg, Bnum90deg)
//
//define(logargC, calc((cw_X_C/l_C-1.)/(cw_X_C/l_C*Cgrd - 1.)))
//define(_Cnum, calc(1+log(Cgrd)/log(logargC)  ))
define(Cnum, 10) //calc(round(_Cnum)))
define(cw_XF, calc(cw_X_C*Cgrd))

define(theta, calc(90./Bnum90deg/2.))   //# half of opening angle of wedge mesh such that A and B domain have cell ratios 1




//# l=left,r=right,f=front,b=back,t=top,d=down; Teildomänen durchnummeriert von oben nach unten
//# Reihenfolge: domain-nummer-left/right-top/down-front/back
vertices
(
    (                    0              0                     0)      vlabel(origf)
    (                    0              0                     0)      vlabel(origb)
    (                   Xi              0  GCPz(Xi ,   0,theta))      vlabel(A1rdf)
    (                   Xi              0 -GCPz(Xi ,   0,theta))      vlabel(A1rdb)
    (GCPx(Xir, 45., theta) GCPy(Xir, 45.)  GCPz(Xir, 45.,theta))      vlabel(A1rtf)
    (GCPx(Xir, 45., theta) GCPy(Xir, 45.) -GCPz(Xir, 45.,theta))      vlabel(A1rtb)
    (                    0             Xi                     0)      vlabel(A1ltf)
    (                    0             Xi                     0)      vlabel(A1ltb)

    (                    0            -Xi                     0)      vlabel(A2ldf)
    (                    0            -Xi                     0)      vlabel(A2ldb)
    (GCPx(Xir,-45., theta) GCPy(Xir,-45.) GCPz(Xir,-45., theta))      vlabel(A2rdf)
    (GCPx(Xir,-45.,-theta) GCPy(Xir,-45.) GCPz(Xir,-45.,-theta))      vlabel(A2rdb)
    
    (                    0              X                     0)      vlabel(B1rtf)
    (                    0              X                     0)      vlabel(B1rtb)
    (GCPx(X  , 45., theta) GCPy(X  , 45.) GCPz(X  , 45., theta))      vlabel(B1rdf)
    (GCPx(X  , 45.,-theta) GCPy(X  , 45.) GCPz(X  , 45.,-theta))      vlabel(B1rdb)
    
    (GCPx(X  ,  0., theta)              0 GCPz(X  ,   0, theta))      vlabel(B2rdf)
    (GCPx(X  ,  0.,-theta)              0 GCPz(X  ,   0,-theta))      vlabel(B2rdb)
            
    (GCPx(X  ,-45., theta) GCPy(X  ,-45.) GCPz(X  ,-45., theta))      vlabel(B3rdf)
    (GCPx(X  ,-45.,-theta) GCPy(X  ,-45.) GCPz(X  ,-45.,-theta))      vlabel(B3rdb)
            
    (                    0             -X                     0)      vlabel(B4rdf)
    (                    0             -X                     0)      vlabel(B4rdb)
                                          
    (                    0              XF                    0)      vlabel(C1rtf)
    (                    0              XF                    0)      vlabel(C1rtb)
    (GCPx(XF , 45., theta) GCPy(XF , 45.) GCPz(XF , 45., theta))      vlabel(C1rdf)
    (GCPx(XF , 45.,-theta) GCPy(XF , 45.) GCPz(XF , 45.,-theta))      vlabel(C1rdb)
                                               
    (GCPx(XF ,  0., theta)              0 GCPz(XF ,   0, theta))      vlabel(C2rdf)
    (GCPx(XF ,  0.,-theta)              0 GCPz(XF ,   0,-theta))      vlabel(C2rdb)
                                               
    (GCPx(XF ,-45., theta) GCPy(XF ,-45.) GCPz(XF ,-45., theta))      vlabel(C3rdf)
    (GCPx(XF ,-45.,-theta) GCPy(XF ,-45.) GCPz(XF ,-45.,-theta))      vlabel(C3rdb)

    (                    0             -XF                    0)      vlabel(C4rdf)
    (                    0             -XF                    0)      vlabel(C4rdb)

);
 
blocks
(
  hex (origf A1rdf A1rdb origb   A1ltf A1rtf A1rtb A1ltb)  (Anum 1       Anum) simpleGrading (   1 1 1) //# A1
  hex (A2ldf A2rdf A2rdb A2ldb   origf A1rdf A1rdb origb)  (Anum 1       Anum) simpleGrading (   1 1 1) //# A2
                                                                    
  //# B                                                             
  hex (A1rtf B1rdf B1rdb A1rtb   A1ltf B1rtf B1rtb A1ltb)  (Bnum 1  Bnum45deg) simpleGrading (Bgrd 1 1) //# B1
  hex (A1rdf B2rdf B2rdb A1rdb   A1rtf B1rdf B1rdb A1rtb)  (Bnum 1  Bnum45deg) simpleGrading (Bgrd 1 1) //# B2
  hex (A2rdf B3rdf B3rdb A2rdb   A1rdf B2rdf B2rdb A1rdb)  (Bnum 1  Bnum45deg) simpleGrading (Bgrd 1 1) //# B3
  hex (A2ldf B4rdf B4rdb A2ldb   A2rdf B3rdf B3rdb A2rdb)  (Bnum 1  Bnum45deg) simpleGrading (Bgrd 1 1) //# B4
  
  //# C
  hex (B1rdf C1rdf C1rdb B1rdb   B1rtf C1rtf C1rtb B1rtb)  (Cnum 1  Cnum45deg) simpleGrading (Cgrd 1 1) //# C1
  hex (B2rdf C2rdf C2rdb B2rdb   B1rdf C1rdf C1rdb B1rdb)  (Cnum 1  Cnum45deg) simpleGrading (Cgrd 1 1) //# C2
  hex (B3rdf C3rdf C3rdb B3rdb   B2rdf C2rdf C2rdb B2rdb)  (Cnum 1  Cnum45deg) simpleGrading (Cgrd 1 1) //# C3
  hex (B4rdf C4rdf C4rdb B4rdb   B3rdf C3rdf C3rdb B3rdb)  (Cnum 1  Cnum45deg) simpleGrading (Cgrd 1 1) //# C4
);


edges                  
(
  arc C1rdf  C1rtf  (GCPx(XF, 67.5, theta) GCPy(XF, 67.5) GCPz(XF, 67.5, theta))
  arc C1rdb  C1rtb  (GCPx(XF, 67.5,-theta) GCPy(XF, 67.5) GCPz(XF, 67.5,-theta))
      
  arc C2rdf  C1rdf  (GCPx(XF, 22.5, theta) GCPy(XF, 22.5) GCPz(XF, 22.5, theta))   
  arc C2rdb  C1rdb  (GCPx(XF, 22.5,-theta) GCPy(XF, 22.5) GCPz(XF, 22.5,-theta))
      
  arc C3rdf  C2rdf  (GCPx(XF,-22.5, theta) GCPy(XF,-22.5) GCPz(XF,-22.5, theta))
  arc C3rdb  C2rdb  (GCPx(XF,-22.5,-theta) GCPy(XF,-22.5) GCPz(XF,-22.5,-theta))
      
  arc C4rdf  C3rdf  (GCPx(XF,-67.5, theta) GCPy(XF,-67.5) GCPz(XF,-67.5, theta))
  arc C4rdb  C3rdb  (GCPx(XF,-67.5,-theta) GCPy(XF,-67.5) GCPz(XF,-67.5,-theta))



  arc B1rdf  B1rtf  (GCPx( X, 67.5, theta) GCPy(X , 67.5) GCPz( X, 67.5, theta))
  arc B1rdb  B1rtb  (GCPx( X, 67.5,-theta) GCPy(X , 67.5) GCPz( X, 67.5,-theta))
                                                  
  arc B2rdf  B1rdf  (GCPx( X, 22.5, theta) GCPy(X , 22.5) GCPz( X, 22.5, theta))   
  arc B2rdb  B1rdb  (GCPx( X, 22.5,-theta) GCPy(X , 22.5) GCPz( X, 22.5,-theta))
                                                  
  arc B3rdf  B2rdf  (GCPx( X,-22.5, theta) GCPy(X ,-22.5) GCPz( X,-22.5, theta))
  arc B3rdb  B2rdb  (GCPx( X,-22.5,-theta) GCPy(X ,-22.5) GCPz( X,-22.5,-theta))
                                                  
  arc B4rdf  B3rdf  (GCPx( X,-67.5, theta) GCPy(X ,-67.5) GCPz( X,-67.5, theta))
  arc B4rdb  B3rdb  (GCPx( X,-67.5,-theta) GCPy(X ,-67.5) GCPz( X,-67.5,-theta))
);
 
patches
(
     wedge front
     (    
           (origf A1rdf A1rtf A1ltf) //#A1
           (A2ldf A2rdf A1rdf origf) //#A2
           
           (A1ltf A1rtf B1rdf B1rtf) //#B1
           (A1rdf B2rdf B1rdf A1rtf) //#B2
           (A2rdf B3rdf B2rdf A1rdf) //#B3
           (A2ldf B4rdf B3rdf A2rdf) //#B4
           
           (B1rtf B1rdf C1rdf C1rtf) //#C1
           (B1rdf B2rdf C2rdf C1rdf) //#C2
           (B2rdf B3rdf C3rdf C2rdf) //#C3
           (B3rdf B4rdf C4rdf C3rdf) //#C4
     )     
           

     wedge back
     (
           (origb A1rdb A1rtb A1ltb) //#A1
           (A2ldb A2rdb A1rdb origb) //#A2

           (A1ltb A1rtb B1rdb B1rtb) //#B1
           (A1rdb B2rdb B1rdb A1rtb) //#B2
           (A2rdb B3rdb B2rdb A1rdb) //#B3
           (A2ldb B4rdb B3rdb A2rdb) //#B4
           
           (B1rtb B1rdb C1rdb C1rtb) //#C1
           (B1rdb B2rdb C2rdb C1rdb) //#C2
           (B2rdb B3rdb C3rdb C2rdb) //#C3
           (B3rdb B4rdb C4rdb C3rdb) //#C4
     )
     
     patch side
     (            
            (C1rdf C1rdb C1rtb C1rtf) //#C1
            (C2rdf C2rdb C1rdb C1rdf) //#C2
            (C3rdf C3rdb C2rdb C2rdf) //#C3
            (C4rdf C4rdb C3rdb C3rdf) //#C4
     )

     empty axis
     (
           (C4rdf B4rdf B4rdb C4rdb)
           (B4rdb B4rdf A2ldf A2ldb)
           (A2ldb A2ldf origf origb)
           (origb origf A1ltf A1ltb)
           (A1ltb A1ltf B1rtf B1rtb)
           (B1rtb B1rtf C1rtf C1rtb)
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


