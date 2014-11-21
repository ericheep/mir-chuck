// example.ck
// Eric Heep

// classes
Mel mel;
Sci sci;
Matrix mat;
Subband bnk;
Chromagram chr;
Visualization vis;

// sound chain
adc => FFT fft => blackhole;

// fft parameters 
second / samp => float sr;
4096 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

//[0.0, 100.0, 500.0, 1000.0, 10000.0, 22050.0] @=> float filts[];

// calculates transformation matrix
mel.calc(N, sr, "constantQ") @=> float mx[][];
mat.transpose(mx) @=> mx;

// cuts off unnecessary half of transformation weights
mat.cut(mx, 0, win/2) @=> mx;

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // subband filter usage
    //bnk.bank(blob.fvals(), filts, N, sr) @=> float X[];
    //bnk.sub_cent(blob.fvals(), filts, N, sr) @=> float sc[];

    // matrix dot product with transformation matrix
    mat.dot_win(blob.fvals(), mx) @=> float X[];

    // chromatic octave wrapping
    chr.wrap(X) @=> X;

    // TODO: improve mfcc (log and dct) results, create a matrix.rms function
    //mat.log_win(X) @=> X;
    //sci.dct_win(X) @=> X;

    // sends data to Processing
    vis.data(X, "/data");
}
