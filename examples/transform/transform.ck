// transform.ck

// classes
Transform transform;
MFCCs mfccs;
Matrix matrix;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

// create mel coefficients
transform.mel(sr, N) @=> float mx[][];

// transpose and remove unnecessary data
matrix.transpose(mx) @=> mx;
matrix.cutMatrix(mx, 0, N/2) @=> mx;

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;
    blob.fvals() @=> float X[];

    // features
    matrix.dot(X, mx) @=> float melArray[];

    // transform mel bands to mfccs
    mfccs.compute(melArray) @=> float mfccArray[];
}
