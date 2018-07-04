/*
3-RaederKoppelGetriebe

Autor:          Manfred Morgner
Lizenz:         Creative Commons - Attribution, Non Commercial, Share Alike
----------------
1. stirnrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel = 20, schraegungswinkel = 0)

Autor:          Dr Jörg Janssen
Lizenz:         Creative Commons - Attribution, Non Commercial, Share Alike

    Erlaubte Module nach DIN 780:
    0.05 0.06 0.08 0.10 0.12 0.16
    0.20 0.25 0.3  0.4  0.5  0.6
    0.7  0.8  0.9  1    1.25 1.5
    2    2.5  3    4    5    6
    8    10   12   16   20   25
    32   40   50   60

*/
/*
    Cosinussatz:            a = √ (b2 + c2 - 2 b c cos α)
    Aufgelöst nach Winkeln: α = arccos [(-a2 + b2 + c2)/(2 b c)]

    Sinussatz:              a / sin α = b / sin β = c / sin γ
*/

use <Getriebe.scad>

$fn=164;        // faces of a cylinder

d=1;
alfa=1;         // make certain things transparent

gd= 30;         // lever diameter
gi= 20;         // link inner diameter
gh= 10;         // lever height

gl=120;         // ground lever length
al= 40;         // A-lever length
bl= 80;         // B-lever length
cl= 90;         // C-lever length

explosion=gh*0; // explosion distance ( *0 = not exploded )
modelCut=false; // cuts the model open
simple=false;   // alternative stirnrad presentation

M=4;            // modulo
ZG=19.5;        // cog size

za=20/M*4;      // gear diameter at point A'
zc=cl/2/M*4-za; // gear diameter at point B'
zb=bl/2/M*4-zc; // gear diameter at point B

C=true;         // if true, lever C appears
ob=12;          // gear angle offset at point B'
oc= 6;          // gear angle offset at point C

wa=360*$t;      // A-lever angle (if animated)
x=al*cos(wa);   // x-position of point A'
y=al*sin(wa);   // y-position of point A'

e=sqrt(pow(x+gl, 2) + pow(y, 2));

w1=acos((-pow(bl,2) + pow(e,2) + pow(cl,2))/(2*e*cl));
w2=asin(y/e);
w3=acos((-pow(cl,2) + pow(e,2) + pow(bl,2))/(2*e*bl));


difference(){
    union(){
// ground lever
translate([ 0, 0,  0])
    {
    translate([ 0, 0, -4*explosion])
        Riegel1(gl=gl, klpos=3);
    }


// A-Lever
translate([gl, 0, gh])
    rotate([0, 0, 360*$t+0]) 
        translate([ 0, 0, -2*explosion]) 
            {
            Riegel1(gl=al, klpos=0);
            translate([al, 0, gh])
                rotate([0, 0, 0*-360*$t])
                    {
                    color("blue",  alfa)
                        {
                        if (simple) difference() {
                            cylinder(r=2*za, h=gh);
                            cylinder(d=ki, h=4*gh, center=true);}
                        else
                            stirnrad(M, za, gh, ki, ZG, 0); 
                        translate([-al, 0, -gh])
                            Stab(d=ki, h=2*gh, center=true)
                        ;
   rotate([90, 0, 180-360*$t])
   translate([0, 70, 0])
   text(text=str(round(360*$t), "°"), size=gh*2, halign=center);
                        }
            color("white", alfa) 
                translate([0, 0, gh*2]) 
                    translate([ 0, 0, -6*explosion]) 
                        Stab(d=ki, h=5*gh, center=true)
                        ; 
                    }
            }


wb=-w3+w2; // B-Lever angle

// B-Lever
translate([0, 0, gh])
    rotate([0, 0, -w3+w2])
        translate([ 0, 0, -2*explosion]) 
            {
            translate([ 0, 0, -1*explosion])
                Riegel1(gl=bl);
            difference()
                {
                translate([0,0,gh])
                    rotate([0, 0, zc/zb*(za/zc*(wa-wc)+wb-wc)+ob])
                    color("green", alfa)
                        {
                        if (simple) difference() {
                            cylinder(r=2*zb, h=gh);
                            cylinder(d=ki, h=3*gh, center=true);}
                        else
                            stirnrad(M, zb, gh, ki, ZG, 0);
                        translate([ 0, 0, -7*explosion])
                            Stab(d=ki, h=4*gh, center=true)
                        ;
   rotate([90, 0, -45+225-(zc/zb*(za/zc*(wa-wc)+wb-wc)+ob)-(-w3+w2)])
   translate([0, 90, 0])
   text(text=str(round(zc/zb*(za/zc*(wa-wc)+wb-wc)), "°"), size=gh*2, halign=center);
                        }
//                translate([0, 0, 1*gh+kh/2]) bearing(true);
                }
//            translate([0, 0, 1*gh+kh/2]) bearing(false);
            }


//// output gear (for demonstration of in-out-relation)
//translate([0, 70, 2*gh])
//    rotate([0, 0, -wb/za*zb]) translate([ 0, 0, -4*explosion])
//        {
//        rotate([0, 0, -( zc/zb*(za/zc*(wa-wc)+wb-wc) )/za*zb +031])
//        {
//        color("blue",  alfa)
//            stirnrad(M, za, gh, gi, ZG, 0);
////        // visualisation stick
////        color("white", alfa) 
////            translate([al, 0, gh])      
////                Stab(d=gi/2, h=5*gh, center=true)
////            ; 
//        }
//    }


wc=+w1+w2; // C-Lever angle

// C-Lever
translate([gl+x, y, 3*gh])
    rotate([0, 180, +w1+w2])
        {
        translate([0, 0, -gh])
            translate([ 0, 0, -1*explosion]) 
if ( C )        Riegel1(gl=cl);
//          translate([ 0, 0, 2*gh]) bearing();
    
        // B' gear
        translate([cl,0,0])
            rotate([0, 0, za/zc*(wa-wc)])
                color("RosyBrown", alfa)
                    {
                    if (simple) difference() {
                            cylinder(r=2*zc, h=gh);
                            cylinder(d=ki, h=3*gh, center=true);}
                    else
                        stirnrad(M, zc, gh, ki, ZG, 0); 
                    translate([ 0, 0, 8*explosion])
                        Stab(d=ki, h=4*gh, center=true)
                    ;
   rotate([-90, 0, -(za/zc*(wa-wc)-(+w1+w2))])
   translate([0, 70, 0])
   text(text=str(round(za/zc*(wa-wc)), "°"), size=gh*2, halign=center);
                    }
        }

        } // union
    if (modelCut) translate([ -40, 0, -10]) cube([240,100,90]);
    } // difference



module Stab(d, h, center) {
    intersection(){
        cylinder(d=d, h=h, center=center);
        cube([d/6*5, d/6*5, h], center=center);
        }
    }

// gd is 30
kd=gd-5;        // bearing outer diameter
ki=12;          // bearing inner diameter
kh=8;           // bearing height
eps=.001;       // epsilon
module bearing(show_hull=false, klcut=false) {
    
    if (show_hull == false)
        {   color("silver", 1)
                if ( explosion == 0 )
                    difference(){
                        cylinder(d=kd, h=kh,     center=true);
                        cylinder(d=ki, h=kh+eps, center=true);}
                
        }
    else
        {
            color("gold", 1)
                cylinder(d=kd+eps, h=kh+eps, center=true);
                if (klcut) cylinder(d=(kd+ki)/2, h=gh+kh+gh, center=true);
        }
    }


module Riegel1(gl=100, klpos=3, klcut=true) {
    kladj=gh-kh/2-gh/2+eps;
    translate([0, 0, gh/2]) { 
        difference() {
            color("royalblue", alfa)
                hull() {
                    cylinder(d=gd, h=gh, center=true);
                    translate([gl, 0, 0])
                        cylinder(d=gd, h=gh, center=true);
                        }

                if (klpos >= 2) { translate([gl, 0, kladj]) bearing(true, klcut); }
                if (klpos == 1 || klpos == 3) { translate([ 0, 0, kladj]) bearing(true, klcut); }
                }
            if (klpos >= 2) translate([gl, 0, kladj+eps]) bearing(false);
            if (klpos == 1 || klpos == 3) translate([ 0, 0, kladj+eps]) bearing(false);
            }
 }
