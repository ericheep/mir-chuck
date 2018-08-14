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

3 => int LAGS;
24 => int delay;

float laggedX[LAGS][mx[0].size()];
float hfcAverage[4];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    blob.fvals() @=> float X[];
    // power(X);

    // constantQ dot product
    mat.dot(X, mx) @=> float mX[];

    float series[];
    if (LAGS > 0) {
        for (LAGS - 1 => int i; i > 0; i--) { laggedX[i - 1] @=> laggedX[i];
        }
        mX @=> laggedX[0];
        c.crossCorr(mX, laggedX[LAGS - 1], delay) @=> series;
    } else {
        c.crossCorr(mX, mX, delay) @=> series;
    }

    p.highestPeaks(p.filter(series, 2), 2) @=> int peaks[];

    float send[series.size()];
    for (0 => int i; i < peaks.size(); i++) {
        series[peaks[i]] * 100 => send[peaks[i]];
    }

    /* <<< */
        /* "HFC:\t", movingAverage(s.hfc(X), hfcAverage) */
        /* s.kurtosis(X) */
        /* "Entropy:\t", s.flatness(X), */
        /* "Peaks:\t", peaks[0] */
    /* >>>; */

    <<< s.kurtosis(X), s.skewness(X) >>>;
    /* vis.data(send, "/data"); */
}

fun void power(float X[]) {
    for (0 => int i; i < X.size(); i++) {
        X[i] * X[i] => X[i];
    }
}

fun float sum (float X[]) {
    0 => float sum;
    for (0 => int i; i < X.size(); i++) {
        X[i] +=> sum;
    }
    return sum;
}

fun float movingAverage(float value, float average[]) {
    average.size() => int length;
    for (length - 2 => int i; i >= 0; i--) {
        average[i] => average[i + 1];
    }

    value => average[0];

    return mean(average);
}

fun float mean (float X[]) {
    return sum(X)/X.size();
}
