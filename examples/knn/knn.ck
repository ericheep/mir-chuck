// knn.ck
// press T to train MFCCs into the cluster,
// press C to clear model

// classes
Transform transform;
MFCCs mfccs;
KNN knn;
Deltas deltas;

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
0 => int isTrainActiveA;
0 => int isTrainActiveB;

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
                <<< msg.ascii >>>;
                if (msg.ascii == 49) {
                    true => isTrainActiveA;
                }
                if (msg.ascii == 50) {
                    true => isTrainActiveB;
                }
                if (msg.ascii == 67) {
                    knn.clear();
                }
            }
            if (msg.isButtonUp()) {
                false => isTrainActiveA;
                false => isTrainActiveB;

                if (msg.ascii == 84) {
                    1::second => now;
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
    deltas.compute(mfccArray) @=> float deltasArray[];

    float features[mfccArray.size() + deltasArray.size()];

    for (0 => int i; i < mfccArray.size(); i++) {
        mfccArray[i] => features[i];
    }

    for (mfccArray.size() => int i; i < features.size(); i++) {
        deltasArray[i - mfccArray.size()] => features[i];
    }

    return features;
}


// main program
fun void train() {
    while (true) {
        win::samp => now;
        // creates our array of fft bins
        fft.upchuck() @=> blob;
        blob.fvals() @=> float X[];

        if (isTrainActiveA) {
            knn.addFeatures(features(X), 0);
        } else if (isTrainActiveB) {
            knn.addFeatures(features(X), 1);
        } else {
            knn.predict(features(X), true) => int score;
            if (score >= 0) {
                <<< "Score:", score >>>;
            }
        }
    }
}

spork ~ keyboardTrainer();
train();
