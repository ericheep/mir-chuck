// cent_example.ck
// Eric Heep

// classes
Mel mel;
Matrix mat;
Visualization vis;

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

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // keystrength cross correlation
    mat.dot(blob.fvals(), mx) @=> float X[];

    // rms scaling
    mat.rmstodb(blob.fvals()) @=> X;

    spork ~ vis.data(X, "/data");
}
