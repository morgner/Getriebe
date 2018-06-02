/*

1. stirnrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel = 20, schraegungswinkel = 0)

Autor:		Dr Jörg Janssen
Stand:		20. Juni 2016
Version:	1.3
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
Cosinussatz:
a = √ (b2 + c2 - 2 b c cos α)

Aufgelöst nach Winkeln:
α = arccos [(-a2 + b2 + c2)/(2 b c)]

Sinussatz:
a / sin α = b / sin β = c / sin γ

*/

use <Getriebe.scad>

$fn=164;

d=1;
alfa=1;

gd= 30; gi= 20; gh= 10;
gl=120;
al= 30;
bl= 80;
cl= 90;

expl= gh *1;


M=4; ZG=19.5;
za=21/M*4;      // am Gehäusepunkt A
zc=cl/2/M*4-za; // an der Koppel
zb=bl/2/M*4-zc; // am Gehäuseounkt B

x=al*cos(360*$t);
y=al*sin(360*$t);
e=sqrt(pow(x+gl, 2) + pow(y, 2));

w1=acos((-pow(bl,2) + pow(e,2) + pow(cl,2))/(2*e*cl));
w2=asin(y/e);
w3=acos((-pow(cl,2) + pow(e,2) + pow(bl,2))/(2*e*bl));

translate([ 0, 0,  0])
    {
    translate([ 0, 0, -4*expl])
        Riegel1(gl=gl, klpos=3);
    }


wa=360*$t;

translate([gl, 0, gh])
    rotate([0, 0, 360*$t+0]) 
        translate([ 0, 0, -2*expl]) 
            {
            Riegel1(gl=al, klpos=0);
            translate([al, 0, gh])
                rotate([0, 0, 0*-360*$t])
                    {
                    color("blue",  alfa)
                        {
                        stirnrad(M, za, gh, ki, ZG, 0); 
                        translate([-al, 0, -gh])
                            Stab(d=ki, h=2*gh, center=true);
                        }

            color("white", alfa) 
                translate([0, 0, gh*2]) 
                    translate([ 0, 0, -6*expl]) 
                        Stab(d=ki, h=5*gh, center=true)
                        ; 
                    }
            }

wb=-w3+w2;
            
translate([0, 0, gh])
    rotate([0, 0, -w3+w2])
        translate([ 0, 0, -2*expl]) 
            {
            translate([ 0, 0, -1*expl])
                Riegel1(gl=bl);
            difference()
                {
                translate([0,0,gh])
                    rotate([0, 0, zc/zb*(za/zc*(wa-wc)+wb-wc)+12])
                    color("green", alfa)
                        {
                        stirnrad(M, zb, gh, gi, ZG, 0);
                        translate([ 0, 0, -7*expl])
                            Stab(d=ki, h=4*gh, center=true);
                        }
                translate([0, 0, 1*gh+kh/2]) KL(true);
                }
            translate([0, 0, 1*gh+kh/2]) KL(false);
            }
            


//// demo part
//translate([0, 70, 2*gh])
//    rotate([0, 0, -wb/za*zb]) translate([ 0, 0, -4*expl])
//        {
//        rotate([0, 0, -( zc/zb*(za/zc*(wa-wc)+wb-wc) )/za*zb +031])
//        {
//        color("blue",  alfa)
//            stirnrad(M, za, gh, gi, ZG, 0); 
////        color("white", alfa) 
////            translate([al, 0, gh])      
////                Stab(d=gi/2, h=5*gh, center=true)
////            ; 
//        }
//    }


wc=+w1+w2;

translate([gl+x, y, 3*gh])
    rotate([0, 180, +w1+w2])
        {
        translate([0, 0, -gh])
            translate([ 0, 0, -1*expl]) 
        Riegel1(gl=cl);
//          translate([0, 0, 2*gh]) KL();
    

        translate([cl,0,0])
            rotate([0, 0, za/zc*(wa-wc)])
                color("RosyBrown", alfa)
                    {
                    stirnrad(M, zc, gh, ki, ZG, 0); 
                    translate([ 0, 0, 8*expl])
                        Stab(d=ki, h=4*gh, center=true);
                    }
        }



module Stab(d, h, center) {
    intersection(){
        cylinder(d=d, h=h, center=center);
        cube([d/6*5, d/6*5, h], center=center);
        }
    } 
// gd is 30
kd=gd-5; ki=12; kh=8; eps=.001;
module KL(show_hull=false, klcut=false) {
    
    if (show_hull == false)
        {   color("silver", 1)
                if ( expl == 0 )
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

                if (klpos >= 2) { translate([gl, 0, kladj]) KL(true, klcut); }
                if (klpos == 1 || klpos == 3) { translate([ 0, 0, kladj]) KL(true, klcut); }
                }
            if (klpos >= 2) translate([gl, 0, kladj+eps]) KL(false);
            if (klpos == 1 || klpos == 3) translate([ 0, 0, kladj+eps]) KL(false);
            }
 }
