// vad_example.ck
// Eric Heep

// classes
Mel mel;
Matrix mat;
Visualization vis;
CrossCorr c;

// sound chain
SndBuf snd => FFT fft => blackhole;

snd.read(me.dir(-1) + "/audio/far-talking.wav");
snd.pos(0);
snd.loop(1);

// fft parameters
second / samp => float sr;
4096 => int N => int win => fft.size;

Windowing.hamming(N) => fft.window;
UAnaBlob blob;

// calculates transformation matrix
mel.calc(4098, sr, "constantQ", 36 * 4, 1.0, 110.0, 1045.5025) @=> float mx[][];
/* mel.calc(N, sr, "cent") @=> float mx[][]; */

mat.transpose(mx) @=> mx;

// cuts off unnecessary half of transformation weights
mat.cutMat(mx, 0, win/2) @=> mx;

3 => int LAGS;
float laggedX[LAGS][mx[0].size()];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // constantQ dot product
    mat.dot(blob.fvals(), mx) @=> float X[];

    for (LAGS - 1 => int i; i > 0; i--) {
        laggedX[i - 1] @=> laggedX[i];
    }

    X @=> laggedX[0];

    if (laggedX.size() > 0) {
        c.crossCorr(X, laggedX[LAGS - 1], 3) @=> float series[];
        /* <<< series[0], "\t", series[1], "\t", series[2], "\t", series[3], "\t", series[4], "\t", series[5] >>>; */
        /* <<< sum(series) >>>; */
    }

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
