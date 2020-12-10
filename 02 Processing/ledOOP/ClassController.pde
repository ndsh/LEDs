import ch.bildspur.artnet.*;

ArtNetClient artnet;

// ArtNet Node
class Controller {
  PVector pos;
  int howManyLEDsPerSegment = 600;
  String ip = "";
  Port[] ports = new Port[2];
  
  public Controller(String _ip) {
    pos = new PVector(width/2, height/2);
    ip = _ip;
    println("Created Controller with the IP= " + ip);
    for(int i = 0; i<ports.length; i++) ports[i] = new Port(i);
  }
  
  void send() {
    //for(int i = 0; i<ports.length; i++) ports[i].send();
    ports[0].send();
    ports[1].send();
    ports[0].segment.reset();
    ports[1].segment.reset();
  }
  
  void setPixels(int pixel, color c) {
    if(pixel <= howManyLEDsPerSegment) ports[0].segment.setPixels(pixel, c);
    else ports[1].segment.setPixels(pixel, c);
  }
  
  void black() {
    for(int i = 0; i<2; i++) {
      for(int j = 0; j<howManyLEDsPerSegment; j++) ports[i].segment.setPixels(j);
    }
  }
  
  void update() {
  }
  void display() {
    push();
    translate(pos.x, pos.y);
    noFill();
    stroke(white);
    strokeWeight(3);
    rect(0, 0, 120, 160);
    pop();
    
    ports[0].segment.display();
    ports[1].segment.display();
  }
  
  // Ethernet Port
  class Port {
    int nr = 0;
    Segment segment;
    
    public Port(int i) {
      nr = i;
      println(">> Created Port= " + nr);
      segment = new Segment();
    }
    
    void send() {
      segment.send();
    }
    
    // A Segment is a longer strip of LEDs, possibly going over two long strips
    class Segment {
      Universe[] universes = new Universe[4];
      int LEDperSegment = 150;
      
      public Segment() {
        
        println(">> >> Created Segment");
        for(int i = 0; i<universes.length; i++) universes[i] = new Universe(i);
      }
      
      int pixel2universe(int c) {
        return int(c/LEDperSegment);
      }

      void setPixels(int pixel, color c) {
        universes[pixel2universe(pixel)%4].setPixels(pixel, c); // OutOfBounds: 4
      }
      
      void setPixels(int pixel) {
        universes[pixel2universe(pixel)].setPixels(pixel); // OutOfBounds: 4
      }
      
      void send() {
        for(int u = 0; u<universes.length; u++) {
          if(online) {
            println(">> >> Send data to u= "+ universes[u].getUniverseName());
            artnet.unicastDmx(ip, 0, universes[u].getUniverseName(), universes[u].getData());
          }
        }
      }
      
      void reset() {
        for(int u = 0; u<universes.length; u++) {
            universes[u].reset();
        }
      }
      
      void display() {
        for(int i = 0; i<universes.length; i++) {
          //universes[i].getData()
          push();
          translate(pos.x, pos.y+(10*i));
          stroke(white);
          noFill();
          
          if(nr == 0) {
            rect(0, -100, 1000, 10);
            push();
            noStroke();
            translate(-495, -100);
            for(int j = 0; j<LEDperSegment; j++) {
              color c = color(universes[i].getIntData()[(j*3)+0], universes[i].getIntData()[(j*3)+1], universes[i].getIntData()[(j*3)+2]);
              fill(c);
              rect(j*6.65, 0, 4, 4);
            }
            pop();
          } else if(nr == 1) {
            rect(0, 80, 1000, 10);
            push();
            noStroke();
            translate(-495, 80);
            for(int j = 0; j<LEDperSegment; j++) {
              color c = color(universes[i].getIntData()[(j*3)+0], universes[i].getIntData()[(j*3)+1], universes[i].getIntData()[(j*3)+2]);
              fill(c);
              rect(j*6.65, 0, 4, 4);
            }
            pop();
          }
          pop();
        }
      }
      
      // Universe holds 170 LED Values
      // aka a full ArtNet Frame
      class Universe {
        int u = 0;
        int universeName = 0;
        byte[] values = new byte[(LEDperSegment*3)];
        int[] intValues = new int[(LEDperSegment*3)];
        boolean changed = false;
        
        public Universe(int i) {
          u = i;
          universeName = ((nr*4)+i);
          println(">> >> >> >> Created Universe= "+ u);
        }
        
        void setPixels(int pixel, color c) {
          print(">> >> >> >> >> >> >> >> setPixel(" + pixel + ") in universe= "+ u +" on port= ("+ nr +")");
          pixel %= howManyLEDsPerSegment;
          changed = true;
          int[] nr = {
            ((pixel*3)+0)%(values.length),
            ((pixel*3)+1)%(values.length),
            ((pixel*3)+2)%(values.length)
          };
          
          int[] clean = {
            ((pixel*3)+0),
            ((pixel*3)+1),
            ((pixel*3)+2)
          };
          println(" :: " + nr[0] +"("+clean[0]+")" + " :: " + nr[1] +"("+clean[1]+")" + " :: " + nr[2] +"("+clean[2]+")" ) ;
          values[nr[0]] = (byte)(c >> 16 & 0xFF);
          values[nr[1]] = (byte)(c >> 8 & 0xFF);
          values[nr[2]] = (byte)(c & 0xFF);
          
          intValues[nr[0]] = (c >> 16 & 0xFF);
          intValues[nr[1]] = (c >> 8 & 0xFF);
          intValues[nr[2]] = (c & 0xFF);
          
        }
        
        void setPixels(int pixel) {
          pixel %= howManyLEDsPerSegment;
          int[] nr = {
            ((pixel*3)+0)%(values.length),
            ((pixel*3)+1)%(values.length),
            ((pixel*3)+2)%(values.length)
          };
          values[nr[0]] = (byte)0;
          values[nr[1]] = (byte)0;
          values[nr[2]] = (byte)0;
          
          intValues[nr[0]] = 0;
          intValues[nr[1]] = 0;
          intValues[nr[2]] = 0;
        }
        
        byte[] getData() {
          return values;
        }
        
        int[] getIntData() {
          return intValues;
        }
        
        void reset() {
          changed = false;
        }
        
        boolean hasChanged() {
          return changed;
        }
        
        int getUniverseName() {
          return universeName;
        }
        
      } // End Class: Universe
      
    } // End Class: Segment
    
  } // End Class: Port

} // End Class: Controller
