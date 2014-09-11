// chromagram.ck
// Eric Heep

public class chromagram {
    // class for sorting fft bins into a chromagram

    fun float[] chr(float X[], int N, int sr) {

        float f[N/2 + 1]; 
        float out[f.cap()];

        // needs a modulo to wrap into an octave
        sr/N * i => float frq;  

        for (int i; i < X.cap(); i++) {
            Std.ftom(sr/N * i) $ int => int low;
            Std.ftom(sr/N * (i + 1)) $ int => int high;

            if (frq > Std.mtof(low) && frq < Std.mtof(high)) { 
                X[i] +=> out[Std.ftom(frq) $ int];
            }
        }

        return out;
    }
}
