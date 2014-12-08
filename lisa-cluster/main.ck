adc => LiSaCluster lc => blackhole;
for (int i; i < lc.pan.cap(); i++) {
    lc.pan[i] => dac;
}
NanoKontrol n;

1024 => int N;

//lc.subbandCentroids(1);
//lc.rms(1);
//lc.centroid(1);
//lc.spread(1);
//lc.mel(1);
//lc.hfc(1);
lc.mfcc(1);
//lc.crest(1);

lc.fftSize(N);
lc.numClusters(6);
lc.stepLength(50::ms);

int rec_latch, knob_pos, knob_pan;

fun void record() {
    if (n.bot[0] && rec_latch == 0) {
        lc.voice(0);
        <<< "Recording", "" >>>;
        lc.record(1);
        1 => rec_latch;
    }
    if (n.bot[0] == 0 && rec_latch == 1) {
        <<< "Finished Recording", "" >>>;
        lc.record(0);
        0 => rec_latch;
        lc.voice(1);
    }
}

fun void whichCluster() {
    if (n.knob[0] != knob_pos) {
        n.knob[0] => knob_pos;
        lc.cluster(knob_pos/127.0);
    }
}

fun void voicePan() {
    if (n.knob[1] != knob_pan) {
        n.knob[1] => knob_pan;
        lc.voicePan(knob_pan/127.0 * 2.0 - 1.0);
    }
}

while (true) {
    record();
    whichCluster();
    voicePan();
    10::ms => now;
}
