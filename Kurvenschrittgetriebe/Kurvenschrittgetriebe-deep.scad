/*

Sinoide von Bestehorn
f(z) = z−(1/(2π))sin(2πz)
f(z) = z−(sin(2πz)/(2π)) 
f(z) = z−(sin(360z)/(2π))

Übertragung:

https://www.wolframalpha.com/input/?i=z%E2%88%92(1%2F(2%CF%80))sin(2%CF%80z)+for+z+from+0+to+1

Geschwindigkeit:

https://www.wolframalpha.com/input/?i=d%2Fdz+z%E2%88%92(1%2F(2%CF%80))sin(2%CF%80z)+for+z+from+0+to+1

Beschleunigung:

https://www.wolframalpha.com/input/?i=d%2Fdz+d%2Fdz+z%E2%88%92(1%2F(2%CF%80))sin(2%CF%80z)+for+z+from+0+to+1


module Roller(...);

a=90, steps=6, dPinWheel=30, dPin=4, hPin=5, dRoller=40,  diRoller=10, sample=false

    a          Bewegungsphase auf der Walze in Grad
    steps      Anzahl Schritte pro Umdrehung
    dPinWheel  Durchmesser des Mitnehmerkreises
    dPin       Durchmesser der Mitnehmer
    dPinI      Innendurchmesser Mitnehmer Lager
    hPin       Höhe der Zapfen (h/2 im Eingriff)
    dRoller    Durchmesser der Walze
    diRoller   Innenbohrung in Scheibe und Walze
    sample     Scheibe und Zapfen anzeigen

*/

res=.5;      // resolution of looped manipulation
f=13;        // resolution as factor for $f
$fn=16*f;



rotate([0, 360*$t, 0]) Roller(180, // Bewegungsphase auf der Walze in Grad
                               15, // Anzahl Schritte pro Umdrehung
                              160, // Durchmesser des Mitnehmerkreises
                               16, // Durchmesser der Mitnehmer
                                8, // Innendurchmesser Mitnehmer Lager
                               15, // Höhe der Zapfen (h/2 im Eingriff)
                              100, // Durchmesser der Walze
                               40, // Innenbohrung in Scheibe und Walze
                             false);// Scheibe und Zapfen anzeigen

module Roller(a=90, steps=6, dPinWheel=30, dPin=4, dPinI, hPin=5, dRoller=40,  diRoller=10, sample=false) {

    explosion = 10;
    
    ustep=360/steps;    // step angle of the pinwheel
    d=dPin; d1=d; d2=d; h=hPin;     ds=dPinWheel;
    dd=dRoller;                     di=diRoller;

    hd = dPinWheel/2 * sin(ustep)*2 -d;

    pi=3.141592654;
    function uberfn(z) = z<1 ? z-sin(360*z)/(2*pi) :  0;
    function factor(z) = z>1 ? 1+min((360/a-1)/2-abs((360/a-1)/2-z+1),.25) : 1;

    xcs=ds/2-ds/2*(1-cos(ustep));
/*
    difference() { 
        union(){
            rotate([90, 0, 0])
            difference(){
                color("red", .6) cylinder(d=dd+4.84, h=hd+.0, center=true, $fn=18*f);
                color("gray",.6) cylinder(d=dd+2.42, h=hd+.1, center=true, $fn=18*f);
                }
            H1(); 
            }
        K1();
        }
*/

    difference() { 
        H1(); 
        K1();
        }

    intersection() { 
        union(){
            rotate([90, 0, 0])
            difference(){
                color("red", .6) cylinder(d=dd+.84, h=hd+.01, center=true, $fn=18*f);
                color("gray",.6) cylinder(d=dd-.42, h=hd+.1, center=true, $fn=18*f);
                }
            }
        K1();
        }
    
    module H1(){
        rotate([90, 0, 0]){
            difference(){
                cylinder(d=dd, h=hd, center=true, $fn=18*f);
                cylinder(d=di, h=hd+1, center=true, $fn=6);
                cylinder(d=di*.9, h=hd+1, center=true, $fn=9*f);
                }
            }
        }
        
    module K1(){
//        res=9;
        for (rot=[0:res:360-res]) 
            for (s=[180-0:ustep:180+360-ustep]) if ((s>500) || (s<200)) {
                z=rot/a;
                w=ustep*uberfn(z); 
                rotate([0, -rot, 0]) {
                    translate([xcs, 0, dd/2])
                        rotate([0, 0, s+w]) 
                            translate([ds/2, 0, 0])
                                rotate([0, 90, 0]){
//                                    PinF(s==180 ? factor(z) : 1, z<1&&s==180 ? 2.5:0, spiel=0.3);
                                    PinF( 1, 0, 0.3);
/*

        rotate([0, 90, 0])
            cylinder(d1=d1*factor+spiel, d2=d2*factor+spiel, h=h*2, center=true, $fn=6*f);

*/
                                    }
                }
            }
    }


    // Abtrieb
    if (sample) {
        rot=$t;
        z=$t * 360/a;
        w=ustep*uberfn(z);
            rotate([0, -360*$t, 0]) {
             //   color("cyan", .5)
                    Scheibe();
                    for (s=[180+0:ustep:180+360-ustep]) {
                        color(s==180 ? "DodgerBlue" : "lime", .75)
                            translate([xcs, 0, dd/2]) {
                                rotate([0, 0, s+w]) 
                                    translate([ds/2, 0, 1])
     translate([0, 0, 3*explosion])
                                        rotate([0, 90, 0])
                                            {
                                            Pin(dPinI/d);
                                            translate([-2.5, 0, 0])
                                                rotate([0, 90, 0])
                                                    cylinder(d1=d, d2=dPinI+2.5, h=h-5, center=true, $fn=6*f);

if (explosion == 0)
            translate([5+explosion, 0, 0])
               rotate([0, -90, 0])
                cylinder(d=16, h=5, center=true);

                                            }
                                }
                }
            }
        }
        module Scheibe() {
            color("lightblue")
            translate([xcs, 0, dd/2+h/4*3]){
                difference() {
                    union() {
                translate([0, 0, 3*explosion])
                        cylinder(h=h/2, d=ds+d1, center=true);
                translate([0, 0, -h/2])
                    translate([0, 0, 3*explosion])
                            cylinder(h=h/2,   d=di*2,  center=true);
                    }
                translate([0, 0, 3*explosion])
                translate([0, 0, -h/2])
                    cylinder(h=h*2, d=di,    center=true);
                }

           translate([0, 0, -60])
                cylinder(h=120, d=di,    center=true);

           translate([0, 0, -2*(dd/2+h/4*3)])
                cylinder(h=h/2, d=ds+d1, center=true);
            }}

    module Pin(factor=1, offset=0, spiel=0) {
        rotate([0, 90, 0])
            cylinder(d1=d1*factor+spiel, d2=d2*factor+spiel, h=h, center=true, $fn=6*f);
//            cylinder(d=dPinI*factor, h=h, center=true, $fn=6*f);

        if (offset!=0) {
            translate([0, offset, 0])
            rotate([0, 90, 0])
                cylinder(d1=d1*factor+spiel, d2=d2*factor+spiel, h=h, center=true, $fn=6*f);
    //            cylinder(d=dPinI*factor, h=h, center=true, $fn=6*f);
        }
    }


    module PinF(factor=1, offset=0, spiel=0) {

//#                                    translate([0,h,0]) cube([5,h*2,5], center=true);

        rotate([0, 90, 0])
            cylinder(d1=d1*factor+spiel, d2=d2*factor+spiel, h=h*2, center=true, $fn=6*f);

        if (offset!=0) {
            translate([0, offset, 0])
            rotate([0, 90, 0])
                 cylinder(d1=d1*factor+spiel, d2=d2*factor+spiel, h=h*2, center=true, $fn=6*f);
        }
    }
}
