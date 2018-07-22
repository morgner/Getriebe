/*
3-RaederKoppelGetriebe

Autor:		Manfred Morgner
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike
*/

$fn=90;
eps=.001;

gh=6;
translate([ 0, 00,00]) lever(gl = 50, o=2, gh=gh, h1=0, h2=0);
translate([85, 00,00]) lever(gl = 50, o=2, gh=gh, h1=0, h2=0);
translate([ 0, 40,00]) lever(gl = 50, o=2, gh=gh, h1=gh, h2=2*gh); 
translate([ 0,-40,00]) lever( gl=120, gd= 30, gi= 20, gh= gh );


module bohrung(
                gi = 20, // link inner diameter
                gh = 10, // lever height
                h  = 10, // height of zapfen
                o  =  2, // lever thickness under the zapfen
                kh =  2, // cone height
                kx = .5, // cone diameter offset
                ko = .5  // cone height offset
                ){
    if (h > 0)
        translate([ 0,0,o]) cylinder(d=gi+2, h=gh-o+eps);
    else
        {
        translate([ 0,0,0         -eps/2]) cylinder(d=gi,      h=gh+eps);
        translate([ 0,0,0         -eps/2]) cylinder(d=gi+3*kx, h=(kh+ko)+eps);
        translate([ 0,0,gh-(kh+ko)+eps/2]) cylinder(d=gi+3*kx, h=(kh+ko)+eps);
        }
    }

module lever(   gl =120, // length of the lever, zapfen to zapfen
                gd = 30, // lever diameter / width
                gi = 20, // link inner diameter
                gh = 10, // lever height
                h1 = 10, // height of zapfen 1
                h2 = 10, // height of zapfen 2
                hb =  0, // body height
                o  =  2, // lever thickness under the zapfen
                kh =  2, // cone height
                kx = .5, // cone diameter offset
                ko = .5  // cone height offset
                ){
                    
    grdt = o; // ground thickness

    difference(){
        union(){
            hull (){
                translate([ 0,0,0]) cylinder(d=gd/2, h=gh/3*2);
                translate([gl,0,0]) cylinder(d=gd/2, h=gh/3*2);
                }
            translate([ 0,0,0]) cylinder(d=gd, h=gh);
            translate([gl,0,0]) cylinder(d=gd, h=gh);
            }
        bohrung( gi = gi, gh = gh, h = h1, o = o, kh = kh, kx = kx, ko = ko );
/*
        if (h1 > 0)
            translate([ 0,0,grdt]) cylinder(d=gi+2, h=gh-grdt+eps);
        else
            {
            translate([ 0,0,0         -eps/2]) cylinder(d=gi,      h=gh+eps);
            translate([ 0,0,0         -eps/2]) cylinder(d=gi+3*kx, h=(kh+ko)+eps);
            translate([ 0,0,gh-(kh+ko)+eps/2]) cylinder(d=gi+3*kx, h=(kh+ko)+eps);
            }
//        translate([gl,0,grdt]) cylinder(d=gi+2, h=gh-grdt+eps);
*/
        translate([gl,0,0])
            bohrung( gi = gi, gh = gh, h = h2, o = o, kh = kh, kx = kx, ko = ko );
/*
        if (h2 > 0)
            translate([gl,0,grdt]) cylinder(d=gi+2, h=gh-grdt+eps);
        else
            {
            translate([gl,0,0         -eps/2]) cylinder(d=gi,      h=gh+eps);
            translate([gl,0,0         -eps/2]) cylinder(d=gi+3*kx, h=(kh+ko)+eps);
            translate([gl,0,gh-(kh+ko)+eps/2]) cylinder(d=gi+3*kx, h=(kh+ko)+eps);
            }
  */
      }
    if (h1 >0)
        color([1,.5,1]) translate([ 0,0,grdt+hb+eps]) zapfen(d=gi, h=gh-grdt+h1+eps, hb=hb);
    if (h2 >0)
        color([.5,1,1]) translate([gl,0,grdt+hb+eps]) zapfen(d=gi, h=gh-grdt+h2+eps, hb=hb);
    }

module zapfen(  d   = 20, // diameter
                h   = 10, // height
                w   =  3, // wall thickness
                c   =  6, // nut width
                hb  = 10, // height of the body
                bdo =  2, // body diameter offset
                kh  =  2, // cone height
                kx  = .5, // cone diameter offset
                ko  = .5, // cone height offset
                spiel = .5 // reduction of outer diameter (d)
              ){
        he=h+hb;

        difference(){
            union(){
// wheel
                translate([0,0,he/2-hb]) cylinder(d=d-spiel, h=he, center=true);
// body
                if (hb > 0) translate([0,0,-hb/2]) cylinder(d=d+2*bdo, h=hb, center=true);
// Raste
                translate([0,0,+h-kh/2-ko]) cylinder(d1=d+2*kx, d2=d, h=kh,    center=true);
                }

            translate([0,0, h/2+eps])     cube([2*kx+d+eps,c,h], center=true);
            translate([0,0, h/2+eps])     cube([c,2*kx+d+eps,h], center=true);
               
            translate([0,0,he/2-hb])  cylinder(d1=d-2*w-2, d=d-2*w, h=he+.1, center=true);

   //       translate([0, (d/2+w)/2, he/2-hb]) cube([d+2*w+1.1, d/2+w+1.1, he+1.1], center=true);
            }
    }
