// example.ck
// Eric Heep

// classes
Mel mel;
Sci sci;
Stft stft;
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
256 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

SndBuf audio;
me.dir() + "/trumpet.wav" => string filename;
filename => audio.read;

//[0.0, 100.0, 500.0, 1000.0, 10000.0, 22050.0] @=> float filts[];

// calculates transformation matrix
mel.calc(N, sr, "constantQ") @=> float mx[][];
mat.transpose(mx) @=> mx;

// cuts off unnecessary half of transformation weights
mat.cutMat(mx, 0, win/2) @=> mx;

// keystrength cross correlation
//ton.gomezProfs() @=> float key[][];
//mat.transpose(key) @=> key;

float data[win/2][30];
float S[win/2][30];
float zeros[win/2][30];
for (int i; i < win/2; i++) {
    for (int j; j < 30; j++) {
        Math.random2f(0.00001, 0.00002) => zeros[i][j];        
    }
}
int mod;

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
    //spec.flatness(blob.fvals()) => float flat;

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
    //mat.rmstodb(blob.fvals()) @=> float X[];

    //vis.data(X, "/data");
    
    
    stft.stft(blob.fvals(), data) @=> data;
    sci.cosineSimMat(data, data) @=> S;
    sci.autoCorr(S) @=> float auto[];
    //<<<data[0][0],data[0][1],data[0][2],data[0][3]>>>;
        (mod + 1) % 2 => mod;
    if (mod == 0) {
        //<<<S[0][0],S[0][1],S[0][2],S[0][3]>>>;
        // sends data to Processing
        vis.matrix(S, "/data", 256::samp);
    }
}
