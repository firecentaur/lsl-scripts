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


integer random_integer( integer min, integer max )
{
  return min + (integer)( llFrand( max - min + 1 ) );
}
integer PUZZLE_CHANNEL = -5000; //channel the puzzle uses to talk to puzzle pieces - ie: tells them to die etc
integer TEXTURE_MENU_CHANNEL;
integer SCREEN_CHANNEL=-1988;
integer SCATTER_CHANNEL=-8821;
integer LOCKED = -776;
integer UNLOCK = -778;
list textures;
integer counter;
integer UNLOCKED=TRUE;
integer current_page;
string myPuzzleTexture;
vector RED =<1.00000, 0.00000, 0.00000>;
vector ORANGE=<1.00000, 0.43763, 0.02414>;
vector YELLOW=<1.00000, 1.00000, 0.00000>;
vector GREEN=<0.00000, 1.00000, 0.00000>;
vector BLUE=<0.00000, 0.00000, 1.00000>;
vector BABYBLUE=<0.00000, 1.00000, 1.00000>;
vector PINK=<1.00000, 0.00000, 1.00000>;
vector PURPLE=<0.57338, 0.25486, 1.00000>;
vector BLACK= <0.00000, 0.00000, 0.00000>;
vector WHITE= <1.00000, 1.00000, 1.00000>;
list puzzlePieces;
string HELPURL= "http://bit.ly/puzzlefunvideo";  
integer correctCounter=0;
integer toggleHelp=-1;
integer SLOODLE_OBJECT_REGISTER_INTERACTION= -1639271133; //channel objects send interactions to the mod_interaction-1.0 script on to be forwarded to server
list randColors=[RED,ORANGE,PINK,PURPLE,BABYBLUE,YELLOW];
integer rezCounter=0;
list queue;
integer MANUAL_COMMAND=9;
list myPrims;
debug(string s){
    list params = llGetPrimitiveParams([PRIM_MATERIAL]);
    if (llList2Integer(params, 0)== PRIM_MATERIAL_FLESH) {
       llOwnerSay(s);
    }
      
}
//tellPuzzlePieces function is used to send messages to the puzzle peices 
tellPuzzlePieces(string message){
    integer i=0;
    integer num = llGetListLength(puzzlePieces);
    for (i=0;i<num;i++){
        llRegionSayTo(llList2Key(puzzlePieces,i),PUZZLE_CHANNEL, message);
    }
}


//returns a random color
vector getColor(){
    integer rand = random_integer(0,5);
    return llList2Vector(randColors,rand);    
}

//gets the location of a particular prim
vector getLinkPos(string name){
        integer len=llGetNumberOfPrims();
        integer i;
        list result;
        for (i=0;i<len;i++){
            
            if (llGetLinkName(i)==name){
                result =llGetLinkPrimitiveParams(i, [PRIM_POS_LOCAL]);
                return llList2Vector(result,0);        
            }
        }
        return ZERO_VECTOR;
}
//return the link num of name
integer getLinkNum(string name){
         integer len=llGetNumberOfPrims();
        integer i;
        list result;
        
        for (i=0;i<len;i++){
            if (llGetLinkName(i)==name){
                return i;
            }
        }
        return -1;
}
clearBoard(){
    integer len=llGetNumberOfPrims();
        integer i;
        for (i=0;i<=len;i++){
            llSetLinkColor(i, WHITE, ALL_SIDES);
        }
}

 display_texture_menu(integer page,key id){
     debug("displaying texture menu");
     integer num_textures = llGetListLength(textures);
     integer MAX_BUTTONS = 12;
     list buttons;
     buttons=[];
     current_page = page;
     if (page==0&&num_textures>10){
         buttons+="Next";
     }else
     if (page>0){
         if (num_textures>(page+1)*10){
             buttons+="Next";
         }
         buttons+="Previous";
     }
     integer p;
     integer end_page=page*10+10;
     for (p=page*10;p<(end_page);p++){
         if (llGetSubString(llList2String(textures,p), 0, 11)!=""){
              buttons+=llGetSubString(llList2String(textures,p), 0, 11);
             // debug("p is: "+(string)p+" page is: "+(string)page+" adding to menu: "+llGetSubString(llList2String(textures,p), 0, 11));
         }
     }
     llDialog(id, "Please select a texture", buttons, TEXTURE_MENU_CHANNEL);
 }
 integer CLOSED=0;
 integer OPEN=1;
 integer gameMenuState;
 closeGameMenu(){
     gameMenuState=CLOSED;
     llTriggerSound("close", 1);
     llMessageLinked(LINK_ALL_OTHERS, -988, "p"+(string)gameMenuState, NULL_KEY);
    
 }
 openGameMenu(){
     gameMenuState=OPEN;
     llTriggerSound("open", 1);
     llMessageLinked(LINK_ALL_OTHERS, -988, "p"+(string)gameMenuState, NULL_KEY);    
 }
 integer screenState=CLOSED;
 closeScreen(){
     screenState=CLOSED;
     llTriggerSound("close", 1);
     llMessageLinked(LINK_ALL_OTHERS, SCREEN_CHANNEL, "close screen", NULL_KEY);
    
 }
 openScreen(){
     screenState=OPEN;
     llTriggerSound("open", 1);
     llMessageLinked(LINK_ALL_OTHERS, SCREEN_CHANNEL, "open screen", NULL_KEY);    
 }
 integer screenLink;
 init(){
     openGameMenu();
      openScreen();
     loadTextures();
     screenLink = getLinkNum("screen");
     llSetTimerEvent(10);
    llMessageLinked(LINK_SET, UNLOCK, "", NULL_KEY);
    //set the puzzle texture to be the first texture in the inventory
    
    setTipsScreen(myPuzzleTexture);
    correctCounter=0;
    rezCounter=0;
    debug("Default State");
    clearBoard();
            
 }
 list textureMenuNames;
 loadTextures(){
         integer num_textures=llGetInventoryNumber(INVENTORY_TEXTURE);
        integer n=0;
        textures=[];
        textureMenuNames=[];
        string text = ""; 
        
        for (n=0;n<num_textures;n++){
            text="Loading puzzle texture "+(string)n+" of "+(string)num_textures;
            llSetText(text, GREEN, 1); 
             string texture_name = llGetInventoryName(INVENTORY_TEXTURE, n);
            textures+=texture_name;
            llOwnerSay(texture_name);
            if (llStringLength(texture_name)>12){
                textureMenuNames+=llGetSubString(texture_name,0,11);
                  llOwnerSay("--------textureMenuNames-------concatenating texturename to: "+llGetSubString(texture_name,0,11));
            }else{
                llOwnerSay("--------textureMenuNames-------adding texturename to: "+llGetSubString(texture_name,0,11));
                textureMenuNames+=texture_name;
            }
            
        }
        text="";
        llSetText(text, GREEN, 1);
        TEXTURE_MENU_CHANNEL= random_integer(-999,-9999);
 }
 moveTile(key userKey,integer linkNum){
                key coordUuid=   llGetLinkKey(linkNum);
                list linkData = llGetLinkPrimitiveParams( linkNum, [PRIM_NAME]);
                string coordName = llList2String(linkData,0);
                string message ="COORDINATE_CLICKED|"+(string)userKey+"|"+(string)coordUuid+"|"+coordName+"|"+(string)llGetKey();
                integer puzzlePieceNum = (integer)llGetSubString(coordName, 11, -1);
                debug("**************** my puzzle piece num is: "+(string)puzzlePieceNum);
                if (llGetSubString(coordName, 0, 10)=="puzzlePiece"){
                    debug(message);
                    llSetLinkColor(linkNum, getColor(), ALL_SIDES);
                    tellPuzzlePieces(message);
                    debug("sending regionsay command to: "+(string)puzzlePieceNum+" "+message);
                }
 }
gameOver(){
    llTriggerSound("game_complete", 1);
    vector pos = llGetPos();
    llRezObject("fireworks",<pos.x,pos.y,pos.z+5> , <0,0,3>, ZERO_ROTATION, 1);
}
setTipsScreen(string texture){
    vector repeats = <1,1,1>;
    integer face = ALL_SIDES;
    vector offsets = <0,0,0>;
    float rotation_in_radians = 0;
    float TWO_SEVENTY_DEGREES= 3*PI/2;
    float NINETY_DEGREES= PI/2;
    float ONE_EIGHTY_DEGREES= PI;
    //llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,0, texture, repeats, offsets, rotation_in_radians ]);
    llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,0, texture, repeats, offsets, 0 ]);
    llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,1, texture, repeats, offsets, 0 ]);
    llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,2, texture, repeats, offsets, TWO_SEVENTY_DEGREES ]);
    llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,3, texture, repeats, offsets, 0 ]);
    llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,4, texture, repeats, offsets, NINETY_DEGREES ]);
    llSetLinkPrimitiveParams(screenLink,[ PRIM_TEXTURE,5, texture, repeats, offsets, ONE_EIGHTY_DEGREES ]);
    
}

string handleTextureMenuChoice(string choice,key userKey){
            integer num_textures=llGetInventoryNumber(INVENTORY_TEXTURE);
            if (choice=="Next"){
                current_page++;
                if (current_page*10>num_textures){
                    current_page=0;
                }
                display_texture_menu(current_page,userKey);
                return "user changed the page" ;
            }else if (choice=="Previous"){
                current_page--;
                if (current_page<0){
                    current_page=0;
                }
                display_texture_menu(current_page,userKey);
                return "user changed the page" ;
            }
            //the user chose a texture from the dialog menu
            string texture = choice;
            integer t;
            integer found=FALSE;
            num_textures = llGetListLength(textureMenuNames);
            for (t=0;t<num_textures;t++){
                string this_texture=llList2String(textureMenuNames, t);
                debug("this texture is: "+this_texture+" looking for : "+texture);
                if (this_texture==texture){
                    found=TRUE;
                    myPuzzleTexture = llList2String(textures, t);
                    debug("************** found puzzleTexture "+myPuzzleTexture);
                    setTipsScreen(myPuzzleTexture);
                  tellPuzzlePieces("DIE");
                  
                return "user chose a texture";      
                }
            }
           return ""; 
            
}
integer PUZZLE_FUN_MAIN=-72221;
default {
		
    on_rez(integer start_param) {
        llWhisper(-99, "cleanup");
        llResetScript();
        
    }
    state_entry() {
    	llWhisper(-99, "cleanup");
    	myPuzzleTexture= llGetInventoryName(INVENTORY_TEXTURE, 0);
    	state go;
    }
}

state go{
	  on_rez(integer start_param) {
        llWhisper(-99, "cleanup");
        llResetScript();
        
    }
    state_entry() {
        init();
        //listen to messages from the puzzle pieces
        llListen(PUZZLE_CHANNEL+1, "", "", "");
        //listen to messages from the dialog menu when user is changing textures
        llListen(TEXTURE_MENU_CHANNEL, "", "", "");
    }
    listen(integer channel, string name, key id, string message) {
        //        llRegionSayTo(myPuzzleGame,PUZZLE_CHANNEL,"CORRECT|"+(string)userKey+"|"+(string)coordUuid);
        if (channel == MANUAL_COMMAND){
            if (message=="clear"){
            tellPuzzlePieces("DIE");
            }
        }else
        if (channel==TEXTURE_MENU_CHANNEL){
            string choice = handleTextureMenuChoice(message,id);
            if (choice=="user chose a texture") state rezzing; 
             return;
        }
        list data = llParseStringKeepNulls(message, ["|"], [" "]);
        string command=llList2Key(data,0);
        if (command=="CORRECT"){
            key userKey = llList2Key(data,1);
            llMessageLinked(LINK_SET, SLOODLE_OBJECT_REGISTER_INTERACTION, "puzzlePiece", userKey);
            correctCounter++;    
            if (correctCounter>24){
                gameOver();                
            }
        }
    }    
    link_message(integer sender_num, integer num, string str, key id) {
    	if (num!=PUZZLE_FUN_MAIN && num!=SCREEN_CHANNEL)return;
    	
    	if (str=="scatter"){
    		tellPuzzlePieces("SCATTER");
    		llSleep(2);
    		llMessageLinked(LINK_THIS, SCATTER_CHANNEL, "open screen", NULL_KEY);
    		
    	}else
    	if (str=="open screen"){
    		screenState=OPEN;
    	}else
    	if (str=="close screen"){
    		screenState=CLOSED;
    	}
      
    }
    touch_start(integer num_detected) {
        integer j;
         key userKey=llDetectedKey(j);
        for (j=0;j<num_detected;j++){
            integer linkNum = llDetectedLinkNumber(j);
            key id = llDetectedKey(j);
            string button= llGetLinkName(linkNum);
            llTriggerSound("SND_INTERFACE_BEEP", 1);
            if ((button=="SELECT TEXTURE"&&UNLOCKED==TRUE)||(button=="screen"&&UNLOCKED==TRUE)){
                 display_texture_menu(0,id);
            }
            if (button=="UNLOCKED"&&llDetectedKey(j)==llGetOwner()){
                UNLOCKED=FALSE;
                llMessageLinked(LINK_SET, LOCKED, "", NULL_KEY);
            }else
            if (button=="LOCKED"&&llDetectedKey(j)==llGetOwner()){
                UNLOCKED=TRUE;
                llMessageLinked(LINK_SET, UNLOCK, "", NULL_KEY);
            }else            
            if (button=="SETTINGS"&&UNLOCKED==TRUE){
                if (gameMenuState==CLOSED){
                    llSetTimerEvent(20);//set timer to close game menu
                    openGameMenu();
                    }
                    else
                if (gameMenuState==OPEN){
                    closeGameMenu();                   
                }                    
            }else
            if (button=="HELP"){
                    llShout(0,"Puzzle Game Help Video: "+HELPURL);
            }else
            if (button=="RESET"&&UNLOCKED==TRUE){
                 tellPuzzlePieces("DIE");
                state rezzing;
            }else
            if (button=="SHOW NAMES"&&UNLOCKED==TRUE){
               tellPuzzlePieces("SHOW_NAMES");
               debug("showing names"); 
            }else
            if (button=="SCATTER"&&UNLOCKED==TRUE){
               if (screenState==OPEN){
               	llMessageLinked(LINK_SET, SCATTER_CHANNEL, "scatter", NULL_KEY);
               }else{
               		tellPuzzlePieces("SCATTER");
               }
            }else
            if (button=="PUSH"&&UNLOCKED==TRUE){
                tellPuzzlePieces("PUSH");
                 
            }else
             if (button=="CLEAR"&&UNLOCKED==TRUE){
                tellPuzzlePieces("DIE");
                 
            }else
             if (button=="SCREEN"&&UNLOCKED==TRUE){
              if (screenState==CLOSED){
                    openScreen();
                    }
                    else
                if (screenState==OPEN){
                    closeScreen();                   
                }    
                 
            }else
            if (button=="PULL"&&UNLOCKED==TRUE){
                tellPuzzlePieces("PULL");
                 
            }else{
                //else its a tile   
                moveTile(userKey,linkNum);
        
            }
        }
    }
    timer() {
        integer len=llGetNumberOfPrims();
        integer i;
        llSetTimerEvent(0);
        for (i=0;i<len;i++){
            if (llGetLinkName(i)!="SETTINGS"){
            llSetLinkColor(i, WHITE, ALL_SIDES);
            }
        }
         closeGameMenu();
    }
     changed(integer change)
    {
        if(change & (CHANGED_INVENTORY)) // Either of the changes will return true.
           loadTextures();
    }
}

state rezzing{
    state_entry() {
        puzzlePieces=[];
        debug("Rezzing State");
        integer i;
        vector myPos = llGetPos();
        rotation myRot = llGetRot();
        counter =0;
        rotation relativeRot = <0.0, 0.0, 0.0, 0.707107>; // Rotated 90 degrees on the x-axis compared to this prim
        //set texture of tips screen
        

        for (i=0;i<25;i++){
            vector pos = getLinkPos("puzzlePiece"+(string)i);
            vector relativePosOffset =<pos.x,pos.y,pos.z+0.4>; 
            vector rezPos = myPos+relativePosOffset *myRot;
            rotation rezRot = relativeRot*myRot;
            llRezObject("puzzlePiece", rezPos, ZERO_VECTOR, rezRot, i);
            
        }
    }
   
    object_rez(key id) {
        debug("rezzed puzzlePiece "+(string)rezCounter);
        puzzlePieces+=id;       
        llGiveInventory(id, myPuzzleTexture);
        debug("Giving "+myPuzzleTexture +" to "+llKey2Name(id));
        rezCounter++;
        if (rezCounter>24)state go;
    }

}
