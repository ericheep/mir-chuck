// Stft.ck
// Eric Heep

public class Stft {
    // short time fourier transform using built in FFT

    fun float[][] stft(SndBuf clip, int N) { 
        /* converts an sndbuf into an stft
        */
        clip => FFT fft => blackhole;
        Windowing.hamming(N) => fft.window;
        
        N => int win;
        N/2 + 1 => int bins;
        clip.samples()/win => int rep;

        UAnaBlob blob;

        float out[bins][rep];
        0 => clip.pos;
        for (int i; i < rep; i++) {
            fft.upchuck() @=> blob;
            win::samp => now;
            for (int j; j < bins; j++) { 
                blob.fvals()[j] => out[j][i];
            }
        }
        return out;
    }
}
