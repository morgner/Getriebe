/*
3-RaederKoppelGetriebe

Autor:		Manfred Morgner
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike

    Cosinussatz:            a = √ (b2 + c2 - 2 b c cos α)
    Aufgelöst nach Winkeln: α = arccos [(-a2 + b2 + c2)/(2 b c)]

    Sinussatz:              a / sin α = b / sin β = c / sin γ

----------------
1. stirnrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel = 20, schraegungswinkel = 0)

Autor:		Dr Jörg Janssen
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike

    Erlaubte Module nach DIN 780:
    0.05 0.06 0.08 0.10 0.12 0.16 0.20 0.25 0.3  0.4  0.5  0.6 0.7  0.8  0.9
    1  1.25  1.5  2  2.5  3  4  5  6  8  10  12  16  20  25  32  40  50  60

*/

use <Getriebe.scad>
use <../zapfen-5.scad>
//use <Zahnrad-5.scad>

$fn=64;          // faces of a cylinder

d=1;
alfa=.7;         // make certain things transparent

gd= 30;         // lever diameter
gi=  15.4;      // link inner diameter
gh=  6;         // lever height

gl=120/2;         // ground lever length
al= 25/1.5;       // A-lever length
bl= 80/2;         // B-lever length
cl= 90/2;         // C-lever length

C=true;         // if true, lever C appears
oa= 4;           // gear angle offset at point A
ob= 5;           // gear angle offset at point B
oc= 0;           // gear angle offset at point C

ca="blue";
cb="green";
cc="orange";

explosion=gh*.75*0; // explosion distance ( *0 = not exploded )
eps=.001;

M=1;            // modulo
ZG=19.5/2;      // cog size

za=22/M*4/2;    // gear diameter at point A'
zc=cl/2/M*4-za; // gear diameter at point B'
zb=bl/2/M*4-zc; // gear diameter at point B

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
//                                         | |
//  A |_| - B |^| - C ||_|| - D ||^|| - E ||_|| - F ||^|| - G | |
//                                                   | |
    translate([ 0, 0, -6*explosion]) color("cyan", 1) lever(gl, "EC");
    }


// A-Lever *********************************

translate([gl, 0, gh])
    rotate([0, 0, 360*$t+0])
        translate([ 0, 0, -2*explosion])
            {
            translate([0,0,eps])
            color("gold", .75) lever(gl=al, T="BA");
            // A' gear
            difference()
                {
                translate([al, 0, gh])
                    rotate([0, 0, 0*-360*$t +oa])
                        color(ca,  alfa)
                            {
                            stirnrad(M, za, gh, 15.4, ZG, 0);
                            }
                translate([ al, 0,  gh ]) B("H");
                }
            }

wb=-w3+w2; // B-Lever angle *********************************

// B-Lever
rwo=0;
translate([0, 0, gh])
    rotate([0, 0, -w3+w2])
        translate([ 0, 0, -3*explosion]) 
            {
            color("royalblue", .75) lever(gl=bl, T="GA");
            translate([ 0, 0, 1*explosion]) 
            difference()
                {
                translate([0,0,gh])
                    rotate([0, 0, zc/zb*(za/zc*(wa-wc)+wb-wc)+ob])
                        color(cb, alfa)
                            {
                            stirnrad(M, zb, gh, 0, ZG, 0);
                            }
                translate([ 0, 0, gh+6 ]) rotate([180,0,0]) B("A");
                }
            }

wc=+w1+w2; // C-Lever anglee *********************************

// C-Lever
translate([gl+x, y, 3*gh])
    rotate([0, 180, +w1+w2])
        {
        translate([0, 0, -gh])
            translate([ 0, 0, -3*explosion])
                color("magenta", 1.75)
                    difference()
                        {
                        if ( C ) lever(gl=cl, T="EE");
                        translate([0, 0, -gh+3]) cylinder(d=4, h=gh);
                        }
                    // B' gear
                    difference()
                        {
                        translate([cl,0,0])
                            rotate([0, 0, za/zc*(wa-wc)+oc])
                                color(cc, alfa)
                                    {
                                    stirnrad(M, zc, gh, 15.4, ZG, 0);
//module Gear(modul, zahnzahl, hoehe=6, bohrung=1, eingriffswinkel = ZG, schraegungswinkel = 0)
                                   // Gear(M, zc, speichen=5);
                                    }
                        translate([cl, 0, gh-6 ]) B("H");
                        }
        }
color("magenta", 1.75) translate([gl, cl, 0]) cylinder(d=4, h=gh);
