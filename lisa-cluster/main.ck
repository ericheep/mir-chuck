adc => LiSaCluster lc => dac;
NanoKontrol n;

1024 => int N;

lc.subbandCentroids(1);
lc.rms(1);
lc.centroid(1);
lc.spread(1);
lc.mel(1);

lc.fftSize(N);
lc.numClusters(4);
lc.stepLength(50::ms);

int rec_latch, knob_pos;

fun void record() {
    if (n.bot[0] && rec_latch == 0) {
        lc.play(0);
        <<< "Recording", "" >>>;
        lc.record(1);
        1 => rec_latch;
    }
    if (n.bot[0] == 0 && rec_latch == 1) {
        <<< "Finished Recording", "" >>>;
        lc.record(0);
        0 => rec_latch;
        lc.play(1);
    }
}

fun void whichCluster() {
    if (n.knob[0] != knob_pos) {
        n.knob[0] => knob_pos;
        lc.cluster(knob_pos/127.0);
    }
}

while (true) {
    record();
    whichCluster();
    10::ms => now;
}
