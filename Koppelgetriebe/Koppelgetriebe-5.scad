/*
Cosinussatz:
a = √ (b2 + c2 - 2 b c cos α)


Aufgelöst nach Winkeln:
α = arccos [(-a2 + b2 + c2)/(2 b c)]


Sinussatz:
a / sin α = b / sin β = c / sin γ

*/
use <../zapfen-5.scad>

$fn=164;

d=1;

gd= 30; gi= 20; gh= 8;
gl= 50; // a
al= 30; // b
bl= 45; // d
cl= 50; // c
// a+b < c+d

gh=5;
explosion=2*gh*0;

//                                         | |
//  A |_| - B |^| - C ||_|| - D ||^|| - E ||_|| - F ||^|| - G | |
//                                                   | |

color("green", .75)
translate([ 0, 0,  0-explosion])              lever(gl = gl, T = "CC");
color("royalblue", .75)
translate([gl, 0, gh]) rotate([0, 0, 360*$t]) lever(gl = al, T = "BA");

x=al*cos(360*$t);
y=al*sin(360*$t);
e=sqrt(pow(x+gl, 2) + pow(y, 2));

w1=acos((-pow(bl,2) + pow(e,2) + pow(cl,2))/(2*e*cl));
w2=asin(y/e);
w3=acos((-pow(cl,2) + pow(e,2) + pow(bl,2))/(2*e*bl));

color("magenta", .75)
translate([   0, 0,   gh]) rotate([0,   0, -w3+w2])   lever(gl = bl, T = "BA");
color("cyan", .75)
translate([gl+x, y, 3*gh+explosion]) rotate([0, 180, +w1+w2]) { lever(gl = cl, T = "CC");
/*
    difference()
        {
        translate([ cl/2, -30,  3/2]) {
            cube([7.5, 60, 3], center=true);
        translate([ 0, -30,  -gh/2]) 
            cylinder(d=12, h=12);
        }
        translate([ cl/2, -64, -gh/2+3/2]) translate([0,0, -1/2]) cylinder(d=12, h=12+1); 
        }
*/
    }
