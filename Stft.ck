// Stft.ck
// Eric Heep

public class Stft {

    // short time fourier transform using built in FFT
    fun float[][] stft(SndBuf clip, int N) { 
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
        <<<"stft done">>>;
        return out;
    }

    // collects fft frames and returns an stft
    fun float[][] stft(float x[], float data[][]) {
        float out[data.cap()][data[0].cap()];
        for (data[0].cap() - 2 => int i; i >= 0; i--) {
            for (int j; j < data.cap(); j++) {
                data[j][i] => out[j][i + 1];
            }
        }
        for (int i; i < x.cap(); i++) {
            x[i] => out[i][0];
        }
        return out;
    }
}
