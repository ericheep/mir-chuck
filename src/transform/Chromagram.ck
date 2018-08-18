// Chromagram.ck
// Eric Heep

public class Chromagram {

    [0.04, 0.08, 0.16, 0.32, 1.0] @=> float q_array[];

    // wraps constant q array into an octave
    fun float[] wrap(float X[]) {
        float octave[12];
        for (int i; i < X.cap()/3; i++) {
            for (int j; j < 3; j++) {
                X[(i * 3) + j] + octave[i % 12] => octave[i % 12];
            }
        }
        return octave;
    }
    
    // quantizes chromagram data according to q_array coefficients
    fun float[] quantize(float X[]) {
        for (int i; i < X.cap(); i++) {
            for (int j; j < q_array.cap() - 1; j++) {
                if (X[i] > q_array[j] && X[i] <= q_array[j + 1]) {
                    q_array[j] => X[i];
                }
            }
        }
        return X;
    }
}
