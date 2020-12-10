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

int universeSize = 450;
byte[] dmxData = new byte[450];
byte[] dmxData2 = new byte[450];
ArrayList<Byte> data = new ArrayList<Byte>();
int val = 0;

int pos = 170;
int c = 0;
int maxLength = 600;
int LEDperSegment = 170;
int mode = 1;

void setup() {
  size(275, 300);
  surface.setLocation(0, 0);
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();

  black();
  
  data.add(byte(255));
}


void draw() {
  background(153);
  //black();
  //delay(200);
  
    
  /*
    dmxData[3] = (byte)255;
    dmxData[4] = (byte)255;
    dmxData[5] = (byte)255;
    
    dmxData[9] = (byte)255;
    dmxData[10] = (byte)255;
    dmxData[11] = (byte)255;
    
    dmxData[24] = (byte)255;
    dmxData[25] = (byte)255;
    dmxData[26] = (byte)255;
    */
    /*dmxData[6] = (byte)255;
    dmxData[7] = (byte)255;
    dmxData[8] = (byte)255;*/
  
    //dmxData[9] = (byte)255;
    //dmxData[10] = (byte)255;
    //dmxData[11] = (byte)255;
    
    //dmxData[501] = (byte)255;
    //dmxData[502] = (byte)255;
    //dmxData[503] = (byte)255;
    
    int d = 1*3;
    dmxData[d+0] = (byte)255;
    dmxData[d+1] = (byte)255;
    dmxData[d+2] = (byte)255;
    
    
    dmxData2[0] = (byte)255;
    dmxData2[1] = (byte)255;
    dmxData2[2] = (byte)255;
    
    dmxData2[3] = (byte)255;
    dmxData2[4] = (byte)255;
    dmxData2[5] = (byte)255;
    
    dmxData2[30] = (byte)255;
    dmxData2[31] = (byte)255;
    dmxData2[32] = (byte)255;
  
  for(int i = 0; i<8; i++) {
    artnet.unicastDmx("10.77.88.243", 0, i, dmxData);
    artnet.unicastDmx("2.0.0.24", 0, i, dmxData);
  }
  
  
  //artnet.unicastDmx("10.77.88.243", 0, 0, dmxData);
  //artnet.unicastDmx("10.77.88.243", 0, 1, dmxData2);
  
  
  delay(500);
  
}

void black() {
  for(int i = 0; i<450; i++) {
    dmxData[i] = (byte)0;
  }
  for(int u = 0; u<4; u++) artnet.unicastDmx("10.77.88.243", 0, u, dmxData); 
}
