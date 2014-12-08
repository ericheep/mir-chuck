// spectral_example.ck
// Eric Heep

// classes
Matrix mat;
Subband bnk;
Spectral spec;
Visualization vis;

// sound chain
adc => FFT fft => blackhole;

// fft parameters 
second / samp => float sr;
512 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

[0.0, 100.0, 500.0, 1000.0, 10000.0, 22050.0] @=> float filts[];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // spectral centroid and subband centroid
    spec.centroid(blob.fvals(), sr, N) => float cen;
    bnk.subbandCentroid(blob.fvals(), filts, N, sr) @=> float sub_cent[];

    // spectral spread
    spec.spread(blob.fvals(), sr, N) => float spr;

    // rms scaling
    mat.rmstodb(blob.fvals()) @=> float X[];

    //vis.data(X, "/data");
}
