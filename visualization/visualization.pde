// visualization.pde
// Eric Heep
// Processing sketch that displays moving data received from ChucK

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

int filts = 12;
int cols, rows;
int fr = 6;

float hght;
float[][] mov_spectra;
float[][] plot;

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/data") == true) {
    for (int i = 0; i < rows; i++) {
      mov_spectra[0][i] = msg.get(i).floatValue();
    }
    redraw();
  }
}

void mov_specgram() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      fill(mov_spectra[i][j] * 3.5, 300, 300);
      rect((cols - i) * fr - fr, height - (j * hght), fr, hght * -1);
    }
  }
  for (int i = 0; i < cols - 1; i++) {
    for (int j = 0; j < rows; j++) {
      mov_spectra[cols - (i + 1)][j] = mov_spectra[cols - (i + 2)][j];
    }
  }
}

void setup() {
  fullScreen();
  noStroke();
  frameRate(60);
  //size(displayWidth, displayHeight);
  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  hght = height/float(filts);
  cols = (width/fr) + 1;
  rows = filts;
  mov_spectra = new float[cols][rows];
  colorMode(HSB, 360); 
  noCursor();
}


void draw() {
  mov_specgram();
}