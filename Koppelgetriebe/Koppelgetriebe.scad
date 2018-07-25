/*
Cosinussatz:
a = √ (b2 + c2 - 2 b c cos α)


Aufgelöst nach Winkeln:
α = arccos [(-a2 + b2 + c2)/(2 b c)]

Sinussatz:
a / sin α = b / sin β = c / sin γ

*/
use <../zapfen-2.scad>

$fn=164;

d=1;

gd= 30; gi= 20; gh= 10;
gl=100;
al= 30;
bl= 80;
cl= 90;


gh=7.5;
explosion=2*gh*0;



translate([ 0, 0,  0-explosion])              lever(gl = gl, gh=gh, h1=gh, h2=gh);
color("royalblue", .75)
translate([gl, 0, gh]) rotate([0, 0, 360*$t]) lever(gl = al, gh=gh, h1=0,  h2=0);

x=al*cos(360*$t);
y=al*sin(360*$t);
e=sqrt(pow(x+gl, 2) + pow(y, 2));

w1=acos((-pow(bl,2) + pow(e,2) + pow(cl,2))/(2*e*cl));
w2=asin(y/e);
w3=acos((-pow(cl,2) + pow(e,2) + pow(bl,2))/(2*e*bl));

color("royalblue", .75)
translate([   0, 0,   gh]) rotate([0,   0, -w3+w2])   lever(gl = bl, gh=gh, h1=0,  h2=0);
translate([gl+x, y, 3*gh+explosion]) rotate([0, 180, +w1+w2]) { lever(gl = cl, gh=gh, h1=gh, h2=gh );
    translate([ cl/2, -30,  gh/2]) {
        cube([10, 60, gh], center=true);
    translate([ 0, -30,  -gh/2]) 
        cylinder(d=10, h=gh*3); }
    }
