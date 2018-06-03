/*
3-RaederKoppelGetriebe

Autor:		Manfred Morgner
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike
----------------
1. stirnrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel = 20, schraegungswinkel = 0)

Autor:		Dr Jörg Janssen
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike

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
al= 25;         // A-lever length
bl= 80;         // B-lever length
cl= 90;         // C-lever length

explosion=gh*0; // explosion distance ( *0 = not exploded )
eps=.001;

M=4;            // modulo
ZG=19.5;        // cog size

za=22/M*4;      // gear diameter at point A'
zc=cl/2/M*4-za; // gear diameter at point B'
zb=bl/2/M*4-zc; // gear diameter at point B

C=true;         // if true, lever C appears
ob=10;          // gear angle offset at point B'
oc= 0;          // gear angle offset at point C

wa=360*$t;      // A-lever angle (if animated)
x=al*cos(wa);   // x-position of point A'
y=al*sin(wa);   // y-position of point A'

e=sqrt(pow(x+gl, 2) + pow(y, 2));

w1=acos((-pow(bl,2) + pow(e,2) + pow(cl,2))/(2*e*cl));
w2=asin(y/e);
w3=acos((-pow(cl,2) + pow(e,2) + pow(bl,2))/(2*e*bl));

// ground lever
translate([ 0, 0,  0])
    {
    translate([ 0, 0, -6*explosion])
        Riegel4(gl=gl);
    }


// A-Lever
translate([gl, 0, gh])
    rotate([0, 0, 360*$t+0])
        translate([ 0, 0, -2*explosion])
            {
//          difference(){
                translate([0,0,eps])
                    Riegel1(gl=al, p=false)
                ;
// translate([0,0,-10]) cube([40,40,40]);}
            // A' gear
            translate([al, 0, gh])
                rotate([0, 0, 0*-360*$t])
                    {
                    color("blue",  alfa)
                        stirnrad(M, za, gh, gi+.7, ZG, 0)
                        ; 
//                    color("white", alfa) 
//                        translate([al, 0, gh])      
//                            cylinder(d=gi/2, h=5*gh, center=true)
//                            ; 
                    }
            }


wb=-w3+w2; // B-Lever angle

// B-Lever
translate([0, 0, gh])
    rotate([0, 0, -w3+w2])
        translate([ 0, 0, -3*explosion]) 
            {
            Riegel1(gl=bl);
            translate([ 0, 0, 1*explosion]) 
            difference()
                {
                translate([0,0,gh])
                    rotate([0, 0, zc/zb*(za/zc*(wa-wc)+wb-wc)+ob])
                        color("green", alfa)
                            stirnrad(M, zb, gh, gi+.7, ZG, 0);
                translate([ 0, 0,  2*gh+2])
                    cylinder(d=gi+4, h=gh, center=true);
                }
            }

//// demo part (for demonstration of in-out-relation)
//translate([0, 70, 2*gh])
//    rotate([0, 0, -wb/za*zb]) 
//        {
//        rotate([0, 0, -(zc/zb*(za/zc*(wa-wc)+wb-wc) )/za*zb +031])
//            {
//            color("blue",  alfa)
//                stirnrad(M, za, gh, gi+.7, ZG, 0); 
////          color("white", alfa) 
////              translate([al, 0, gh])      
////                  cylinder(d=gi/2, h=5*gh, center=true)
////                  ; 
//            }
//        }


wc=+w1+w2; // C-Lever angle

// C-Lever
translate([gl+x, y, 3*gh])
    rotate([0, 180, +w1+w2])
        {
        translate([0, 0, -gh])
            translate([ 0, 0, -3*explosion])
if ( C )        Riegel3(gl=cl)
            ;

        // B' gear
        translate([cl,0,0])
            rotate([0, 0, za/zc*(wa-wc)+oc])
                color("RosyBrown", alfa)
                    stirnrad(M, zc, gh, gi+.7, ZG, 0)
                    ;
        }

di=8;

module Riegel1(gl=100, p=true) {
    color("royalblue", .75)
    translate([0, 0, gh/2]) { 
        difference() {
            hull() {
                cylinder(d=gd, h=gh, center=true);
                translate([gl, 0, 0])
                    cylinder(d=gd, h=gh, center=true);
                }
            cylinder(d=gi+.7, h=gh+1, center=true); 

            translate([gl, 0, 0])
                cylinder(d=gi+.7, h=gh+1, center=true);

            translate([0, 0,  gh-3])
                cylinder(d=gi+4, h=gh, center=true);

            if ( p )
                translate([0, 0, -gh+3])
                    cylinder(d=gi+4, h=gh, center=true);

            if ( p )
                translate([gl, 0,  gh-3])
                    cylinder(d=gi+4, h=gh, center=true);
            translate([gl, 0, -gh+3])
                cylinder(d=gi+4, h=gh, center=true);
            }
        }
    }

module Riegel2(gl=100) {
    translate([0, 0, gh/2]) {
        difference() {
            union() {
                hull() {
                    cylinder(d=gd, h=gh, center=true);
                    translate([gl, 0, 0])
                        cylinder(d=gd, h=gh, center=true);
                    }
                translate([0, 0, gh])
                    cylinder(d=gi, h=gh,   center=true);
                translate([0, 0, gh+3])
                    cylinder(d1=gi+2, d2=gi+1, h=2,   center=true);
                
                translate([gl, 0, 0]) {
                    translate([0, 0, gh])
                        cylinder(d=gi, h=gh,   center=true);
                    translate([0, 0, gh+3])
                        cylinder(d1=gi+2, d2=gi+1, h=2,   center=true);
                }
            }
            translate([0, 0, gh+d/2]) {
                cube([3, gd, gh+d], center=true);
                cube([gd, 3, gh+d], center=true);
                cylinder(d1=gi-5, d2=gi-2, h=gh+d,   center=true);
            }
            cylinder(d=gi-5, h=gh+1,   center=true);

            translate([gl, 0, 0]) {
                translate([0, 0, gh+d/2]) {
                    cube([3, gd, gh+d], center=true);
                    cube([gd, 3, gh+d], center=true);
                    cylinder(d1=gi-5, d2=gi-2, h=gh+d,   center=true);
                }
                    cylinder(d =gi-5, h=gh+1,   center=true);
            }
        }
    }

}


module Riegel3(gl=100) {
    color("magenta", 1.75)
    translate([0, 0, gh/2]) {
        difference() {
            union() {
                hull() {
                    cylinder(d=gd, h=gh, center=true);
                    translate([gl, 0, 0])
                        cylinder(d=gd, h=gh, center=true);
                    }
                m1();
                translate([gl, 0, 0]) m1();
            }
            m2();
            translate([gl, 0, 0]) m2();
        }
    }
    module m1(f=0) {
        translate([0, 0, gh])
            cylinder(d=gi, h=gh+gh+gh,   center=true);
        translate([0, 0, gh*2+3.5])
            cylinder(d1=gi+2, d2=gi+1, h=3,   center=true);
    }
    module m2(f=0) {
       translate([0, 0, gh+d+gh/2]) {
             rotate([90])
             hull() {
                cylinder(d=3, h=gd, center=true);
                translate([0, gh, 0])
                    cylinder(d=3, h=gd, center=true);
                }
             rotate([90,0,90])
             hull() {
                cylinder(d=3, h=gd, center=true);
                translate([0, gh, 0])
                    cylinder(d=3, h=gd, center=true);
                }
                cylinder(d1=gi-5, d2=gi-2, h=gh+gh-d, center=true);
        }
    }
}

module Riegel4(gl=100) {
    color("cyan", 1)
    translate([0, 0, gh/2]) {
        difference() {
            union() {
                hull() {
                    cylinder(d=gd, h=gh, center=true);
                    translate([gl, 0, 0])
                        cylinder(d=gd, h=gh, center=true);
                    }
                m1(f=1);
                translate([gl, 0, 0]) m1();
            }
            m2(f=1);
            translate([gl, 0, 0]) m2();
        }
    }
    module m1(f=0) {
        translate([0, 0, gh/2+gh/2*f])
            cylinder(d=gi, h=2*gh+f*gh, center=true);
        translate([0, 0, gh+f*gh+3.5])
            cylinder(d1=gi+2, d2=gi+1, h=3, center=true);
    }
    module m2(f=0) {
        translate([0, 0, gh/2+d/2+f*gh]) {
        translate([0,0,0+1]) {
             rotate([90])
             hull() {
                cylinder(d=3, h=gd, center=true);
                translate([0, gh, 0])
                    cylinder(d=3, h=gd, center=true);
                }
             rotate([90,0,90])
             hull() {
                cylinder(d=3, h=gd, center=true);
                translate([0, gh, 0])
                    cylinder(d=3, h=gd, center=true);
                }
        }
        translate([0,0,1])
            cylinder(d1=gi-5, d2=gi-2, h=gh+gh-d, center=true);
        }
       // translate([10, 0, 0]) cube([20, gd, gh*5+d], center=true);
       // cylinder(d=gi-5, h=gh+1,   center=true);
    }
}
