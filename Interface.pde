import g4p_controls.*;

// Need G4P library
import g4p_controls.*;

String cor = "Background";
int backgroundCor = 102;

public void setup(){
  size(800, 600, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  background(backgroundCor);
  
}

public void draw(){
  confereCor();
  
  if ((mousePressed == true) && (mouseInDrawingRange())) {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

public void changeColor(String novacor) {
  cor = novacor;
}

public void confereCor() {
  if (cor == "Red") {
    stroke(255, 0, 0);
    
  }
  else if (cor == "Green") {
    stroke(0, 255, 0);
    
  }
  else if (cor == "Blue") {
    stroke(0, 0, 255);
    
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