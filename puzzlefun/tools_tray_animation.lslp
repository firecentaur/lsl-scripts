/*
*  SCRIPT NAME:  lock_button.lslp
*  WHERE TO PLACE SCRIPT: in the tools tray.
*  =========================================
*  Copyright (c) 2013 contributors (see below)
*  Released under the GNU GPL v3
*  Github: https://github.com/firecentaur/lsl-scripts
*  =========================================
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*  All scripts must maintain this copyrite information, including the contributer information listed
*
*  As mentioned, this script has been  licensed under GPL 3.0
*  Basically, that means, you are free to use the script, commercially etc, but if you include
*  it in your objects, you must make the source viewable to the person you are distributuing it to -
*  ie: it can not be closed source - GPL 3.0 means - you must make it open!
*  This is so that others can modify it and contribute back to the community.
*
*  Enjoy!
*  Github: https://github.com/firecentaur/lsl-scripts
*
*  Contributors:
*   Paul Preibisch
*  
*  =========================================
*  DONATING TO THE DEVELOPER
*  =========================================
*  If you like this opensourve script and you want to support opensource, kindly donate via paypal
*  to paul@preibisch.biz
*  Or bitcoin to: 13XxNazLLtfagkCpHEFEMFn611yF96wa1h
*  =========================================
*  VIRTUAL WORLD VIDEOS
*  Http://www.youtube.com/user/fire2006/videos
*  =========================================
*  PLEASE SUPPORT LSLPLUS EDITOR FOR DEVELOPERS <-- ITS A GREAT EDITOR I USE ALL THE TIME
*  http://lslplus.sourceforge.net/
*  =========================================
*/
default
{
link_message(integer s, integer n, string m, key id)
{integer stat=llGetStatus(1);

if(m=="p0"){ //zF Animation Frame #0
vector r=<2.10635,2.18680,0.18970>;
llSetScale(r);
vector Zfire=llGetScale();
vector zFire=<0.09663,-1.82121,0.01863>;
vector zfIre=<2.10635,2.18680,0.18970>;
vector zfiRe=< zFire.x/zfIre.x,zFire.y/zfIre.y,zFire.z/zfIre.z>;
vector zfirE=< Zfire.x*zfiRe.x,Zfire.y*zfiRe.y,Zfire.z*zfiRe.z>;
llSetPrimitiveParams([6, zfirE,8, <0.0,0.0,0.0,1.0> / llGetRootRotation(),9,0,0,<0.0, 1.0, 0.0>,0.0,<0.0, 0.0, 0.0>,<1.0, 1.0, 0.0>,<0.0, 0.0, 0.0>,18,0,<1.0, 1.0, 1.0>,1.000000,18,1,<1.0, 1.0, 1.0>,1.000000,18,2,<1.0, 1.0, 1.0>,1.000000,18,3,<1.0, 1.0, 1.0>,1.000000,18,4,<1.0, 1.0, 1.0>,1.000000,18,5,<1.0, 1.0, 1.0>,1.000000,25,0,0.0,25,1,0.0,25,2,0.0,25,3,0.0,25,4,0.0,25,5,0.0]); }

if(m=="p1"){ //zF Animation Frame #1
vector r=<2.10635,2.18680,0.18970>;
llSetScale(r);
vector Zfire=llGetScale();
vector zFire=<0.09660,-4.09920,0.17090>;
vector zfIre=<2.10635,2.18680,0.18970>;
vector zfiRe=< zFire.x/zfIre.x,zFire.y/zfIre.y,zFire.z/zfIre.z>;
vector zfirE=< Zfire.x*zfiRe.x,Zfire.y*zfiRe.y,Zfire.z*zfiRe.z>;
llSetPrimitiveParams([6, zfirE,8, <0.0,0.0,0.0,1.0> / llGetRootRotation(),9,0,0,<0.0, 1.0, 0.0>,0.0,<0.0, 0.0, 0.0>,<1.0, 1.0, 0.0>,<0.0, 0.0, 0.0>,18,0,<1.0, 1.0, 1.0>,1.000000,18,1,<1.0, 1.0, 1.0>,1.000000,18,2,<1.0, 1.0, 1.0>,1.000000,18,3,<1.0, 1.0, 1.0>,1.000000,18,4,<1.0, 1.0, 1.0>,1.000000,18,5,<1.0, 1.0, 1.0>,1.000000,25,0,0.0,25,1,0.0,25,2,0.0,25,3,0.0,25,4,0.0,25,5,0.0]); }

if(stat){llSetStatus(1,1);}}}

