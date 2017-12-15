// measured
distanceBetweenCenters = 96;
rodDiameter = 10;
magnetDiameter = 6;
magnetDepth = 3;

// measured-ish
distanceToFrame = 28;

// dictated
holderWidth = 3;
armWidth = 10;
holderDepth = 6;
handleGrab = 16;

// tweaks
$fn = 90;

angle = atan2( -distanceToFrame, distanceBetweenCenters / 2);
armLength = sqrt(pow(distanceToFrame,2)+pow(distanceBetweenCenters / 2,2));
grabWidth = rodDiameter + holderWidth*2;

difference () {
  union () {
    linear_extrude(handleGrab) {
      translate([-distanceBetweenCenters/2,distanceToFrame/2,0]) circle(d=grabWidth);
      translate([distanceBetweenCenters/2,distanceToFrame/2,0]) circle(d=grabWidth);
    }
    linear_extrude(holderDepth) {
      translate([-distanceBetweenCenters/2,distanceToFrame/2,0])
        rotate([0,0,angle]) translate([0,-armWidth/2,0])
        square([armLength, armWidth]);
      translate([distanceBetweenCenters/2,distanceToFrame/2,0])
        rotate([0,0,180-angle]) translate([0,-armWidth/2,0])
        square([armLength, armWidth]);
      translate([0,-distanceToFrame/2,0]) circle(d=magnetDiameter + holderWidth*2);
    }
  }
  linear_extrude(handleGrab) {
    translate([-distanceBetweenCenters/2,distanceToFrame/2,0]) circle(d=rodDiameter);
    translate([distanceBetweenCenters/2,distanceToFrame/2,0]) circle(d=rodDiameter);
  }
  linear_extrude(magnetDepth) {
    translate([0,-distanceToFrame/2,0]) circle(d=magnetDiameter);
  }
}