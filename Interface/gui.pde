/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void clickRedButton(GButton source, GEvent event) { //_CODE_:buttonRed:352242:
  //println("buttonRed - GButton >> GEvent." + event + " @ " + millis());
  changeColor("Red");
} //_CODE_:buttonRed:352242:

public void clickGreenButton(GButton source, GEvent event) { //_CODE_:buttonGreen:312446:
  //println("buttonGreen - GButton >> GEvent." + event + " @ " + millis());
  changeColor("Green");
} //_CODE_:buttonGreen:312446:

public void clickBlueButton(GButton source, GEvent event) { //_CODE_:blueButton:505366:
  //println("blueButton - GButton >> GEvent." + event + " @ " + millis());
  changeColor("Blue");
} //_CODE_:blueButton:505366:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Sketch Window");
  labelCor = new GLabel(this, 0, 550, 200, 50);
  labelCor.setText("escolha a cor:");
  labelCor.setTextBold();
  labelCor.setOpaque(true);
  sketchPad1 = new GSketchPad(this, 20, 20, 760, 510);
  buttonRed = new GButton(this, 200, 550, 200, 50);
  buttonRed.setLocalColorScheme(GCScheme.RED_SCHEME);
  buttonRed.addEventHandler(this, "clickRedButton");
  buttonGreen = new GButton(this, 400, 550, 200, 50);
  buttonGreen.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  buttonGreen.addEventHandler(this, "clickGreenButton");
  blueButton = new GButton(this, 600, 550, 200, 50);
  blueButton.addEventHandler(this, "clickBlueButton");
}

// Variable declarations 
// autogenerated do not edit
GLabel labelCor; 
GSketchPad sketchPad1; 
GButton buttonRed; 
GButton buttonGreen; 
GButton blueButton; 