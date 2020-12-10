// ArtNet Node
class Controller {
  
  
  String ip = "";
  Port[] ports = new Port[2];
  public Controller(String _ip) {
    ip = _ip;
  }
  
  // Ethernet Port
  class Port {
    Segment segment = new Segment();
    public Port() {
    }
    
    //
    class Segment {
      Universe[] universes = new Universe[4];
      public Segment() {
      }
      
      // Universe holds 170 LED Values
      class Universe {
        int nr = 0;
        byte[] values = new byte[170];
        public Universe() {
        }
      } // End Class: Universe
      
    } // End Class: Segment
    
  } // End Class: Port

} // End Class: Controller
