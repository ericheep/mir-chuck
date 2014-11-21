// example.ck
// Eric Heep

// classes
sci sci;
Mel mel;
matrix mat;
chromagram chr;
filter_bank bnk;
visualization vis;

adc => FFT fft => blackhole;

second / samp => float sr;
4096 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

[0.0, 100.0, 500.0, 1000.0, 10000.0, 22050.0] @=> float filts[];

// calculates mel matrix
mel.calc(N, sr, "constantQ") @=> float mx[][];
mat.transpose(mx) @=> mx;

mat.cut(mx, 0, win/2) @=> mx;

// main program
while (true) {
    win::samp => now;
    fft.upchuck() @=> blob;

    // mel matrix and subband filter
    //bnk.bank(blob.fvals(), filts, N, sr) @=> float X[];
    //bnk.sub_cent(blob.fvals(), filts, N, sr) @=> float sc[];
    mat.dot_win(blob.fvals(), mx) @=> float X[];
    //chr.chromagram(blob.fvals(), N, sr) @=> float X[];

    // TODO: improve mfcc (log and dct) results, create a matrix.rms function
    //mat.log_win(X) @=> X;
    //sci.dct_win(X) @=> X;
    wrap(X) @=> X;
    vis.data(X, "/data");
}

fun float[] wrap(float X[]) {
    float octave[12];
    for (int i; i < X.cap()/3; i++) {
        for (int j; j < 3; j++) {
            X[(i * 3) + j] + octave[i % 12] => octave[i % 12];
        }
    }
    return octave;
}
