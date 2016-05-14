import g4p_controls.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.sound.*;

SoundFile   redFile, greenFile, blueFile, filetoPlay;
Minim       minim;
AudioOutput out;
Oscil       wave;
float       rate, amp; 
String cor = "Background";
int backgroundCor = 255;

public void setup(){
  size(800, 600, JAVA2D);
  createGUI();
  customGUI();
  background(backgroundCor);
  
  minim = new Minim(this);
  out = minim.getLineOut();  
  //wave = new Oscil( 440, 2f, Waves.SAW );
  //wave.patch( out );
  
  redFile = new SoundFile(this, "pianocortado.wav");
  greenFile = new SoundFile(this, "guitarcortado.wav");
  blueFile = new SoundFile(this, "basscortado.wav");
}

public void draw(){
  confereCor();
  
  colorMode(RGB,255,255,255,height);
  
  if ((mousePressed) && (mouseInDrawingRange()) && cor!="Background"){
    line(mouseX, mouseY, pmouseX, pmouseY);
    amp = map(mouseY, sketchPad1.getY(), (sketchPad1.getY()+sketchPad1.getHeight()), 1, 0);
    rate = map(mouseX, sketchPad1.getX(), (sketchPad1.getY()+sketchPad1.getHeight()), 1, 2);
    filetoPlay.play(rate, amp);
    //wave.setAmplitude(map(mouseY, 0, height, 1, 0));
    //wave.setFrequency(map(mouseX, 0, width, 110, 880));
  } else {
    //wave.setAmplitude(map(height, 0, height, 1, 0));
  }
}

public void changeColor(String novacor) {
  cor = novacor;
}

public void confereCor() {
  if (cor == "Red") {
    stroke(255, 0, 0,(height-mouseY));
    filetoPlay = redFile;
  }
  else if (cor == "Green") {
    stroke(0, 255, 0,(height-mouseY));
    filetoPlay = greenFile;
  }
  else if (cor == "Blue") {
    stroke(0, 0, 255,(height-mouseY));
    filetoPlay = blueFile;
  }
  else {
    stroke(backgroundCor);
  }
}

public boolean mouseInDrawingRange(){
  if (mouseX >= sketchPad1.getX() &&
      mouseX <= sketchPad1.getX() + sketchPad1.getWidth() && 
      mouseY >= sketchPad1.getY() &&
      mouseY <= sketchPad1.getY() + sketchPad1.getHeight()) {
    return true;
  } else {
    return false;
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}