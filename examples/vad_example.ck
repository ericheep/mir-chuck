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
        snd.read(me.dir(-1) + "/audio/far-breathing.wav");
        <<< "breathing", "" >>>;
        5::second => now;
        snd.read(me.dir(-1) + "/audio/far-talking.wav");
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

0 => int LAGS;
48 => int delay;

float laggedX[LAGS][mx[0].size()];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // constantQ dot product
    mat.dot(blob.fvals(), mx) @=> float X[];

    float series[];
    if (LAGS > 0) {
        for (LAGS - 1 => int i; i > 0; i--) {
            laggedX[i - 1] @=> laggedX[i];
        }
        X @=> laggedX[0];
        c.crossCorr(X, laggedX[LAGS - 1], delay) @=> series;
    } else {
        c.crossCorr(X, X, delay) @=> series;
    }

    <<<
        "HFC:\t", s.hfc(X),
        "Entropy:\t", s.entropy(X),
        "Peaks:\t", p.peaks(p.filter(series, 2)).size()
    >>>;

    vis.data(mat.rmstodb(X), "/data");
}

fun float sum (float X[]) {
    0.0 => float sum;
    for (0 => int i; i < X.size(); i++) {
        X[i] +=> sum;
    }
    return sum;
}

fun float mean (float X[]) {
    return sum(X)/X.size();
}
