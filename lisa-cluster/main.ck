adc => LiSaCluster lc => dac;
NanoKontrol n;
Quneo q;

1024 => int N;

//lc.subbandCentroids(1);
//lc.rms(1);
//lc.centroid(1);
//lc.spread(1);
//lc.mel(1);
//lc.hfc(1);
//lc.mfcc(1);
//lc.crest(1);

lc.fftSize(N);
lc.numClusters(5);
lc.stepLength(50::ms);

int rec_latch, knob_pos;

fun void whichFeatures(){
    lc.subbandCentroids(q.pad[1]);
    lc.rms(q.pad[2]);
    lc.centroid(q.pad[3]);
    lc.spread(q.pad[4]);
    lc.mel(q.pad[5]);
    lc.hfc(q.pad[6]);
    lc.mfcc(q.pad[7]);
    lc.crest(q.pad[8]);
}
fun void record() {
    if (q.pad[0] && rec_latch == 0) {
        lc.play(0);
        <<< "Recording", "" >>>;
        lc.record(1);
        1 => rec_latch;
    }
    if (q.pad[0] == 0 && rec_latch == 1) {
        <<< "Finished Recording", "" >>>;
        lc.record(0);
        0 => rec_latch;
        lc.play(1);
    }
}

fun void whichCluster() {
    if (q.fader != knob_pos) {
        q.fader => knob_pos;
        lc.cluster(knob_pos/127.0);
    }
}

while (true) {
    record();
    whichFeatures();
    whichCluster();
    10::ms => now;
}
