// kmeans.ck
// press T to train MFCCs into the cluster,
// press C to clear model

// classes
Transform transform;
MFCCs mfccs;
KMeans kmeans;

// set clusters
kmeans.clusters(2);

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

// blobs
UAnaBlob blob;

// set mel coefficients
transform.mel(sr, N);

// global
0 => int isTrainActive;

fun void keyboardTrainer() {
    Hid hid;
    HidMsg msg;

    if (!hid.openKeyboard(0)) me.exit();
    <<< "Keyboard '" + hid.name() + "' connected!", "" >>>;

    while (true) {
        // event
        hid => now;

        // '~' records data
        while (hid.recv(msg)) {
            if (msg.isButtonDown()) {
                if (msg.ascii == 84) {
                    true => isTrainActive;
                }
                if (msg.ascii == 67) {
                    kmeans.clearModel();
                }
            }
            if (msg.isButtonUp()) {
                if (msg.ascii == 84) {
                    kmeans.computeModel();
                    1::second => now;
                    false => isTrainActive;
                }
            }
        }
    }
}

fun float[] features(float X[]) {
    // mel bands
    transform.compute(X) @=> float melArray[];

    // transform mel bands to mfccs
    mfccs.compute(melArray) @=> float mfccArray[];

    return mfccArray;
}


// main program
fun void train() {
    while (true) {
        win::samp => now;
        // creates our array of fft bins
        fft.upchuck() @=> blob;
        blob.fvals() @=> float X[];

        if (isTrainActive) {
            kmeans.addFeatures(features(X));
        } else {
            kmeans.predict(features(X)) => int score;
            if (score >= 0) {
                <<< "Cluster:", score >>>;
            }
        }
    }
}

spork ~ keyboardTrainer();
train();
