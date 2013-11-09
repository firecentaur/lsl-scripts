/*
*
*  Copyright (c) 2013 contributors (see below)
*  Released under the GNU GPL v3
*  Github: https://github.com/firecentaur/lsl-scripts
*  -------------------------------------------
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
*  Also, if you like this script you can donate via paypal to paul@preibisch.biz
*  Or bitcoin to: 13XxNazLLtfagkCpHEFEMFn611yF96wa1h
* Cheers!
*/


// Strided Functions For working with Strided Lists.
// By Aakanaar LaSalle

// the intStride parameter is the length of the strides within the list
// the intIndex is which stride we're working with.
// the intSubIndex is which element of the stride we're working with.
integer SCATTER_FORCE=15;
list touchers;
integer LIMIT_X=15;
integer LIMIT_Y=15;
integer LIMIT_Z=15;
list possibleDestinations;
integer coord_listenHandler ;
integer PUZZLE_CHANNEL = -5000;
integer CLEANUP_CHANNEL = -99;
string  SND_WALL_CRUMBLING="SND_WALL_CRUMBLING";
integer MY_PARAM;
float texture_offsetX;
float texture_offsetY;
integer SLOODLE_OBJECT_BLINK= -1639271135; //linked message channel to tell a prim to blink
string status="UNLOCKED";
list rand=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];
// Returns number of Strides in a List
integer fncStrideCount(list lstSource, integer intStride)
{
  return llGetListLength(lstSource) / intStride;
}

// Find a Stride within a List (returns stride index, and item subindex)
//list Source = ["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"];
//list Item = ["B3"];
//list Result = fncFindStride(Source, Item, 3);
// Returns [1, 2].
list fncFindStride(list lstSource, list lstItem, integer intStride)
{
  integer intListIndex = llListFindList(lstSource, lstItem);
  
  if (intListIndex == -1) { return [-1, -1]; }
  
  integer intStrideIndex = intListIndex / intStride;
  integer intSubIndex = intListIndex % intStride;
  
  return [intStrideIndex, intSubIndex];
}

// Deletes a Stride from a List
list fncDeleteStride(list lstSource, integer intIndex, integer intStride)
{
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = intIndex * intStride;
    return llDeleteSubList(lstSource, intOffset, intOffset + (intStride - 1));
  }
  return lstSource;
}

// Returns a Stride from a List
list fncGetStride(list lstSource, integer intIndex, integer intStride)
{
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = intIndex * intStride;
    return llList2List(lstSource, intOffset, intOffset + (intStride - 1));
  }
  return [];
}

// Replace a Stride in a List
list fncReplaceStride(list lstSource, list lstStride, integer intIndex, integer intStride)
{
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  
  if (llGetListLength(lstStride) != intStride) { return lstSource; }
  
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = intIndex * intStride;
    return llListReplaceList(lstSource, lstStride, intOffset, intOffset + (intStride - 1));
  }
  return lstSource;
}

// Retrieve a single element from a Stride within a List
list fncGetElement(list lstSource, integer intIndex, integer intSubIndex, integer intStride)
{
  if (intSubIndex >= intStride) { return []; }
  
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = (intIndex * intStride) + intSubIndex;
    return llList2List(lstSource, intOffset, intOffset);
  }
  return [];
}

// Update a single item in a Stride within a List
list fncReplaceElement(list lstSource, list lstItem, integer intIndex, integer intSubIndex, integer intStride)
{
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  
  if (llGetListLength(lstItem) != 1) { return lstSource; }
  
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = (intIndex * intStride) + intSubIndex;
    return llListReplaceList(lstSource, lstItem, intOffset, intOffset);
  }
  return lstSource;
}

sloodle_set_pos(vector targetposition){
    integer counter=0;
    llSetStatus(STATUS_PHYSICS, FALSE); 
     debug("moving to position: "+(string)targetposition);
    while ((llVecDist(llGetPos(), targetposition) > 0.001)&&(counter<50)) {
        counter+=1;
        debug("moving to position: "+(string)targetposition);
        llSetPos(targetposition);
    }

}
vector myStartPos;
integer random_integer( integer min, integer max )
{
  return min + (integer)( llFrand( max - min + 1 ) );
}
bounce(){
    
        llSensorRepeat("PuzzleGame", "", SCRIPTED, 7, PI,10);
        llSetStatus(STATUS_PHYSICS, TRUE); 
        llSetBuoyancy(1);
        llSetTimerEvent(2.5);
        integer randX= random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
        integer randY =random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
        while(randX>-5&&randX<5){
        randX= random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
        }
        while(randY>-5&&randY<5){
        randY= random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
        }
        
        llApplyImpulse(<randX,randY,SCATTER_FORCE>, FALSE);
        llTriggerSound("explode", .5);
}
particleBeam(key target){
 
    llParticleSystem([PSYS_PART_MAX_AGE,3.22,
    PSYS_PART_FLAGS, 323,
    PSYS_PART_START_COLOR, <0.22513, 0.07763, 0.80507>,
    PSYS_PART_END_COLOR, <0.99093, 0.98800, 0.95500>,
    PSYS_PART_START_SCALE,<0.00000, 0.00000, 0.00000>,
    PSYS_PART_END_SCALE,<1.80468, 0.30231, 0.00000>,
    PSYS_SRC_PATTERN, 2,
    PSYS_SRC_BURST_RATE,0.00,
    PSYS_SRC_ACCEL, <0.00000, 0.00000, -0.30041>,
    PSYS_SRC_BURST_PART_COUNT,5,
    PSYS_SRC_BURST_RADIUS,1.98,
    PSYS_SRC_BURST_SPEED_MIN,0.66,
    PSYS_SRC_BURST_SPEED_MAX,0.68,
    PSYS_SRC_ANGLE_BEGIN, 0.00,
    PSYS_SRC_ANGLE_END, 0.00,
    PSYS_SRC_OMEGA, <0.00000, 0.00000, 1.88676>,
    PSYS_SRC_MAX_AGE, 0.0,
    PSYS_SRC_TEXTURE, "db6c41fe-9c52-44cd-ac14-841776164556",
    PSYS_PART_START_ALPHA, 1.00,
    PSYS_PART_END_ALPHA, 0.88,
    PSYS_SRC_TARGET_KEY, target]);
    }


move_to_map_position(key uuid,integer answer) {
    
//    vector map_position_offset= ZERO_VECTOR;
  //  rotation map_rotation_offset = ZERO_ROTATION; 
    // llOwnerSay("todo: move to position "+(string)map_position_offset+", rot "+(string)map_rotation_offset+ " in relation to map "+(string)map_uuid);
    list mapdetails = llGetObjectDetails( uuid, [ OBJECT_POS, OBJECT_ROT ] );
    vector mappos = llList2Vector( mapdetails, 0 );
    rotation maprot = llList2Rot( mapdetails, 1 );
    debug("object details = "+llDumpList2String(mapdetails, ","));
    sloodle_set_pos( mappos  );
     llParticleSystem([]);
    if (!answer){
       bounce();
    
    }else{
        llSetRot(maprot);
        llTriggerSound("LOCKED", 1);
        status="LOCKED";
        
    }
     llSetRot(maprot);
  //  llSetRot( maprot * map_rotation_offset );
  //  llSetRot( maprot );

}

debug(string s){
    list params = llGetPrimitiveParams([PRIM_MATERIAL]);
    if (llList2Integer(params, 0)== PRIM_MATERIAL_FLESH) {
        llOwnerSay(s);
    }
    
}
 fire()
   {
      llParticleSystem([
      PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | PSYS_PART_FOLLOW_VELOCITY_MASK | PSYS_PART_FOLLOW_SRC_MASK,
      PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
      PSYS_SRC_ANGLE_BEGIN, PI_BY_TWO,
      PSYS_SRC_ANGLE_END, PI_BY_TWO,
      PSYS_PART_START_SCALE, <3.5, 3.4, 3.5>,
      PSYS_PART_END_SCALE, <1.5, 1.75, 1.1>,
      PSYS_PART_START_ALPHA, 1.0,
      PSYS_PART_END_ALPHA, 0.01,
      PSYS_PART_START_COLOR, <1,1,1>,
      PSYS_PART_END_COLOR, <1,1,1>,
      PSYS_PART_MAX_AGE, 3.0,
      PSYS_SRC_TEXTURE, "fire2",
      PSYS_SRC_BURST_RATE, 100000.0,
      PSYS_SRC_BURST_PART_COUNT, 10000,
      PSYS_SRC_BURST_RADIUS, 0.0,
      PSYS_SRC_BURST_SPEED_MAX, 5.1,
      PSYS_SRC_BURST_SPEED_MIN, 0.1
      ]);
      llSleep(0.0);
  }

// Returns a list of all inventory (all types)
list get_inventory(integer type)
{
    list inv = [];
    integer num = llGetInventoryNumber(type);
    integer i = 0;
    for (i=0; i < num; i++) {
        inv += [llGetInventoryName(type, i)];
    }
    
    return inv;
}
string winner;
key myPuzzleGame;
string MY_SOUND;
string MY_TEXTURE_SOUND;
string MY_COLLISION_SOUND;
default {
    on_rez(integer start_param) {
    
        llSetTexture("0dfccb38-93be-3eca-c2ea-b5179515267b", ALL_SIDES);
        MY_PARAM= start_param;
        MY_COLLISION_SOUND = "SND_"+(string)(23-random_integer(1,22));
        llCollisionSound(MY_COLLISION_SOUND, 1.0);
      //  llSay(0,"col:"+MY_COLLISION_SOUND);
           llTriggerSound(MY_COLLISION_SOUND, 1);
        
        	MY_TEXTURE_SOUND = "SND_"+(string)(25-MY_PARAM);
        MY_SOUND="SND_"+(string)(MY_PARAM+1);
        llTriggerSound(MY_SOUND, 1);
        llSetObjectName("puzzlePiece"+(string)(MY_PARAM));
        texture_offsetX = -0.4+0.2*(MY_PARAM%5);
        texture_offsetY = 0.4-0.2*((llFloor((0.08*(MY_PARAM+1)/0.4))));
        if (texture_offsetY ==-0.600)texture_offsetY ==-0.400;
        if (texture_offsetX ==-0.600)texture_offsetX ==-0.400;
        llOffsetTexture(texture_offsetX,texture_offsetY, ALL_SIDES);
        if (MY_PARAM==14) llOffsetTexture(0.400,0,ALL_SIDES);
        myStartPos=llGetPos();
        
    }
    state_entry() {
        coord_listenHandler = llListen(PUZZLE_CHANNEL, "", "", "");
        llSetRot(ZERO_ROTATION);
        llListen(CLEANUP_CHANNEL, "", "", "cleanup");
        rand = llListRandomize(rand, 1);
        rand = llListRandomize(rand, 1);
        rand = llListRandomize(rand, 1);
       // MY_COLLISION_SOUND="SND_"+(string)(25-random_integer(1,25));
      //  llSay(0,"my col sound is "+MY_COLLISION_SOUND);
      
        // llCollisionSound(MY_COLLISION_SOUND, 1.0);
          
          
    }
   
    touch_start(integer num_detected) {
        integer j;
        for (j=0;j<num_detected;j++){
            llTriggerSound("touched",1);
            key toucher =  llDetectedKey(j);
            //particleBeam(toucher);
            if (status =="LOCKED") return;
            llMessageLinked(LINK_SET, SLOODLE_OBJECT_BLINK, "", NULL_KEY);
            integer result = llListFindList(touchers,[toucher]);
            llSetRot(ZERO_ROTATION);
            if (result==-1){
                touchers+=toucher;                
            }
            debug(llDumpList2String(touchers, ","));
            //llInstantMessage(toucher, "Hi "+llKey2Name(toucher)+", please select a place on the board where you would like to place this piece");
        }
        
    }
    sensor(integer num_detected) {
        vector pos = llGetPos();
        float xd = llAbs((integer)(myStartPos.x-pos.x));
        float yd = llAbs((integer)(myStartPos.y-pos.y));
          if (status =="LOCKED") {
               llSensorRemove();
              return;
          }
        if (xd<5||yd<5){
            integer randX= random_integer(-1*8,10);
            integer randY= random_integer(-1*8,10);
            while(randX>-5&&randX<5){
                randX= random_integer(-1*8,8);
            }
            while(randY>-5&&randY<5){
                randY= random_integer(-1*8,8);
            }
           sloodle_set_pos(<myStartPos.x+randX,myStartPos.y+randY,myStartPos.z>);
        }else{
            llSensorRemove();
        }
    
    }
    listen(integer channel, string name, key id, string message) {
        //whenever a user clicks on the map, the maps coordinates will be broadcast
        //along with the user's uuid that was clicked. This will be stored in a list.  When the user then clicks
        //on this map piece, it will search the list and move to the location stored 
        list data = llParseStringKeepNulls(message, ["|"], [" "]);
        //llShout(TOUCH_CHANNEL,"COORDINATE TOUCHED|"+(string)userKey+"|"+(string)coordUuid+"|"+coordName);
        debug("channel : "+(string)channel);     
         string command=llList2Key(data,0);
       if (channel==CLEANUP_CHANNEL){
          if (command=="DIE" || command=="cleanup"){
              // llTriggerSound(SND_WALL_CRUMBLING, 1);
                
                fire();
                state die;
            }
       }else
        if (channel==PUZZLE_CHANNEL){
           
            debug("command : "+command);
            if (command=="SHOW_NAMES"){
                debug("setting hover text to: "+winner); 
                llMessageLinked(LINK_SET, -998, winner, NULL_KEY);
            }else
            if (command=="DIE"||command=="cleanup"){
                 llTriggerSound(MY_SOUND, 1);
                fire();
                state die;
            }else
            if (command=="COORDINATE_CLICKED"){
                if (status =="LOCKED") return;
                key userKey=llList2Key(data,1);
                key coordUuid=   llList2Key(data,2);
                string coordName = llList2String(data,3); 
                myPuzzleGame= llList2Key(data,4);
                debug("received: "+message);
                if (llGetListLength(touchers)==0)return;    
                debug("In my database i have: "+llDumpList2String(touchers, ","));
                //check to see if it is correct placement
                integer answer;
                if (coordName==llGetObjectName()){
                    answer=TRUE;
                    llRegionSayTo(myPuzzleGame,PUZZLE_CHANNEL+1,"CORRECT|"+(string)userKey+"|"+(string)coordUuid);
                    winner = llKey2Name(userKey);
                    debug(llKey2Name(userKey)+ " just put the piece in the correct location!");
                    
                }else{
                    answer=FALSE;
                }
                //search through touchers to see if this user touched it
                integer result = llListFindList(touchers,[userKey]);
                 debug((string)result);
                 if (result!=-1){
                     debug("got message: user who touched me is "+llKey2Name(userKey)+" and they are in my db");
                    llTriggerSound("moving",1);
                    move_to_map_position(coordUuid,answer);
                    touchers = llDeleteSubList(touchers, result, result);
                }else{
                
                    debug("got message: user who touched me is "+llKey2Name(userKey)+" BUT they are NOT in my db");
                }
                return;
            }else 
            if (command=="SCATTER"){
                if (status=="LOCKED")return;
                bounce();
            }else
            if (command=="PUSH"){
                if (status=="LOCKED")return;
                SCATTER_FORCE+=5;
                bounce();
            }else
            if (command=="PULL"){
                if (status=="LOCKED")return;
                SCATTER_FORCE-=5;
                if (SCATTER_FORCE<7){
                SCATTER_FORCE=7;
                }
                bounce();
            }
            
        }
    
    }
    timer() {
           
        llSetTimerEvent(0);
        llSetBuoyancy(0);
        vector currentPos = llGetPos();
        if (llAbs((integer)myStartPos.x-(integer)currentPos.x)>LIMIT_X||llAbs((integer)myStartPos.y-(integer)currentPos.y)>LIMIT_Y||llAbs((integer)myStartPos.z-(integer)currentPos.z)>LIMIT_Z){
            integer randX= random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
            integer randY =random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
            while(randX>-5&&randX<5){
                randX= random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
            }
            while(randY>-5&&randY<5){
                randY= random_integer(-1*SCATTER_FORCE,SCATTER_FORCE);
            }
            sloodle_set_pos(<myStartPos.x+randX,myStartPos.y+randY,myStartPos.z>);
        }
        
    }
    changed(integer change){
        if (change & CHANGED_INVENTORY) //note that it's & and not &&... it's bitwise!
        {
            list textures= get_inventory(INVENTORY_TEXTURE);
            key texture = llGetInventoryKey(llList2String(textures,0));
            llSetTexture(texture, ALL_SIDES);
            vector offsetVec =  llGetTextureOffset(1);
            if (offsetVec.y==-0.600){
                offsetVec.y=-0.400;
            }
            llTriggerSound(MY_TEXTURE_SOUND, 1);
            llOffsetTexture(offsetVec.x,offsetVec.y, ALL_SIDES);
            
        }
    }
    
}

state die{
    on_rez(integer start_param) {
        llResetScript();
    }
    state_entry() {
        debug("in die state");
       
        
        llSetTimerEvent(random_integer(1,10));
    }
    timer(){
    	llTriggerSound(MY_SOUND, 1);
        llDie();
    }

}