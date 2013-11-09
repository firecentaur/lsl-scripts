
integer SCATTER_CHANNEL=-8821;
integer PUZZLE_FUN_MAIN=-72221;
integer SCREEN_CHANNEL=-1988;

default {
    state_entry() {
       
    }
    link_message(integer sender_num, integer num, string str, key id) {
        if (num!=SCATTER_CHANNEL)return;
        if (str=="delay open"){
            
            llSetTimerEvent(2);
        }
    }
    timer() {
        llSetTimerEvent(0);
        llMessageLinked(LINK_SET, SCREEN_CHANNEL, "open screen", NULL_KEY);
    }    
}
