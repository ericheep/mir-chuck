// mfcc_example.ck
// Eric Heep

// classes
Mel mel;
Sci sci;
Matrix mat;
Tonality ton;
Visualization vis;

// sound chain
adc => FFT fft => blackhole;

// fft parameters 
second / samp => float sr;
512 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;
UAnaBlob blob;

// calculates transformation matrix
mel.calc(N, sr, "mel") @=> float mx[][];
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

    // mfcc steps
    mat.log10(X) @=> X;
    sci.dct(X) @=> X;

    // discarding upper half of mfcc
    mat.cut(X, 1, 12) @=> X;

    // rms scaling
    mat.rmstodb(blob.fvals()) @=> X;

    vis.data(X, "/data");
}
