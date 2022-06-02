//keyValuesToString will take a list of values and demonstrate how to return a string which could be modified to send to an api
keyValuesToString(list keyValues)
{
    integer index=0;
    list records = llList2ListStrided(keyValues,0,-1,2);
    integer length = llGetListLength(records);
    llSay(0,"Length of records is : "+(string)length);
    integer stride=2;
    while (index < length) {
      list item = llList2List(keyValues,index+index,index*stride+1);
      string param = llList2String(item, 0);
      string value = llList2String(item, 1);
      llSay(0,(string)index+": key:"+param+", value:"+value); index++;
   }
}
default {
  state_entry()
  {
     llSay(0,"-----");
     list paramList=["name","fire","email","fire@b3dmultitech.com"]; keyValuesToString(paramList);
  }
}