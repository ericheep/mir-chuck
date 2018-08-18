// mfccs.ck

// classes
Transform transform;
MFCCs mfccs;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

// set mel coefficients
transform.mel(sr, N);

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;
    blob.fvals() @=> float X[];

    // mel bands
    transform.compute(X) @=> float melArray[];

    // transform mel bands to mfccs
    mfccs.compute(melArray) @=> float mfccArray[];
}
