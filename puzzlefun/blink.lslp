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
integer SLOODLE_OBJECT_BLINK= -1639271135; //linked message channel to tell a prim to blink
default {
    state_entry() {

    }
    link_message(integer sender_num, integer num, string str, key id) {
        if (num==SLOODLE_OBJECT_BLINK){
            llSetColor(GREEN, ALL_SIDES);
            llSetTimerEvent(3);
        }
    }
    timer() {
            llSetTimerEvent(0);
            llSetColor(WHITE, ALL_SIDES);
    }
}
