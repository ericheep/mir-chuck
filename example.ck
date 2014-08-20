// example.ck
// Eric Heep

/// classes
sci sci;
mel mel;
matrix mat;
spectrograph spc;

adc => FFT fft => blackhole;

second / samp => float sr;
32 => int nfilts;
512 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

// calculates mel matrix
mel.calc(N, nfilts, sr, 1.0) @=> float mx[][];
mat.transpose(mx) @=> mx;
mat.cut(mx, 0, 256) @=> mx;

// turns fft into mel bands, sends to Processing
while (true) {
    win::samp => now;
    fft.upchuck() @=> blob;
    mat.dot_win(blob.fvals(), mx) @=> float X[];
    // TODO: improve mfcc (log and dct) results
    //mat.log_win(X) @=> X;
    //sci.dct_win(X) @=> X;
    spc.spectrogram(X);
}
