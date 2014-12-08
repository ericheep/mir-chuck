adc.left => LiSaCluster lc => dac;
adc.right => LiSaCluster rc => dac;
for (int i; i < lc.pan.cap(); i++) {
    //lc.pan[i] => dac;
}
for (int i; i < rc.pan.cap(); i++) {
    //rc.pan[i] => dac;
}
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
lc.numClusters(6);
lc.stepLength(50::ms);
lc.mfcc(1);

rc.fftSize(N);
rc.numClusters(6);
rc.stepLength(50::ms);
rc.mfcc(1);

int rec_latch_L, rec_latch_R, knob_pos_L, knob_pos_R, knob_pan_L, knob_pan_R;
int feat_latch[16];
fun void whichFeatures(){
    
    if (q.pad[1] > 0 && feat_latch[0] == 0) {
        lc.subbandCentroids(q.pad[1]);
        rc.subbandCentroids(q.pad[1]);
        1 => feat_latch[0];
    }
    if (q.pad[1] == 0 && feat_latch[0] == 1) {
        lc.subbandCentroids(0);
        rc.subbandCentroids(0);
        0 => feat_latch[0];
    }
    
    if (q.pad[2] > 0 && feat_latch[1] == 0) {
        lc.rms(q.pad[2]);
        rc.rms(q.pad[2]);
        1 => feat_latch[1];
    }
    if (q.pad[2] == 0 && feat_latch[1] == 1) {
        lc.rms(0);
        rc.rms(0);
        0 => feat_latch[1];
    }
    
    if (q.pad[3] > 0 && feat_latch[2] == 0) {
        lc.centroid(q.pad[3]);
        rc.centroid(q.pad[3]);
        1 => feat_latch[2];
    }
    if (q.pad[3] == 0 && feat_latch[2] == 1) {
        lc.centroid(0);
        rc.centroid(0);
        0 => feat_latch[2];
    }
    
    if (q.pad[4] > 0 && feat_latch[3] == 0) {
        lc.spread(q.pad[4]);
        rc.spread(q.pad[4]);
        1 => feat_latch[3];
    }
    if (q.pad[4] == 0 && feat_latch[3] == 1) {
        lc.spread(0);
        rc.spread(0);
        0 => feat_latch[3];
    }
    
    
    if (q.pad[5] > 0 && feat_latch[4] == 0) {
        lc.mel(q.pad[5]);
        rc.mel(q.pad[5]);
        1 => feat_latch[4];
    }
    if (q.pad[5] == 0 && feat_latch[4] == 1) {
        lc.mel(0);
        rc.mel(0);
        0 => feat_latch[4];
    }
    
    if (q.pad[6] > 0 && feat_latch[5] == 0) {
        lc.hfc(q.pad[6]);
        rc.hfc(q.pad[6]);
        1 => feat_latch[5];
    }
    if (q.pad[6] == 0 && feat_latch[5] == 1) {
        lc.hfc(0);
        rc.hfc(0);
        0 => feat_latch[5];
    }
    
    if (q.pad[7] > 0 && feat_latch[6] == 0) {
        lc.mfcc(q.pad[7]);
        rc.mfcc(q.pad[7]);
        1 => feat_latch[6];
    }
    if (q.pad[7] == 0 && feat_latch[6] == 1) {
        lc.mfcc(0);
        rc.mfcc(0);
        0 => feat_latch[6];
    }
    
    if (q.pad[8] > 0 && feat_latch[7] == 0) {
        lc.mfcc(q.pad[8]);
        rc.mfcc(q.pad[8]);
        1 => feat_latch[7];
    }
    if (q.pad[8] == 0 && feat_latch[7] == 1) {
        lc.mfcc(0);
        rc.mfcc(0);
        0 => feat_latch[7];
    }

}
fun void record() {
    if (q.pad[0] && rec_latch_L == 0) {
        lc.play(0);
        <<< "Recording Direct", "" >>>;
        lc.record(1);
        1 => rec_latch_L;
    }
    if (q.pad[0] == 0 && rec_latch_L == 1) {
        <<< "Finished Recording Direct", "" >>>;
        lc.record(0);
        0 => rec_latch_L;
        lc.play(1);
    }
    if (q.pad[12] && rec_latch_R == 0) {
        rc.play(0);
        <<< "Recording Mic", "" >>>;
        rc.record(1);
        1 => rec_latch_R;
    }
    if (q.pad[12] == 0 && rec_latch_R == 1) {
        <<< "Finished Recording Mic", "" >>>;
        rc.record(0);
        0 => rec_latch_R;
        rc.play(1);
    }
}

fun void whichCluster() {
    if (q.slider[0] != knob_pos_L) {
        q.slider[0] => knob_pos_L;
        lc.cluster(knob_pos_L/127.0);
    }
    if (q.slider[1] != knob_pos_R) {
        q.slider[1] => knob_pos_R;
        rc.cluster(knob_pos_R/127.0);
    }
}

fun void voicePan() {
    if (q.slider[2] != knob_pan_L) {
        q.slider[2] => knob_pan_L;
        lc.voicePan(knob_pan_L/127.0 * 2.0 - 1.0);
    }
    if (q.slider[3] != knob_pan_R) {
        q.slider[3] => knob_pan_R;
        rc.voicePan(knob_pan_R/127.0 * 2.0 - 1.0);
    }
}

while (true) {
    record();
    whichFeatures();
    whichCluster();
    //voicePan();
    10::ms => now;
}
