integer myLink;

default{
    state_entry() {
        myLink = llGetLinkNumber();
 //       llOwnerSay((string)myLink);
    }
    link_message(integer n, integer c, string m, key id){
          if (c!=-1988) return;
             myLink = llGetLinkNumber();
           //       llOwnerSay((string)"mylink is "+(string)myLink+" "+m);
        vector lSize = llList2Vector(llGetLinkPrimitiveParams(1,[7]),0);
        if(m == "close screen"){
            llSetLinkPrimitiveParamsFast(myLink,[
                7, <0.518463*lSize.x, 0.019317*lSize.y, 4.751806*lSize.z>, 33, <0.000049*lSize.x, -0.000015*lSize.y, 0.244727*lSize.z>, 29, <0.713242, 0.000000, 0.000000, 0.700918>
            ]);
        }
        if(m == "open screen"){
            llSetLinkPrimitiveParamsFast(myLink,[7, <0.518463*lSize.x, 0.401609*lSize.y, 4.751806*lSize.z>, 33, <0.000049*lSize.x, -0.000015*lSize.y, 6.824183*lSize.z>, 29, <0.713242, 0.000000, 0.000000, 0.700918>]);
        }
    }
}

