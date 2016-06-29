import g4p_controls.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.sound.*;

// variaveis para sons
Minim minim;
AudioOutput out;
Oscil wave;
Midi2Hz midi;

// variaveis para gravacao, contagem e loop dos sons
AudioRecorder recorder;
AudioInput input;
int countAudios = 0;
AudioPlayer loopPlayer;

// variaveis para manipular frequencia e amplitude dos sons
float rate, amp; 

String cor = "Background";
int backgroundCor = 255;

// variavel para definicao do tom do som (calculado em funcao de rate)
int nota = 0;

// booleans para manipulacao de gravacao e loop dos sons
boolean shouldPlay = false;
boolean microfone = false;
boolean gravando = false;

// variavel de definicao da oitava
int notaOffset = 0;

// variaveis para manipulacao grafica
int brushSize;
boolean extraLines;
String brushShape;
color fillingColor;
boolean pintarBolas = false;
ArrayList<Bola> bolas = new ArrayList<Bola>();

// classe auxiliar para bolas caindo
public class Bola {
    int px;
    int py;
    int vx;
    int vy;
    int ay;
    
    public Bola (int x, int y) {
        px = x;
        py = y;
        vx = (int) random(-5, 5);
        vy = (int) random(-15, 0);
        ay = 1;
    }
    
    public void inc () {
        px = px + vx;
        py = py + vy;
        vy = vy + ay;
    }
}

// inicializacao da janela
public void setup() {

    // tamanho 800x600, cor de fundo branca
    size(800, 600, JAVA2D);
    createGUI();
    customGUI();
    background(backgroundCor);
    
    // grossura do pincel
    brushSize = 6;
    extraLines = false;
    brushShape = "line";
    fillingColor = #ffffff;

    // inicializacao de variaveis de som
    minim = new Minim(this);
    input = minim.getLineIn();
    out = minim.getLineOut();

    // the frequency argument is not actually important here
    // because we will be patching in Midi2Hz
    // variavel de onda (com o timbre TRIANGLE)
    wave = new Oscil(300, 0.6f, Waves.TRIANGLE);

    // make our midi converter
    // converter pra midi
    midi = new Midi2Hz(nota);

    midi.patch(wave.frequency);
    wave.patch(out);
}

// funcao executada o tempo todo
public void draw() {
    // verificar qual a oitava selecionada, em funcao da cor do botao pressionado
    confereCor();
    colorMode(RGB, 255, 255, 255, height);
    
    // realizar iteracao das bolas criadas em funcao do desenho
    for (int i = 0; i < bolas.size(); i++) {
        // incrementar posicao e velocidade das bolas
        bolas.get(i).inc();
        if (bolas.get(i).py > 600) {
            //remover bolas fora da janela
            bolas.remove(bolas.get(i));
        }
        else {
            if (pintarBolas) {
                // pintar bolas caso a opcao "pintarBolas" esteja ativada
                ellipse(bolas.get(i).px, bolas.get(i).py, 3, 3);
            }
        }
    }

    //realizado apenas quando se desenha na tela (clicando com o mouse)
    if ((mousePressed) && (mouseInDrawingRange()) && cor != "Background") {
        //tamanho (grossura) do pincel
        strokeWeight(brushSize);
        fill(fillingColor);
        
        switch (brushShape) {
            // desenhar linha caso a opcao "line" esteja ativada
            case "line":
                line(mouseX, mouseY, pmouseX, pmouseY);
                break;
            // desenhar triangulo caso a opcao "triangle" esteja ativada
            case "triangle":
                triangle(mouseX, mouseY, mouseX + 10, mouseY -10, mouseX + 20, mouseY);
                break;
            // desenhar quadrado caso a opcao "rect" esteja ativada
            case "rect":
                rect(mouseX, mouseY, 10, 10);
                break;
        }
        
        // 10% de chances de criar bolas saltitantes randomicas ao longo do desenho
        // nao garante o desenho de bolas na tela (definida pela opcao "pintarBolas")
        if (random(10) > 9) {
            Bola currBola = new Bola(mouseX, mouseY);
            bolas.add(currBola);
        }

        // criacao de miniretas randomicas extras, em torno do desenho
        if (extraLines) {
          extraLines();
        }
        
        float m1 = mouseX;

        // definicao da nota em funcao da posicao x desenhada na tela
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

        // definicao de amplitude do som em funcao da posicao y desenhada na tela
        nota = nota + notaOffset;
        amp = map(mouseY, sketchPad1.getY(), (sketchPad1.getY() + sketchPad1.getHeight()), 1, 0);
        // setar amplitude (volume) do som
        wave.setAmplitude(amp);
        midi.patch(wave.frequency);

        // setar frequencia do som (tom)
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
    //if (key == 'r' && (!gravando)) {
    //    gravando = true;
    //    countAudios++;
    //    recorder = minim.createRecorder(input, "audio" + countAudios + ".wav", true);
    //    recorder.beginRecord();
    //}
    // comecar a gravar som caso tecla 'r' seja pressionada
    if(key == 'r'){
        recorder = minim.createRecorder(out, "audio" + countAudios + ".wav");        
        recorder.beginRecord();        
    }
    //else if (key == 'm' && (!gravando)) {
    //    gravando = true;
    //    countAudios++;
    //    recorder = minim.createRecorder(input, "audio" + countAudios + ".wav", true);
    //    recorder.beginRecord();
    //    microfone = true;
    //}
    // aumentar grossura do pincel com a tecla '+'
    else if (key == '+') {
        if (brushSize < 100) {
            brushSize = brushSize + 2;
        }
    }
    // diminuir grossura do pincel com a tecla '-'
    else if (key == '-') {
        if (brushSize > 2) {
            brushSize = brushSize - 2;
        }
    }
    // desenhar barras de divisao das notas com a tecla 'g'
    else if (key == 'g') {
        paintGrid();
    }
    // limpar toda a tela com a tecla 'c'
    else if (key == 'c') {
        background(backgroundCor);
    }
    // ativar/desativar linhas randomicas extras com a tecla 'e'
    else if (key == 'e') {
        extraLines = !extraLines;
    }
    // selecionar modo de desenho em linhas com a tecla 'l'
    else if (key == 'l') {
        brushShape = "line";
    }
    // selecionar modo de desenho em triangulos com a tecla 't'
    else if (key == 't') {
        brushShape = "triangle";
    }
    // selecionar modo de desenho em quadrados com a tecla 'k'
    else if (key == 'k') {
        brushShape = "rect";
    }
    // ativar/desativar bolas saltitantes randomicas com a tecla 'b'
    else if (key == 'b') {
        pintarBolas = !pintarBolas;
    }
    // salvar tela em um arquivo jpg (print) com a tecla 's'
    else if (key == 's') {
        save("desenho.jpg");
    }
}

void keyReleased() {
    gravando = false;
    //if (key == 'r') {
    //    recorder.endRecord();
    //    recorder.save();
    //    loopPlayer = minim.loadFile("audio" + countAudios + ".wav");
    //    loopPlayer.loop();
    //}
    // parar de gravar e salvar som gravado ao soltar tecla 'r'
    if(key == 'r'){
        recorder.endRecord();
        recorder.save();
        loopPlayer = minim.loadFile("audio" + countAudios + ".wav");
        loopPlayer.loop();
        countAudios++;
    }
    //else if (key == 'm') {
    //    recorder.endRecord();
    //    recorder.save();
    //    loopPlayer = minim.loadFile("audio" + countAudios + ".wav");
    //    loopPlayer.loop();
    //    microfone = false;
    //}
}

public void changeColor(String novacor) {
    cor = novacor;
}

public void confereCor() {
    // selecionar desenho vermelho (som mais grave) clicando no botao vermelho
    if (cor == "Red") {
        stroke(255, 0, 0, (height-mouseY));
        notaOffset = -12;
        fillingColor = #ff0000;
    }
    // selecionar desenho verde (som medio) clicando no botao verde
    else if (cor == "Green") {
        stroke(0, 255, 0, (height-mouseY));
        notaOffset = 0;
        fillingColor = #00ff00;
    }
    // selecionar desenho azul (som mais agudo) clicando no botao azul
    else if (cor == "Blue") {
        stroke(0, 0, 255, (height-mouseY));
        notaOffset = 12;
        fillingColor = #0000ff;
    }
    else {
        stroke(backgroundCor);
    }
}

// verificar se desenho esta sendo feito dentro da tela
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

// funcao para pintar grid (retas verticais) na tela
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

// funcao para pintar linhas randomicas extras
public void extraLines() {
    //grossura da reta
    strokeWeight(brushSize / 3);
    //o quão longe a minireta em volta da reta principal vai ser desenhada
    int desvio = 4 * (brushSize/3);
    //minireta
    line(mouseX + random(-desvio,desvio), mouseY + random(-desvio,desvio), pmouseX + random(-desvio,desvio), pmouseY + random(-desvio,desvio));
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {

}