LiSaCluster lc[3];

for (int i; i < lc.cap(); i++) {
    adc => lc[i] => blackhole;
    lc[i].fftSize(1024);
    lc[i].numClusters(2 + i);
    lc[i].stepLength(50::ms);
    for (int j; j < lc[i].pan.cap(); j++) {
        lc[i].pan[j] => dac;
    }
}

NanoKontrol n;

int feat_latch[8];
int rec_latch, knob_pos, knob_pan;

fun void record() {
    if (n.bot[0] && rec_latch == 0) {
        <<< "Recording", "" >>>;
        lc[0].voice(0);
        lc[0].record(1);
        1 => rec_latch;
    }
    if (n.bot[0] == 0 && rec_latch == 1) {
        <<< "Finished Recording", "" >>>;
        lc[0].record(0);
        lc[0].voice(1);
        0 => rec_latch;
    }
}

fun void featureSelect() {
    for (int i; i < lc.cap(); i++) {
        if (n.top[0] && feat_latch[0] == 0) {
            lc[i].rms(1);
        }
        if (n.top[0] && feat_latch[0] == 1) {
            lc[i].rms(0);
        }
        if (n.top[1] && feat_latch[1] == 0) {
            lc[i].hfc(1);
        }
        if (n.top[1] && feat_latch[1] == 1) {
            lc[i].hfc(0);
        }
        if (n.top[2] && feat_latch[2] == 0) {
            lc[i].crest(1);
        }
        if (n.top[2] && feat_latch[2] == 1) {
            lc[i].crest(0);
        }
        if (n.top[3] && feat_latch[3] == 0) {
            lc[i].spread(1);
        }
        if (n.top[3] && feat_latch[3] == 1) {
            lc[i].spread(0);
        }
        if (n.top[4] && feat_latch[4] == 0) {
            lc[i].centroid(1);
        }
        if (n.top[4] && feat_latch[4] == 1) {
            lc[i].centroid(0);
        }
        if (n.top[5] && feat_latch[5] == 0) {
            lc[i].subbandCentroids(1);
        }
        if (n.top[5] && feat_latch[5] == 1) {
            lc[i].subbandCentroids(0);
        }
        if (n.top[6] && feat_latch[6] == 0) {
            lc[i].mel(1);
        }
        if (n.top[6] && feat_latch[6] == 1) {
            lc[i].mel(0);
        }
        if (n.top[7] && feat_latch[7] == 0) {
            lc[i].mfcc(1);
        }
        if (n.top[7] && feat_latch[7] == 1) {
            lc[i].mfcc(0);
        }
    }
}

/*fun void whichCluster() {
    if (n.knob[0] != knob_pos) {
        n.knob[0] => knob_pos;
        lc.cluster(knob_pos/127.0);
    }
}*/

fun void voicePan() {
    if (n.knob[1] != knob_pan) {
        n.knob[1] => knob_pan;
        lc[0].voicePan(knob_pan/127.0 * 2.0 - 1.0);
    }
}

while (true) {
    record();
    //whichCluster();
    voicePan();
    featureSelect();
    10::ms => now;
}
