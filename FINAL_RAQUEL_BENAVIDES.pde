import processing.sound.*;

SoundFile song;
Amplitude amp;
FFT fft;
int bands = 512;

// COLORES GENERALES
color C_BRAND_GREEN_HSB = color(120, 100, 100, 100);

// Variables de Audio
float lerpedAmp = 0, lerpedBass = 0, lerpedMid = 0, lerpedHigh = 0;

// Parámetros controlables
float lineWeight = 2.0;

// Para el Modo 3 (Partículas ASCII)
AsciiParticle[] particles = new AsciiParticle[300];
PFont asciiFont;
String asciiChars = " .:-=+*#%@";

// Para el Modo 4 (Combinado)
int randomModeA, randomModeB;

// Para el Modo 5
float relativityBaseHue = 0;


void setup() {
  size(1280, 720, P2D);
  fullScreen(P2D);
  colorMode(HSB, 360, 100, 100, 100);

  asciiFont = createFont("Monospaced", 24);
  textFont(asciiFont);

  song = new SoundFile(this, "The City Never Felt So Good [IKjMt_q-jnU].mp3");
  song.loop();

  amp = new Amplitude(this);
  fft = new FFT(this, bands);
  amp.input(song);
  fft.input(song);

  for (int i = 0; i < particles.length; i++) {
    particles[i] = new AsciiParticle();
  }

  pickRandomModes();
}

int visualMode = 0;
int totalModes = 6;

void draw() {
  analyzeAudio();
  background(0);

  pushStyle();
  strokeWeight(lineWeight);

  switch(visualMode) {
    case 0: drawWaveformMode(); break;
    case 1: drawVerticalGradientMode(); break;
    case 2: drawGeometricShapesMode(); break;
    case 3: drawAsciiParticlesMode(); break;
    case 4: drawSplitCombineMode(); break;
    case 5: drawRelativityMode(); break;
  }
  popStyle();

  drawSignature();
}

// --- ANÁLISIS DE AUDIO ---

void analyzeAudio() {
  fft.analyze();
  float currentBass = 0, currentMid = 0, currentHigh = 0;

  for (int i = 0; i < bands; i++) {
    if (i <= 5) {
      currentBass += fft.spectrum[i];
    } else if (i > 5 && i <= 100) {
      currentMid += fft.spectrum[i];
    } else {
      currentHigh += fft.spectrum[i];
    }
  }

  float smoothing = 0.1;
  lerpedBass = lerp(lerpedBass, currentBass, smoothing);
  lerpedMid = lerp(lerpedMid, currentMid, smoothing);
  lerpedHigh = lerp(lerpedHigh, currentHigh, smoothing);
}


// MODOS DE VISUALIZACIÓN

// MODO 0: Tres ondas separadas con estilos únicos.
void drawWaveformMode() {
  noFill();

  // --- Onda 1: Superior (Agudos) ---
  float highAmp = map(lerpedHigh, 0, 2, 5, 50);
  pushMatrix();
  translate(0, height * 0.25);
  // Aura de color
  stroke(map(lerpedHigh, 0, 2, 120, 0), 100, 100, 80); // Verde a rojo
  strokeWeight(lineWeight * 3);
  beginShape();
  for (int x = 0; x < width; x+=5) {
    int band = (int)map(x, 0, width, 200, bands-1); // Bandas altas
    float y = map(fft.spectrum[band], 0, 0.1, 0, highAmp);
    vertex(x, y);
  }
  endShape();
  beginShape();
  for (int x = 0; x < width; x+=5) {
    int band = (int)map(x, 0, width, 200, bands-1);
    float y = map(fft.spectrum[band], 0, 0.1, 0, highAmp);
    vertex(x, -y);
  }
  endShape();
  // Línea blanca central
  stroke(0, 0, 100);
  strokeWeight(lineWeight);
  line(0, 0, width, 0);
  popMatrix();


  // --- Onda 2: Central (Medios) ---
  float midAmp = map(lerpedMid, 0, 15, 10, height * 0.2);
  pushMatrix();
  translate(0, height * 0.5);
  // Relleno sólido
  fill(0, 100, 100, 90); // Rojo
  noStroke();
  beginShape();
  vertex(0,0);
  for (int x = 0; x < width; x+=10) {
    int band = (int)map(x, 0, width, 5, 100); // Bandas medias
    float y = map(fft.spectrum[band], 0, 0.4, 0, midAmp);
    curveVertex(x, -y);
  }
  vertex(width, 0);
  endShape(CLOSE);
  beginShape();
  vertex(0,0);
  for (int x = 0; x < width; x+=10) {
    int band = (int)map(x, 0, width, 5, 100);
    float y = map(fft.spectrum[band], 0, 0.4, 0, midAmp);
    curveVertex(x, y);
  }
  vertex(width, 0);
  endShape(CLOSE);
  // Línea blanca central
  stroke(0, 0, 100);
  strokeWeight(lineWeight);
  line(0, 0, width, 0);
  popMatrix();


  // --- Onda 3: Inferior (Graves) ---
  float bassAmp = map(lerpedBass, 0, 10, 20, height * 0.25);
  pushMatrix();
  translate(0, height * 0.75);
  noStroke();
  // Primera forma translúcida (Cian)
  fill(180, 80, 100, 50);
  beginShape();
  vertex(0, 0);
  for (int x = 0; x <= width; x += 15) {
      int band = (int)map(x, 0, width, 0, 10);
      float y = map(fft.spectrum[band], 0, 0.6, 0, bassAmp);
      curveVertex(x, y);
  }
  vertex(width, 0);
  endShape(CLOSE);
  // Segunda forma translúcida (Magenta)
  fill(300, 80, 100, 50);
  beginShape();
  vertex(0, 0);
  for (int x = 0; x <= width; x += 15) {
      int band = (int)map(x, 0, width, 0, 10);
      float y = map(fft.spectrum[band], 0, 0.6, 0, bassAmp);
      curveVertex(x, -y);
  }
  vertex(width, 0);
  endShape(CLOSE);
  // Línea blanca central
  stroke(0, 0, 100);
  strokeWeight(lineWeight);
  line(0, 0, width, 0);
  popMatrix();
}

// MODO 1: Onda blanca sobre arcoíris.
void drawVerticalGradientMode() {
  float startX = 0;
  float endX = width;

  for (int x = (int)startX; x < endX; x++) {
    float hue = map(x, startX, endX, 0, 360);
    stroke(hue, 100, 100);
    line(x, 0, x, height);
  }

  pushMatrix();
  translate(0, height / 2);

  noFill();
  stroke(0, 0, 100);
  strokeWeight(lineWeight);

  float amplitude = map(lerpedMid, 0, 15, 10, height * 0.4);
  float frequency = map(lerpedHigh, 0, 3, 0.01, 0.1);

  beginShape();
  for (int x = 0; x <= width; x += 5) {
    // [MEJORA] Se añade un desfase con millis() para que la onda se mueva y sea reactiva desde x=0
    float timeOffset = millis() * 0.002;
    float y = sin(timeOffset + x * frequency) * amplitude;
    vertex(x, y);
  }
  endShape();

  popMatrix();
}


// MODO 2: Figuras Geométricas
void drawGeometricShapesMode() {
  fill(0, 0, 0, 8);
  rect(0, 0, width, height);

  int lines = 5;
  float spacing = height / (lines + 1);

  for (int line = 0; line < lines; line++) {
    float y = spacing * (line + 1);
    float hueBase = (map(line, 0, lines - 1, 180, 300) + lerpedBass * 20) % 360;
    float scaleMod = 1 + lerpedBass * 0.3;

    int shapesPerLine = 12;
    float shapeSpacing = width / (shapesPerLine + 1);

    for (int i = 0; i < shapesPerLine; i++) {
      float x = shapeSpacing * (i + 1);
      float size = 20 + lerpedMid * 15;
      float hue = (hueBase + i * 30) % 360;

      pushMatrix();
      translate(x, y);
      rotate(millis() * 0.0005 * (line + 1) + lerpedHigh * 0.1);

      if (i % 2 == 0) {
        fill(hue, 80, 85, 80);
        stroke((hue + 180) % 360, 80, 90, 90);
        strokeWeight(lineWeight);
        rectMode(CENTER);
        rect(0, 0, size * scaleMod, size * scaleMod);
      } else {
        noStroke();
        fill((hue + 60) % 360, 85, 90, 90);
        ellipse(0, 0, size * scaleMod, size * scaleMod);
      }
      popMatrix();
    }
  }
}


// MODO 3: Partículas ASCII
void drawAsciiParticlesMode() {
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);

  for (AsciiParticle p : particles) {
    p.update();
    p.display();
  }
}

// MODO 4: Combinación en pantalla partida
void drawSplitCombineMode() {
  clip(0, 0, width/2, height);
  drawModeByIndex(randomModeA);
  noClip();

  clip(width/2, 0, width/2, height);
  drawModeByIndex(randomModeB);
  noClip();

  stroke(C_BRAND_GREEN_HSB, 80);
  line(width/2, 0, width/2, height);
}

// [MEJORA] MODO 5: Espectro con reflejo y colores dinámicos
void drawRelativityMode() {
  noStroke();
  // El tono base del degradado cambia con la energía de los medios
  relativityBaseHue = (relativityBaseHue + lerpedMid * 0.1) % 360;
  
  int barWidth = 8;
  for (int i = 0; i < width / barWidth; i++) {
    int x = i * barWidth;
    int band = (int)map(i, 0, width / barWidth, 0, bands-1);
    
    float spectrumValue = fft.spectrum[band];
    
    // [MEJORA] El tono ahora depende de la posición y del tono base reactivo
    float hue = (relativityBaseHue + map(x, 0, width, 0, 180)) % 360;
    
    // El brillo sí depende de la intensidad de la frecuencia
    float brightness = map(spectrumValue, 0, 0.4, 0, 100);
    
    fill(hue, 100, brightness);
    
    // [MEJORA] La altura de la barra se usa para dibujar el reflejo
    float barHeight = map(spectrumValue, 0, 0.4, 0, height / 2);
    
    // Dibujar las dos barras (original y reflejo) desde el centro
    rect(x, height / 2 - barHeight, barWidth, barHeight); // Barra superior
    rect(x, height / 2, barWidth, barHeight);             // Barra inferior (reflejo)
  }
}


// --- CLASE ASCIIPARTICLE ---

class AsciiParticle {
  PVector pos, vel;

  AsciiParticle() {
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D().mult(random(0.5, 2));
  }

  void update() {
    float pushForce = map(lerpedBass, 0, 10, 0, 0.3);
    PVector center = new PVector(width/2, height/2);
    PVector push = PVector.sub(pos, center);
    push.normalize().mult(pushForce);

    vel.add(push);
    vel.limit(3);
    pos.add(vel);

    if (pos.x > width) pos.x = 0; if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0; if (pos.y < 0) pos.y = height;
  }

  void display() {
    float brightness = map(lerpedHigh, 0, 2, 50, 100);
    float textSize = map(lerpedMid, 0, 15, 40, 100);

    int charIndex = (int)map(lerpedHigh, 0, 2, 0, asciiChars.length());
    charIndex = constrain(charIndex, 0, asciiChars.length() - 1);
    char c = asciiChars.charAt(charIndex);

    float dynamicHue = (pos.x * 0.2 + pos.y * 0.2 + millis() * 0.05) % 360;
    fill(dynamicHue, 100, brightness);

    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(c, pos.x, pos.y);
  }
}

// --- FUNCIONES AUXILIARES Y CONTROLES ---

void drawModeByIndex(int index) {
  pushStyle();
  switch(index) {
    case 0: drawWaveformMode(); break;
    case 1: drawVerticalGradientMode(); break;
    case 2: drawGeometricShapesMode(); break;
    case 3: drawAsciiParticlesMode(); break;
    case 5: drawRelativityMode(); break;
  }
  popStyle();
}

void pickRandomModes() {
  int maxMode = totalModes - 3;
  randomModeA = (int)random(maxMode + 1);
  randomModeB = (int)random(maxMode + 1);
  while (randomModeA == randomModeB) {
    randomModeB = (int)random(maxMode + 1);
  }
}

void drawSignature() {
  textAlign(RIGHT, BOTTOM);
  textSize(16);
  fill(C_BRAND_GREEN_HSB);
  text("RB.Graphicx", width - 20, height - 10);
}

void keyPressed() {
  if (key == 'm' || key == ' ') {
    visualMode = (visualMode + 1) % totalModes;
    if (visualMode == 4) pickRandomModes();
  }
  if (key == '-') lineWeight = max(1.0, lineWeight - 0.5);
  if (key == '+') lineWeight = min(20.0, lineWeight + 0.5);
}
