class Handle {
  
  int x, y;
  int boxx, boxy;
  int stretch;
  int size;
  int mywidth;
  int id;
  boolean over;
  boolean press;
  boolean invert = false;
  boolean locked = false;
  boolean otherslocked = false;
  Handle[] others;
  
  Handle(int index, int ix, int iy, int il, int is, int iw, Handle[] o) {
    id = index;
    x = ix;
    y = iy;
    stretch = il;
    size = is;
    mywidth = iw;
    boxx = x+stretch - size/2;
    boxy = y - size/2;
    others = o;
  }
  
  void update() {
    boxx = x+stretch;
    boxy = y - size/2;
    
    for (int i=0; i<others.length; i++) {
      if (others[i].locked == true) {
        otherslocked = true;
        break;
      } else {
        otherslocked = false;
      }  
    }
    
    if (otherslocked == false) {
      overEvent();
      pressEvent();
    }
    
    if (press) {
      stretch = lock(mouseX-size/2-x, 0, mywidth-size);
    }
  }
  
  void overEvent() {
    if (overRect(boxx, boxy, size, size)) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void pressEvent() {
    if (over && mousePressed || locked) {
      press = true;
      locked = true;
    } else {
      press = false;
    }
  }
  
  void releaseEvent() {
    locked = false;
  }
  
  void display() {
    fill(255);
    if (invert) fill(0);
    stroke(0);
    rect(x, boxy, mywidth, size);
    fill(0);
    if (invert) fill(255);
    stroke(0);
    rect(x, boxy, stretch, size);
    fill(255);
    stroke(0);
    rect(boxx, boxy, size, size);
    if (over || press) {
      line(boxx, boxy, boxx+size, boxy+size);
      line(boxx, boxy+size, boxx+size, boxy);
    }

  }
}