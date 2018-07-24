/*
3-RaederKoppelGetriebe

Autor:		Manfred Morgner
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike
----------------
1. stirnrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel = 20, schraegungswinkel = 0)

Autor:		Dr Jörg Janssen
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike

*/

use <Getriebe.scad>
use <zapfen-2.scad>

 fn=180;        // faces of a cylinder
$fn=fn;         // faces of a cylinder

M=4;            // modulo
ZG=19.5;        // cog size

gl=120;         // ground lever length
al= 40;         // A-lever length
bl= 80;         // B-lever length
cl= 90;         // C-lever length

za=22/M*4;      // gear diameter at point A'
zc=cl/2/M*4-za; // gear diameter at point B'
zb=bl/2/M*4-zc; // gear diameter at point B

modul=4;
ZZ=55;
zahnzahl=ZZ/modul*4;
hoehe=7.5;
bohrung=16;

////////////////// CONTROLS BEGIN

simple=false;   // alternative stirnrad presentation
speichen=5;     // Anzahl Speichen in den Zahnrädern (ab 3)

////////////////// CONTROLS END

gh=7.5;

Gear(modul, zahnzahl, hoehe, bohrung);

module Gear(modul, zahnzahl, hoehe, bohrung, eingriffswinkel = 20, schraegungswinkel = 0) {
    difference(){
        if (simple) difference() {
            cylinder(r=2*zahnzahl, h=hoehe);
            cylinder(d=bohrung, h=3*hoehe, center=true);}
        else
            stirnrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel, schraegungswinkel);
        if (speichen > 2) {
            mr=4;
            $fn=40;
            translate([0, 0, hoehe/2])
            difference(){
            union(){ 
                minkowski(){
                    union(){
                        $fn=40;
                        difference(){
                            p=(2*zahnzahl-modul-1);
                            cylinder(r=p-10-mr,         h=hoehe+.1, center=true);
                            cylinder(d=bohrung+18+2*mr, h=hoehe+.2, center=true);
                            q=10+2*mr;
                            steps=speichen; // Anzahl Speichen
                            for (w = [0:360/steps:360-360/steps]) {
                                translate([sin(w)*p/2, cos(w)*p/2, 0]) 
                                    rotate([0,0,-w]) 
                                        cube([q, p, hoehe+.3], center=true);
                                }
                            }
                        }
                    $fn=31;
                    cylinder(r=mr, h=1, center=true);
                    }
                }
            }
        }
    $fn=fn;
    bohrung( gh=gh, h=0, gd= 30, gi=20 );
    }}
