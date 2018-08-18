// features.ck

// classes
Transforma transform;
Matrix matrix;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

// create mel coefficients
transform.mel(N, sr) @=> float mx[][];
matrix.transpose(mx) @=> mx;

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;
    blob.fvals() @=> float X[];

    // features
    matrix.dot(X, mx) @=> float mel;
}
