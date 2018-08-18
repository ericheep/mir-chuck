// kmeans_example.ck
// Eric Heep

// classes
Mel mel;
Sci sci;
Stft stft;
Kmeans km;
Matrix mat;
Subband bnk;
Tonality ton;
Spectral spec;
Chromagram chr;
Visualization vis;

Hid hi;
HidMsg msg;

if (!hi.openKeyboard(0)) {
    me.exit();
}
<<< "Keyboard '" + hi.name() + "' connected!", "" >>>;

// sound chain
adc => FFT fft =^ RMS rms => blackhole;

// fft parameters 
second / samp => float sr;
4096 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

// blobs
UAnaBlob blob;
UAnaBlob rms_blob;

// kmeans centroids
km.clusters(2);

// fft array
float X[win/2];

// control variables
float db, spr, cent, hfc;
int inc, rec_stft, rec_latch, test_ready;

// decibel threshold
40 => float thresh;

// max data size for our training features
float max_data[2][2000];
float train[0][0];
float model[0][0];

spork ~ keyboard();
analysis();
[0,2,5,1,3,6] @=> float x[];

spec.spectralCrest(x) => float max;

<<<max>>>;

// records while '~' is held down
// only audio above 40db will be recorded into training model 
fun void recData(float x[], float r) {
    x.cap() => int rows;
    if (rec_stft && r > thresh) {
        for (int i; i < rows; i++) {
            x[i] => max_data[i][inc];
        }

        inc++;
        1 => rec_latch;
        <<< inc, "" >>>;
    }
    else if (rec_stft == 0 && rec_latch == 1) {
        max_data @=> train;
        rows => train.size;
        inc => train[0].size;
        km.train(train) @=> model;

        1 => test_ready;
        0 => rec_latch;
        0 => inc;
    }
}

fun void keyboard() {
    while (true) {
        // event
        hi => now;

        while (hi.recv(msg)) {
            if (msg.isButtonDown()) {
                if (msg.ascii == 96) {
                    1 => rec_stft; 
                }
            }
            if (msg.isButtonUp()) {
                if (msg.ascii == 96) {
                    0 => rec_stft; 
                }
            }
        }
    }
}

// main program
fun void analysis() {
    while (true) {
        // 50% hop size
        (win/2)::samp => now;
    
        // for rms filter
        rms.upchuck() @=> rms_blob;

        // creates our array of fft bins
        fft.upchuck() @=> blob;

        // low level features
        spec.centroid(blob.fvals(), sr, N) => cent;
        spec.spread(blob.fvals(), sr, N) => spr;
        spec.hfc(blob.fvals(), N) => hfc;

        // db filter variable
        Std.rmstodb(rms_blob.fval(0)) => db;

        // records data and then trains, while ~ is held down
        recData([cent,hfc], db);
        
        // shows features pre-training
        if (rec_stft == 0 && test_ready == 0) {
            //<<< "Spread:", spr, "Centroid:", cent >>>;
        }

        // shows cluster 
        if (rec_stft == 0 && test_ready) {
            //<<< "Cluster:", km.singlePredict([spr, cent], model), "Spread:", spr, "Centroid:", cent >>>;
        }
    }
}
