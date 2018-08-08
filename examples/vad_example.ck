// vad_example.ck
// Eric Heep

// classes
Mel mel;
Matrix mat;
Spectral s;
Visualization vis;
CrossCorr c;
Peaks p;

// sound chain
SndBuf snd => FFT fft => blackhole;

fun void switch() {
    while (true) {
        snd.read(me.dir(-1) + "/audio/close-breathing.wav");
        <<< "breathing", "" >>>;
        5::second => now;
        snd.read(me.dir(-1) + "/audio/close-talking.wav");
        <<< "talking", "" >>>;
        5::second => now;
    }
}

spork ~ switch();

snd.pos(0);
snd.loop(1);

// fft parameters
second / samp => float sr;
4096 => int N => int win => fft.size;

Windowing.hamming(N) => fft.window;
UAnaBlob blob;

// calculates transformation matrix
mel.calc(4096, sr, "constantQ", 48, 1.0, 110.0, 880.0) @=> float mx[][];
mat.transpose(mx) @=> mx;
mat.cutMat(mx, 0, win/2) @=> mx;

3 => int LAGS;
24 => int delay;

float laggedX[LAGS][mx[0].size()];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    blob.fvals() @=> float X[];
    power(X);

    // constantQ dot product
    mat.dot(X, mx) @=> float mX[];

    float series[];
    if (LAGS > 0) {
        for (LAGS - 1 => int i; i > 0; i--) {
            laggedX[i - 1] @=> laggedX[i];
        }
        mX @=> laggedX[0];
        c.crossCorr(mX, laggedX[LAGS - 1], delay) @=> series;
    } else {
        c.crossCorr(mX, mX, delay) @=> series;
    }

    p.highestPeaks(p.filter(mX, 3), 6) @=> int peaks[];

    float send[series.size()];
    for (0 => int i; i < peaks.size(); i++) {
        series[peaks[i]] * 100 => send[peaks[i]];
    }

    <<<
        /* "HFC:\t", s.hfc(X), */
        "Peaks:\t", peaks[0], peaks[1], peaks[2],
        "Mean:\t", mean(peaks)
    >>>;

    vis.data(send, "/data");
}

fun void power(float X[]) {
    for (0 => int i; i < X.size(); i++) {
        X[i] * X[i] => X[i];
    }
}

fun int sum (int X[]) {
    0 => int sum;
    for (0 => int i; i < X.size(); i++) {
        X[i] +=> sum;
    }
    return sum;
}

fun int mean (int X[]) {
    return sum(X)/X.size();
}
