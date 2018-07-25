// cent_example.ck
// Eric Heep

// classes
Mel mel;
Matrix mat;
Visualization vis;
CrossCorr c;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
4096 => int N => int win => fft.size;

Windowing.hamming(N) => fft.window;
UAnaBlob blob;

// calculates transformation matrix
mel.calc(N, sr, "cent") @=> float mx[][];
mat.transpose(mx) @=> mx;

// cuts off unnecessary half of transformation weights
mat.cutMat(mx, 0, win/2) @=> mx;

float laggedX[0];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // keystrength cross correlation
    mat.dot(blob.fvals(), mx) @=> float X[];

    if (laggedX.size() > 0) {
        c.crossCorr(X, laggedX, 3) @=> float series[];
        <<< series[0], series[1], series[2], series[3], series[4], series[5] >>>;
    }

    X @=> laggedX;

    vis.data(mat.rmstodb(X), "/data");
}
