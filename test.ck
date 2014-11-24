second / samp => float sr;
1024 => int fft_size;

float fft_frqs[fft_size/2 + 1];

// finds center bin frequencies
for (int i; i < fft_frqs.cap(); i++) {
    sr/fft_size * i => fft_frqs[i];
    <<< fft_frqs[i] >>>;
}


