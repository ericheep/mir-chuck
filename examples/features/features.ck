// features.ck

// classes
SpectralCentroid centroid;
SpectralSpread spread;
SpectralKurtosis kurtosis;
SpectralSkewness skewness;
SubbandCentroids centroids;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;

[0.0, 1000.0, 4000.0, 8000.0] @=> float subbandCentroidBanks[];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;
    blob.fvals() @=> float X[];

    // features
    centroid.compute(X, sr, N) => float cent;
    spread.compute(X, sr, N) => float spr;
    kurtosis.compute(X) => float kurt;
    skewness.compute(X) => float skew;

    centroids.compute(X, subbandCentroidBanks, sr, N) @=> float subCents[];

    <<<
        "Centroid: ", cent,
        "Spread: ", spr,
        "Kurtosis: ", kurt,
        "Skewness: ", skew,
        "SubbandCentroids: ", subCents[0], subCents[1], subCents[2]
    >>>;
}
