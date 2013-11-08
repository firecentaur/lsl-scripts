/*
*  SCRIPT NAME:  lock_button.lslp
*  WHERE TO PLACE SCRIPT: in the invisible prim for the lock button .
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
vector     RED            = <0.77278,0.04391,0.00000>;//RED
vector     ORANGE = <0.87130,0.41303,0.00000>;//orange
vector     YELLOW         = <0.82192,0.86066,0.00000>;//YELLOW
vector     GREEN         = <0.12616,0.77712,0.00000>;//GREEN
vector     BLUE        = <0.00000,0.05804,0.98688>;//BLUE
vector     PINK         = <0.83635,0.00000,0.88019>;//INDIGO
vector     PURPLE = <0.39257,0.00000,0.71612>;//PURPLE
vector     WHITE        = <1.000,1.000,1.000>;//WHITE
vector     BLACK        = <0.000,0.000,0.000>;//BLACKvector     ORANGE = <0.87130, 0.41303, 0.00000>;//orange
integer counter=0;
integer TIME_LIMIT=7;
integer SLOODLE_CHANNEL_OBJECT_DIALOG                   = -3857343; //configuration channel
integer LOCK = -776;
integer UNLOCK = -778;
string SLOODLE_EOF = "sloodleeof";
default {
    on_rez(integer start_param) {
        llResetScript();
    }
    state_entry() {
        llSetTexture("UNLOCKED", 0);
        llSetObjectName("UNLOCKED");
    }
    link_message(integer sender_num, integer channel, string str, key id) {
        if (channel==LOCK){
            llTriggerSound("click", 1.0);//
            llSetTexture("LOCKED", 0);
            llSetObjectName("LOCKED");
        }else
        if (channel==UNLOCK){
            llTriggerSound("click", 1.0);//
            llSetTexture("UNLOCKED", 0);
            llSetObjectName("UNLOCKED");
        }
    }
}//default
        