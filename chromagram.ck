// chromagram.ck
// Eric Heep

public class chromagram {
    // class for sorting fft bins into a chromagram

    fun float[] chromagram(float X[], int N, float sr) {
        /* Chromagram, wraps notes into an octave 
        */
        float out[12];

        for (30 => int i; i < X.cap(); i++) {
            Math.round(Std.ftom(sr/N * i)) % 12 => float note;  
            if (note > 0 && note < 12) {
                X[i] => out[note $ int];
            }
        }

        return out;
    }
}
