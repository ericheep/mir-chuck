// chromagram.ck

// classes
Transform transform;
Chromagram chromagram;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
4096 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

// set mel coefficients
transform.constantQ(sr, N);

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;
    blob.fvals() @=> float X[];

    // constantQ bands
    transform.compute(X) @=> float constantQArray[];

    // transform mel bands to mfccs
    chromagram.compute(constantQArray) @=> float chromagramArray[];
}
