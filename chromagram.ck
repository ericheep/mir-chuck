// chromagram.ck
// Eric Heep

public class chromagram {
    // class for sorting fft bins into a chromagram

    fun float[] chr(float X[], int N, int sr) {

        float f[N/2 + 1]; 
        float out[f.cap()];

        for (int i; i < f.cap(); i++) {
            i/N * sr => f[i];
            <<< f[i] >>>;
        }

        for (int i; i < out.cap(); i++) {
            // needs a modulo to wrap into an octave
            sr/N * i => float frq; 
            for (int j; j < out.cap() - 1; j++) {
                if (f[j] < frq && f[j + 1] > frq) {
                    X[i] +=> out[j];        
                }
            }
        }

        return out;
    }
}
