/*
PiPlate for Rostock Max
© 2016 Dale Price daprice@mac.com

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//---------------------
//      Settings
//---------------------

/* [Printer Config (default: Rostock Max v2)] */

//the width of the Rostock Max side panel (mm)
panelWidth = 200;

//the height of the Rostock Max side panel
panelHeight = 113;

//the thickness of the Rostock Max side panel
panelThickness = 6;

/* [Raspberry Pi options] */

//whether to include bits for camera mounting
camera = "Pi Camera"; // [No camera, Pi Camera]

//Raspberry Pi version
piVersion = "3B"; // [1B, 1B+, 1A+, 2B, 3B, Zero]

//The style of vent holes you want
vent = "Slots"; // [No Vent, Slots]

//Any text that you want on the panel, e.g. the hostname of the Pi
text = "rostockpi.local";


include <MCAD/boxes.scad> //used for the base shape of the RoMax side panel
use <lib/PiHole/PiHole.scad> //used for the raspberry pi mount

piSize = piBoardDim(piVersion);
piPos = [-piSize[0]/2 - panelWidth/6, -piSize[1] + panelHeight/2 - 20, panelThickness/2];

difference() {
	//basic shape of romax side panel
	roundedBox([panelWidth, panelHeight, panelThickness],2.5,true);
	
	//screw holes in side panel
	translate([-panelWidth / 2 + 8, panelHeight / 2 - 32, 0]) cylinder(d=7, h=panelThickness, center=true);
	translate([panelWidth / 2 - 8, panelHeight / 2 - 32, 0]) cylinder(d=7, h=panelThickness, center=true);

	//slot for camera if applicable
	if(camera == "Pi Camera") {
		translate([0, panelHeight / 2, 0]) rotate([45,0,0]) cube([20,panelThickness*1.5,100], center=true);
	}

	if(vent == "Slots") {
		translate([piPos[0] + piSize[0]/2, piPos[1] + piSize[1] / 2, 0]) {
			translate([-18,0,0]) cube([3,12,20], center=true);
			for(x = [-12:6:12]) {
				translate([x, 0, 0]) cube([3, 20, 20], center=true);
			}
			translate([18,0,0]) cube([3,12,20], center=true);
		}
	}
}

//raspberry pi mounting
translate(piPos) {
	% translate([0,0,5 - piSize[2]]) piBoard(piVersion);
	
	$fn=10;
	for(holePos = piHoleLocations(piVersion)) {
		translate([holePos[0], holePos[1], 0]) {
			cylinder(d=2, h=5);
			cylinder(d1=5, d2=2, h=5 - piSize[2] - 0.25);

			translate([0, 0.4, 5]) scale([1.1, 1.1, 1]) cylinder(d=2, h=0.5);
		}
	}
}
