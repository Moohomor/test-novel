Engine engine;
Screen screen;
State state;
PImage prev;
long prevtap=millis();
ArrayList<PImage> chrs=new ArrayList<PImage>();
PImage bg;
HashMap<String,PImage> imdata=new HashMap<String,PImage>();
HashMap<String,String> vars=new HashMap<String,String>();
color cbg=0;
void setup() {
  loadData();
  screen=new Menu();
  prev=get();
}

void draw() {
  screen.upd();
  if (millis()-prevtap<200) {
    tint(255,255*50/(millis()-prevtap));
    image(prev,0,0);
  }
  tint(255,255);
  textAlign(LEFT,BOTTOM);
  fill(0,120);
  noStroke();
  rect(20,20,200,80,20);
  fill(255,210);
  textSize(40);
  text("FPS: "+int(frameRate),50,70);
}
void mousePressed() {
  prev=get();
  prevtap=millis();
  screen.mPressed();
}
@Override
public void onBackPressed() {
  screen.bPressed();
}
void setbg(PImage im) {
  bg=im;
  bg.resize(width,height);
}
void loadData() {
  for (String name:new File(
    sketchPath("")).list()) {
    String naml=name.toLowerCase();
    if (naml.endsWith(".png")||
        naml.endsWith(".jpg")) {
      imdata.put(name,loadImage(name));
    }
  }
}