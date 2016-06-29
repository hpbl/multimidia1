import g4p_controls.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.sound.*;

Minim minim;
AudioOutput out;
Oscil wave;
Midi2Hz midi;

AudioRecorder recorder;
AudioInput input;
int countAudios = 0;
AudioPlayer loopPlayer;

float rate, amp; 
String cor = "Background";
int backgroundCor = 255;
int nota = 0;
boolean shouldPlay = false;
boolean microfone = false;
boolean gravando = false;

int notaOffset = 0;
int tamanhoPincel;

public void setup() {
    size(800, 600, JAVA2D);
    createGUI();
    customGUI();
    background(backgroundCor);
    
    tamanhoPincel = 6;

    minim = new Minim(this);
    input = minim.getLineIn();
    out = minim.getLineOut();

    // the frequency argument is not actually important here
    // because we will be patching in Midi2Hz
    wave = new Oscil(300, 0.6f, Waves.TRIANGLE);

    // make our midi converter
    midi = new Midi2Hz(nota);

    midi.patch(wave.frequency);
    wave.patch(out);
}

public void draw() {
    confereCor();
    colorMode(RGB, 255, 255, 255, height);

    if ((mousePressed) && (mouseInDrawingRange()) && cor != "Background") {
        //grossura da reta = 6
        strokeWeight(tamanhoPincel);
        line(mouseX, mouseY, pmouseX, pmouseY);
        //grossura da reta = 2
        strokeWeight(2);
        //o quão longe a minireta em volta da reta principal vai ser desenhada
        int desvio = 10;
        //minireta
        line(mouseX + random(-desvio,desvio), mouseY + random(-desvio,desvio), pmouseX + random(-desvio,desvio), pmouseY + random(-desvio,desvio));

        float m1 = mouseX;

        float w = sketchPad1.getX() + sketchPad1.getWidth();
        float i = sketchPad1.getX();

        int larg = int(w/12);

        if (m1<i+larg) {
            nota = 60;
        }
        else if (m1<i+larg*2) {
            nota = 61;
        }
        else if (m1<i+larg*3) {
            nota = 62;
        }
        else if (m1<i+larg*4) {
            nota = 63;
        }
        else if (m1<i+larg*5) {
            nota = 64;
        }
        else if (m1<i+larg*6) {
            nota = 65;
        }
        else if (m1<i+larg*7) {
            nota = 66;
        }
        else if (m1<i+larg*8) {
            nota = 67;
        }
        else if (m1<i+larg*9) {
            nota = 68;
        }
        else if (m1<i+larg*10) {
            nota = 69;
        }
        else if (m1<i+larg*11) {
            nota = 70;
        }
        else if (m1<i+larg*12) {
            nota = 71;
        }        

        nota = nota + notaOffset;
        amp = map(mouseY, sketchPad1.getY(), (sketchPad1.getY() + sketchPad1.getHeight()), 1, 0);
        wave.setAmplitude(amp);
        midi.patch(wave.frequency);

        if(microfone == false) {
            midi.setMidiNoteIn(nota); 
        }
        else {
            midi.setMidiNoteIn(0); 
        }
    }
    else {
        midi.setMidiNoteIn(0);
    }

}

void keyPressed() {
    if (key == 'r' && (!gravando)) {
        gravando = true;
        countAudios++;
        recorder = minim.createRecorder(input, "audio" + countAudios + ".wav", true);
        recorder.beginRecord();
    }
    else if (key == 'm' && (!gravando)) {
        gravando = true;
        countAudios++;
        recorder = minim.createRecorder(input, "audio" + countAudios + ".wav", true);
        recorder.beginRecord();
        microfone = true;
    }
    else if (key == '+') {
        if (tamanhoPincel < 100) {
            tamanhoPincel = tamanhoPincel + 2;
        }
    }
    else if (key == '-') {
        if (tamanhoPincel > 2) {
            tamanhoPincel = tamanhoPincel - 2;
        }
    }
    else if (key == 'g') {
        paintGrid();
    }
    else if (key == 'c') {
        background(backgroundCor);
    }
}

void keyReleased() {
    gravando = false;
    if (key == 'r') {
        recorder.endRecord();
        recorder.save();
        loopPlayer = minim.loadFile("audio" + countAudios + ".wav");
        loopPlayer.loop();
    }
    else if (key == 'm') {
        recorder.endRecord();
        recorder.save();
        loopPlayer = minim.loadFile("audio" + countAudios + ".wav");
        loopPlayer.loop();
        microfone = false;
    }
}

public void changeColor(String novacor) {
    cor = novacor;
}

public void confereCor() {
    if (cor == "Red") {
        stroke(255, 0, 0, (height-mouseY));
        notaOffset = -12;
    }
    else if (cor == "Green") {
        stroke(0, 255, 0, (height-mouseY));
        notaOffset = 0;
    }
    else if (cor == "Blue") {
        stroke(0, 0, 255, (height-mouseY));
        notaOffset = 12;
    }
    else {
        stroke(backgroundCor);
    }
}

public boolean mouseInDrawingRange() {
    if (mouseX >= sketchPad1.getX() &&
        mouseX <= sketchPad1.getX() + sketchPad1.getWidth() && 
        mouseY >= sketchPad1.getY() &&
        mouseY <= sketchPad1.getY() + sketchPad1.getHeight()) {
        return true;
    }
    else {
        return false;
    }
}

public void playSound() {

}

public void paintGrid() {
    float w = sketchPad1.getX() + sketchPad1.getWidth();
    float i = sketchPad1.getX();

    int larguraLinhas = int(w/12);
    int linhas = 1;
    stroke(0,0,0,18);
    while(linhas < 12){
        i = i + larguraLinhas;
        line(i, sketchPad1.getY(), i, sketchPad1.getHeight());
        linhas++;
    }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {

}