
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
integer SCATTER_CHANNEL=-8821;
integer PUZZLE_FUN_MAIN=-72221;
integer SCREEN_CHANNEL=-1988;
integer endTime = 10;
integer count=0;
default {
     on_rez(integer start_param) {
       
        llResetScript();
        
    }
    link_message(integer sender_num, integer num, string str, key id) {
        if (num!=SCATTER_CHANNEL)return;
        if (str=="delay scatter"){
            llSetTimerEvent(1);
        }else
        if (str=="reset timer"){
            llSetTimerEvent(0);
            llSetText("", GREEN, 1);
            count=0;
        }
    }
    timer() {
    	string text = "";
    	count++;
    	text="Starting game in "+(string)(endTime-count)+ " seconds";
        llSetText(text, GREEN, 1); 
        if (endTime-count<=0){
        	count=0;
        	llSetTimerEvent(0);
        	llMessageLinked(LINK_SET, PUZZLE_FUN_MAIN, "scatter", NULL_KEY);
        	llSetText("", GREEN, 1);
        }else if (endTime-count<=5){
    		llTriggerSound("beepbeep", 1);
        }
        else {
    		llTriggerSound("beep", 1);
        }    
        
    }    
}
