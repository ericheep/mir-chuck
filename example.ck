// example.ck
// Eric Heep

// classes
Mel mel;
Sci sci;
Matrix mat;
Subband bnk;
Tonality ton;
Spectral spec;
Chromagram chr;
Visualization vis;

// sound chain
adc => FFT fft => blackhole;

// fft parameters 
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

//[0.0, 100.0, 500.0, 1000.0, 10000.0, 22050.0] @=> float filts[];

// calculates transformation matrix
mel.calc(N, sr, "constantQ") @=> float mx[][];
mat.transpose(mx) @=> mx;

// cuts off unnecessary half of transformation weights
mat.cutMat(mx, 0, win/2) @=> mx;

// keystrength cross correlation
ton.gomezProfs() @=> float key[][];
mat.transpose(key) @=> key;

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // subband filter usage
    //bnk.bank(blob.fvals(), filts, N, sr) @=> float X[];
    //bnk.sub_cent(blob.fvals(), filts, N, sr) @=> float sc[];

    // matrix dot product with transformation matrix
    //mat.dot(blob.fvals(), mx) @=> float X[];
    //spec.centroid(blob.fvals(), sr, N) => float cen;
    //spec.spread(blob.fvals(), sr, N) => float spred;
    spec.flatness(blob.fvals()) => float flat;
    //<<< flat >>>;

    // print out centroid
    // chromatic octave wrapping
    //chr.wrap(X) @=> X;

    // keystrength cross correlation
    // mat.dot(X, key) @=> X;

    // mfcc steps
    //mat.log10(X) @=> X;
    //mat.pow(X, 1.5) @=> X;
    //sci.dct(X) @=> X;

    // discarding upper half of mfcc
    //mat.cut(X, 0, 12) @=> X;

    // rms scaling
    //mat.rmstodb(X) @=> X;
    
    // sends data to Processing
    //vis.data(X, "/data");
}
