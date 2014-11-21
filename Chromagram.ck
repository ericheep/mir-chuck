// Chromagram.ck
// Eric Heep

public class Chromagram {

    // wraps constant q into an octave
    fun float[] wrap(float X[]) {
        float octave[12];
        for (int i; i < X.cap()/3; i++) {
            for (int j; j < 3; j++) {
                X[(i * 3) + j] + octave[i % 12] => octave[i % 12];
            }
        }
        return octave;
    }
}
