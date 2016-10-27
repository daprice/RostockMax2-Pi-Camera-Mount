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

//How high up to mount the base of the camera relative to the thumbscrews where the mount attaches
camMountHeight = 90;

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

assembly();

module assembly() {
	color("green") translate([0, -panelHeight / 2 + 32, -panelThickness/2]) rotate([0,180,0]) panel();
	color("yellow") if(camera == "Pi Camera") piCameraMount();
}

//hole for the Rostock's thumbscrews
module screwHole(center=false, h=panelThickness) {
	translate([0,0,-0.5]) cylinder(d=7, h=h + 1, center=center);
}

module screwHoles(center=false, h=panelThickness) {
	//screw holes in side panel
	translate([-panelWidth / 2 + 8, 0, 0]) screwHole(center=center, h=h);
	translate([panelWidth / 2 - 8, 0, 0]) screwHole(center=center, h=h);
}

module panel() {
	difference() {
		//basic shape of romax side panel
		roundedBox([panelWidth, panelHeight, panelThickness],2.5,true);
		
		translate([0,panelHeight / 2 - 32, 0]) screwHoles(center=true);
	
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
		$fn=10;
		piPosts(piVersion, 5);
	}
}

module piCameraMount() {
	camMountThick = 4;
	camCableWidth = 20;
	camWidth = 25;

	module roundedProfile(d,h=camMountThick) {
		intersection() {
			resize([d, d, h*3]) sphere(center=true, d=d);
			cylinder(d=d+h, h=h, center=false);
		}
	}

	module horizBar() {
		difference() {
			hull() {
				translate([-panelWidth / 2 + 8, 0, 0]) roundedProfile(d=15);
				translate([panelWidth / 2 - 8, 0, 0]) roundedProfile(d=15);
			}
			screwHoles(center=false, h=camMountThick);
		}
	}

	module cameraNotches() {
		translate([0,-1,0.75]) rotate([0,45,0]) cube([1,2,1], true);
		translate([0,-1,2.7]) rotate([0,45,0]) cube([1,2,1], true);
		translate([0,-1,4.7]) rotate([0,45,0]) cube([1,2,1], true);
		translate([0,-1,6.7]) rotate([0,45,0]) cube([1,2,1], true);
		translate([0,-1,8.7]) rotate([0,45,0]) cube([1,2,1], true);
	}

	horizBar();

	//vertical bar
	hull() {
		intersection() {
			horizBar();
			roundedProfile(d=camCableWidth + 4);
		}

		difference(){
			translate([0, camMountHeight-10, 0]) roundedProfile(d=camCableWidth + 4);
			translate([-50,camMountHeight-10,0]) cube([100,100,100]);
		}
	}

	//camera mounting bit
	translate([0, camMountHeight - camWidth/4, 0]) difference() {
		translate([-(camWidth + 10) / 2, -camWidth/4, 0]) cube([camWidth + 10, camWidth, 10]);
		translate([0, camWidth-5, 3]) rotate([45,0,0]) cube([camWidth, camWidth, camWidth], center=true);
		translate([0, camCableWidth-6, 0]) rotate([45,0,0]) cube([camCableWidth + 1, camCableWidth, camCableWidth], center=true);
		rotate([-20,0,0]) translate([0, camWidth/2 - 2, 3]) cube([camWidth-2, camWidth, camWidth], center=true);
	}

	//notches to hold camera in place
	translate([camWidth/2, camMountHeight + camWidth/2, 0]) cameraNotches();
	translate([-camWidth/2, camMountHeight + camWidth/2, 0]) cameraNotches();
}
