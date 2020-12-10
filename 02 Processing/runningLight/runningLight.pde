/*
   1m =  60 LEDs
   5m = 300 LEDs
  15m = 900 LEDs
  
  60 LEDs  = 1m
  
  680 LEDs =  11,3m
  
  SOLVE:
  600 LEDs = 10m (80 LEDs vernachlässigen?)
  
  512 Channels / 3 RGB = 170 LEDs pro Universum|Segment
  680 LEDs pro Port
  680 LEDs pro Port / 170 LEDs pro Segment = 4 Segmente pro Port
  
*/

/*
  OOP Struktur
  -----------------------------------------
    DIGITIZE Network (12-13 Controllers)
      Controller (IP, 2 Ports)
      - IP
      - Ports (4 Segments)
        Port
          - Segment (Universe 1)
            - 170 LEDs
          - Segment (Universe 2)
            - 170 LEDs
          - Segment (Universe 3)
            - 170 LEDs
          - Segment (Universe 4)
            - 170 LEDs
        Port
          - Segment (Universe 5)
            - 170 LEDs
          - Segment (Universe 6)
            - 170 LEDs
          - Segment (Universe 7)
            - 170 LEDs
          - Segment (Universe 8)
            - 170 LEDs
  -----------------------------------------
*/

import ch.bildspur.artnet.*;

ArtNetClient artnet;

int universeSize = 512;
byte[] dmxData = new byte[512];
int val = 0;

int pos = 170;
int c = 0;
int maxLength = 600;
int LEDperSegment = 170;
int mode = 1;

void setup() {
  size(275, 300);
  
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();

  black();
}


void draw() {
  background(153);
  black();
  
  if(mode == 0) {
  float val = (exp(sin(millis()/2000.0*(PI/2))) - 0.36787944)*108.0;
  
  dmxData[(pos+0)%512] = (byte)val;
  dmxData[(pos+1)%512] = (byte)val;
  dmxData[(pos+2)%512] = (byte)val;
  } else if(mode == 1) {
    dmxData[(pos+0)%512] = (byte)255;
    dmxData[(pos+1)%512] = (byte)255;
    dmxData[(pos+2)%512] = (byte)255;
  }
  //c+=3;
  //c%=170;
  artnet.unicastDmx("10.77.88.243", 0, pixel2universe(pos), dmxData);
  print("u=" + pixel2universe(pos) + " | ");
  println("pos=" + pos);
  
  
  
  if(mode == 0) pos++;
  pos %= maxLength;
  
  
}

int pixel2universe(int c) {
  return int(c/LEDperSegment);
}

void black() {
  for(int i = 0; i<512; i++) {
    dmxData[i] = (byte)0;
  }
  for(int u = 0; u<4; u++) artnet.unicastDmx("10.77.88.243", 0, u, dmxData); 
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      pos+=3;
      pos%=maxLength;
    } else if (keyCode == DOWN) {
      pos-=2;
      if(pos<0) pos = maxLength-1;
    } 
  }
}
