class State {
  void upd() {}
  void mPressed() {}
  void bPressed() {}
}
class Main extends State {
  Main() {}
  void upd() {
    fill(0,170);
    noStroke();
    rect(20,height*0.6,width-40,height*0.3,10);
    fill(255);
    textSize(40);
    textAlign(LEFT,TOP);
    text(engine.text,50,height*0.6+10,width-70,height*.3-20);
  }
  void mPressed() {
    engine.step();
  }
}
class Choose extends State {
  String q;
  String[] ch;
  Choose(String s,String[] c) {
    q=s;ch=c;
  }
  void upd() {
    textSize(40);
    textAlign(CENTER,CENTER);
    text(q,width*3/4,height/2);
    
  }
}