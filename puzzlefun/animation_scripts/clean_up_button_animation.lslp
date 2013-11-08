/*
*  SCRIPT NAME:  clean_up_btn_animation.lslp
*  WHERE TO PLACE SCRIPT: in the invisible prim for the clean up button in the tools pull out.
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
string lAnimName = "CLEAR";// Name used for link messages.
//
// Default state.
default{
    link_message(integer n, integer c, string m, key id){
        vector lSize = llList2Vector(llGetLinkPrimitiveParams(1,[7]),0);
        if(m == "p1"){ 
            llSetLinkPrimitiveParamsFast(3,[33, <0.110640*lSize.x, -0.816832*lSize.y, 0.523911*lSize.z>, 29, <0.000000, 0.000000, 0.000000, 1.000000>]);
        }
        if(m == "p0"){
            llSetLinkPrimitiveParamsFast(3,[33, <0.110640*lSize.x, -0.351628*lSize.y, 0.158836*lSize.z>, 29, <0.000000, 0.000000, 0.000000, 1.000000>]);
        }
    }
}