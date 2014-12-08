LiSaCluster lc[3];

adc.right => lc[0] => blackhole;
adc.left => lc[1] => blackhole;
adc.left => lc[2] => dac.left;

lc[0].numClusters(4);
lc[1].numClusters(4);
lc[2].numClusters(4);

[0, 4] @=> int which[];
for (int i; i < which.cap(); i++) {
    lc[i].fftSize(1024);
    lc[i].stepLength(100::ms);
    for (int j; j < lc[i].pan.cap(); j++) {
        lc[i].pan[j].left => dac.left;
        lc[i].pan[j].right => dac.right;
    }
}

lc[2].fftSize(1024);
lc[2].stepLength(100::ms);

NanoKontrol n;

int knob_pos;

int single_gain;
int rec_voice_latch[which.cap()];
int knob_pan[which.cap()];
int rec_play_latch;
// latches for selecting features
int feat_latch[3][8];
int cluster_vol[8];

fun void recordVoice() {
    for (int i; i < which.cap(); i++) {
        if (n.bot[which[i]] && rec_voice_latch[i] == 0) {
            <<< "Recording:", i + 1, "" >>>;
            lc[i].voice(0);
            lc[i].record(1);
            1 => rec_voice_latch[i];
        }
        if (n.bot[which[i]] == 0 && rec_voice_latch[i] == 1) {
            <<< "Finished Recording", i + 1, "" >>>;
            lc[i].record(0);
            lc[i].voice(1);
            0 => rec_voice_latch[i];
        }
    }
}

fun void micGain() {
    for (int i; i < which.cap(); i++) {
        for (int j; j < 4; j++) {
            if (n.slider[j + (i * 4)] != cluster_vol[j + (i * 4)]) {
                n.slider[j + (i * 4)] => cluster_vol[j + (i * 4)];
                lc[i].mic[j].gain(cluster_vol[j + (i * 4)]/127.0);
            }
        }
    }
}

fun void singleGain() {
    if (n.slider[8] != single_gain) {
        n.slider[8] => single_gain;
        lc[2].gain(single_gain/127.0);
    }
}

fun void recordPlay() {
    if (n.bot[8] && rec_play_latch == 0) {
        <<< "Recording:", 3, "" >>>;
        lc[2].play(0);
        lc[2].record(1);
        1 => rec_play_latch;
    }
    if (n.bot[8] == 0 && rec_play_latch == 1) {
        <<< "Finished Recording", 3, "" >>>;
        lc[2].record(0);
        lc[2].play(1);
        0 => rec_play_latch;
    }
}

fun void featureSelect() {
    for (int i; i < lc.cap(); i++) {
        if (n.top[0] && feat_latch[i][0] == 0) {
            lc[i].rms(1);
            <<< "RMS", "" >>>;
            1 => feat_latch[i][0];
        }
        if (n.top[0] == 0 && feat_latch[i][0] == 1) {
            lc[i].rms(0);
            <<< "RMS Off", "" >>>;
            0 => feat_latch[i][0];
        }
        if (n.top[1] && feat_latch[i][1] == 0) {
            lc[i].hfc(1);
            <<< "HFC", "" >>>;
            1 => feat_latch[i][1];
        }
        if (n.top[1] == 0 && feat_latch[i][1] == 1) {
            lc[i].hfc(0);
            <<< "HFC Off", "" >>>;
            0 => feat_latch[i][1];
        }
        if (n.top[2] && feat_latch[i][2] == 0) {
            lc[i].crest(1);
            <<< "Crest", "" >>>;
            1 => feat_latch[i][2];
        }
        if (n.top[2] == 0 && feat_latch[i][2] == 1) {
            lc[i].crest(0);
            <<< "Crest Off", "" >>>;
            0 => feat_latch[i][2];
        }
        if (n.top[3] && feat_latch[i][3] == 0) {
            lc[i].spread(1);
            <<< "Spread", "" >>>;
            1 => feat_latch[i][3];
        }
        if (n.top[3] == 0 && feat_latch[i][3] == 1) {
            lc[i].spread(0);
            <<< "Spread Off", "" >>>;
            0 => feat_latch[i][3];
        }
        if (n.top[4] && feat_latch[i][4] == 0) {
            lc[i].centroid(1);
            <<< "Centroid", "" >>>;
            1 => feat_latch[i][4];
        }
        if (n.top[4] == 0 && feat_latch[i][4] == 1) {
            lc[i].centroid(0);
            <<< "Centroid Off", "" >>>;
            0 => feat_latch[i][4];
        }
        if (n.top[5] && feat_latch[i][5] == 0) {
            <<< "Subband Centroids", "" >>>;
            lc[i].subbandCentroids(1);
            1 => feat_latch[i][5];
        }
        if (n.top[5] == 0 && feat_latch[i][5] == 1) {
            lc[i].subbandCentroids(0);
            <<< "Subband Centroids Off", "" >>>;
            0 => feat_latch[i][5];
        }
        if (n.top[6] && feat_latch[i][6] == 0) {
            <<< "Mel Filter", "" >>>;
            lc[i].mel(1);
            1 => feat_latch[i][6];
        }
        if (n.top[6] == 0 && feat_latch[i][6] == 1) {
            lc[i].mel(0);
            <<< "Mel Filter Off", "" >>>;
            0 => feat_latch[i][6];
        }
        if (n.top[7] && feat_latch[i][7] == 0) {
            <<< "MFCCS", "" >>>;
            lc[i].mfcc(1);
            1 => feat_latch[i][7];
        }
        if (n.top[7] == 0 && feat_latch[i][7] == 1) {
            lc[i].mfcc(0);
            <<< "MFCCS Off", "" >>>;
            0 => feat_latch[i][7];
        }
    }
}

fun void whichCluster() {
    if (n.knob[8] != knob_pos) {
        n.knob[8] => knob_pos;
        lc[2].cluster(knob_pos/127.0);
    }
}

fun void voicePan() {
    for (int i; i < which.cap(); i++) {
        if (n.knob[which[i]] != knob_pan[i]) {
            n.knob[which[i]] => knob_pan[i];
            lc[0].voicePan(knob_pan[i]/127.0 * 2.0 - 1.0);
        }
    }
}

while (true) {
    recordVoice();
    recordPlay();
    whichCluster();
    voicePan();
    featureSelect();
    micGain();
    singleGain();
    10::ms => now;
}
