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
float db, spr, cent, fl;
int inc, record_stft, rec_latch, test_ready;
40 => float thresh;

float max_data[32][2000];
float train[0][0];
float model[0][0];

analysis();
keyboard();

// records while '~' is held down
// only audio above 40db will be recorded into training model 
fun void recData(float x[], float r) {
    x.cap() => int rows;
    if (record_stft && r > thresh) {
        for (int i; i < rows; i++) {
            x[i] => max_data[i][inc];
        }
        inc++;
        1 => rec_latch;
        <<< inc, "" >>>;
    }
    else if (record_stft == 0 && rec_latch == 1) {
        1 => test_ready;
        max_data @=> train;
        rows => train.size;
        inc => train[0].size;
        km.train(train) @=> model;
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
                    1 => record_stft; 
                }
            }
            if (msg.isButtonUp()) {
                if (msg.ascii == 96) {
                    0 => record_stft; 
                }
            }
        }
    }
}


// main program
fun void analysis() {
    while (true) {
        (win/4)::samp => now;
    
        // for rms filter
        rms.upchuck() @=> rms_blob;

        // creates our array of fft bins
        fft.upchuck() @=> blob;

        // low level features
        spec.centroid(blob.fvals(), sr, N) => cent;
        spec.spread(blob.fvals(), sr, N) => spr;

        // db filter variable
        Std.rmstodb(rms_blob.fval(0)) => db;

        // records data and then trains, while ~ is held down
        recData([spr, cent, fl], db);

         <<< spr, cent >>>;
        if (test_ready && db > thresh) {
            <<< km.singlePredict([spr, cent, fl], model) >>>;
        }
    }
}
