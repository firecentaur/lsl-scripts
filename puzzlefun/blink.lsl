// LSL script generated: blink.lslp Sun Oct 27 23:25:47 Taipei Standard Time 2013

vector GREEN = <0.0,1.0,0.0>;
vector WHITE = <1.0,1.0,1.0>;
integer SLOODLE_OBJECT_BLINK = -1639271135;
default {

    state_entry() {
    }

    link_message(integer sender_num,integer num,string str,key id) {
        if ((num == SLOODLE_OBJECT_BLINK)) {
            llSetColor(GREEN,ALL_SIDES);
            llSetTimerEvent(3);
        }
    }

    timer() {
        llSetTimerEvent(0);
        llSetColor(WHITE,ALL_SIDES);
    }
}
