/**
 * Handles. 
 * 
 * Click and drag the white boxes to change their position. 
 */

import ch.bildspur.artnet.*;

ArtNetClient artnet;

int universeSize = 450;
byte[] dmxData = new byte[450];
int val = 0;

int c = 0;


void setup() {
  size(275, 300);
  
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();

  int num = 4;
  for(int i = 0; i<450; i++) {
    dmxData[i] = (byte)0;
  }
  artnet.unicastDmx("10.77.88.243", 0, 1, dmxData);
  artnet.unicastDmx("10.77.88.243", 0, 2, dmxData);
}


void draw() {
  background(153);
  for(int i = 0; i<450;i++) dmxData[i] = (byte)0;
  ;
  dmxData[c] = (byte)255;
  dmxData[(c+1)%450] = (byte)255;
  dmxData[(c+2)%450] = (byte)255;
  
  
  // led pair über mounting holes
  //dmxData[25] = (byte)val;
  //dmxData[67] = (byte)val;
  
  //dmxData[0] = (byte)val;
  //dmxData[1] = (byte)val;
  
  
  
  println(c);
   
  for(int i = 0; i<8; i++) {
    artnet.unicastDmx("10.77.88.243", 0, i, dmxData);
  }
    
  
  
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      c++;
      c%=450;
    } else if (keyCode == DOWN) {
      c--;
      if(c<0) c = 449;
    } 
  }
}
