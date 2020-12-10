/*
   1m =  60 LEDs
   5m = 300 LEDs
  10m = 600 LEDs
  15m = 900 LEDs
  20m = 1200 LEDs
  
  60 LEDs  = 1m
  
  680 LEDs =  11,3m
  
  SOLVE:
  600 LEDs = 10m
  60 LEDs  = 01m
  = 20 LEDs vernachlässigen?
  
  512 Channels / 3 RGB = 170 LEDs pro Universum|Segment
  680 LEDs pro Port
  680 LEDs pro Port / 170 LEDs pro Segment = 4 Segmente pro Port
  
  Netzteil
  --------
  1200 * 60mA
  100 * 60mA = 6000mA = 6A == port maximum
  72000 mA = 72A (ugh..)
  
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
Controller controller;
boolean online = true;
int c = 0;

color white = color(255, 255, 255);
color blue = color(0, 0, 255);
color what = color(255, 125, 0);

int volume = 1;

void setup() {
  size(1100, 250);
  surface.setLocation(0,0);
  
  artnet = new ArtNetClient(null);
  artnet.start();
  
  controller = new Controller("10.77.88.243");
  controller.black();
  controller.send();
  
  rectMode(CENTER);
}

void draw() {
  background(0);
  println(">> new loop");
  controller.black();
  //controller.send();
  println(">> set all pixels to black");
  println();
  for(int i = 0; i<volume; i++) controller.setPixels(c+i, white);
  
  //println("c= " + c);
  controller.update();
  controller.display();
  
  c+=volume;
  c %= 900;
  controller.send();
  
  
}
