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
define(wd, 0.0249452627389)              // distance of bubble center to rigid wall (only for comparison)
define(Rmax, 0.0002)
define(X, calc(1.5 * Rmax))                     // bubble domain im (domain B)
define(XF,calc(166.301751592 * Rmax))              // mesh end (domain C)
define(cellsize, 8e-06)      // angular number of cells in B domain




//################### domain A
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

    (                   -X              0                     X)      vlabel(Aldf)
    (                   -X              0                    -X)      vlabel(Aldb)
                                                             
    (                    X              0                     X)      vlabel(Ardf)
    (                    X              0                    -X)      vlabel(Ardb)
    
    (                   -X              Y                     X)      vlabel(Altf)
    (                   -X              Y                    -X)      vlabel(Altb)
    
    (                    X              Y                     X)      vlabel(Artf)
    (                    X              Y                    -X)      vlabel(Artb)
    
    (                  -XF             XF                    XF)      vlabel(Bltf)
    (                  -XF             XF                   -XF)      vlabel(Bltb)
                                                             
    (                   XF             XF                    XF)      vlabel(Brtf)
    (                   XF             XF                   -XF)      vlabel(Brtb)
    
    (                  -XF              0                    XF)      vlabel(Bldf)
    (                  -XF              0                   -XF)      vlabel(Bldb)
                                                             
    (                   XF              0                    XF)      vlabel(Brdf)
    (                   XF              0                   -XF)      vlabel(Brdb)
);
 
blocks
(
  hex (Aldf Ardf Ardb Aldb  Altf Artf Artb Altb)  (calc(2*AnumX) calc(2*AnumX) AnumY) simpleGrading (1 1 1) //# A
                  
  //# B           
  hex (Bldf Brdf Ardf Aldf  Bltf Brtf Artf Altf)  (calc(2*AnumX) Bnum          AnumY) simpleGrading (            1    calc(1./Bgrd)     1) //# B1
  hex (Bldf Aldf Aldb Bldb  Bltf Altf Altb Bltb)  (Bnum          calc(2*AnumX) AnumY) simpleGrading (calc(1./Bgrd)                1     1) //# B2
  hex (Bldb Aldb Ardb Brdb  Bltb Altb Artb Brtb)  (Bnum          calc(2*AnumX) AnumY) simpleGrading (calc(1./Bgrd)                1     1) //# B3
  hex (Ardf Brdf Brdb Ardb  Artf Brtf Brtb Artb)  (Bnum          calc(2*AnumX) AnumY) simpleGrading (         Bgrd                1     1) //# B4
  hex (Altf Artf Artb Altb  Bltf Brtf Brtb Bltb)  (calc(2*AnumX) calc(2*AnumX) Bnum ) simpleGrading (            1                1  Bgrd) //# B5
);


edges                  
(
);
 
patches
(
     patch side
     (            
            (Bldf Brdf Brtf Bltf) //#B1
            (Bldf Bltf Bltb Bldb) //#B2
            (Bldb Bltb Brtb Brdb) //#B3
            (Brdb Brtb Brtf Brdf) //#B4
            (Bltf Brtf Brtb Bltb) //#B5
     )
     
     patch wall
     (            
            (Ardf Aldf Aldb Ardb) //#A
            (Brdf Bldf Aldf Ardf) //#B1
            (Bldf Bldb Aldb Aldf) //#B2
            (Aldb Bldb Brdb Ardb) //#B3
            (Ardf Ardb Brdb Brdf) //#B4
     )
     
     //patch test
     //(
     //       (Ardf Aldf Aldb Ardb) //#d
     //       (Altf Artf Artb Altb) //#t
     //       (Aldf Ardf Artf Altf) //#f
     //       (Aldf Altf Altb Aldb) //#l
     //       (Aldb Altb Artb Ardb) //#b
     //       (Ardb Artb Artf Ardf) //#r
     //       
     //       //(Aldf Altf Artf Ardf) //#B1b
     //       //(Bldf Aldf Ardf Brdf) //#B1d
     //       //(Bldf Brdf Brtf Bltf) //#B1f
     //       //(Bldf Bltf Altf Aldf) //#B1l
     //       //(Bltf Brtf Artf Altf) //#B1t
     //       //(Brdf Ardf Artf Brtf) //#B1r
     //)
);   
     

mergePatchPairs
(
);