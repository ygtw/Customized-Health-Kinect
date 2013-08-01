class btn {
  int x, y, w, h, isOver=0,buy=0,menuPrice=10;
  // Constructor
  btn(int tx, int ty, int tw, int th,int tmenuPrice) {
    x=tx;
    y=ty;
    w=tw;
    h=th;
    tmenuPrice = menuPrice;
  }

  boolean overRect(int mx, int my) {
//     println(x +" "+y +" "+ mx +" "+my);

    if (mx >= x && mx <= x+w && 
      my >= y && my <= y+h) {

      if (isOver==0)
      {    
        w= w+10;
        h= h+10;
        isOver =1;
          if(BodyZ-RhandZ>450)
          {
            buy=1;
            money = money+ menuPrice;
          }
        
      }
      return true;
    } 
    else {
      if (isOver==1)
      {
        w= w-10;
        h= h-10;
        isOver = 0;
      }
      return false;
    }
  }


  void display() {
    
    if(buy==1)
    {
stroke(220, 20, 20);
strokeWeight(10);  // Default

noFill();

     ellipse(x, y-h/2 , w/2, h/2); 
    }
    
  }
}

