string lAnimName = "clearbutton";// Name used for link messages.
integer myLink;
default{
    state_entry() {
            myLink = llGetLinkNumber();
    }
    link_message(integer n, integer c, string m, key id){
        myLink = llGetLinkNumber();
        vector lSize = llList2Vector(llGetLinkPrimitiveParams(1,[7]),0);
        if(m == "p0"){
            llSetLinkPrimitiveParamsFast(myLink,[
                33, <0.018789*lSize.x, -0.315683*lSize.y, 0.228943*lSize.z>, 29, <0.000000, 0.000000, 0.000000, 1.000000>
            ]);
        }
        if(m == "p1"){
            llSetLinkPrimitiveParamsFast(myLink,[33, <0.110640*lSize.x, -0.816832*lSize.y, 0.523911*lSize.z>, 29, <0.000000, 0.000000, 0.000000, 1.000000>

            ]);
        }
    }
}
