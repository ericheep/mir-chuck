// Peaks.ck
// Eric Heep

public class Peaks {
    fun float[] peaks(float x[]) {
        x.size() => int N;

        float p[0];

        for (1 => int i; i < N - 1; i++) {
            if (x[i] > x[i - 1] && x[i] > x[i + 1]) {
                p << x[i];
            }
        }

        return p;
    }
}

Peaks p;

[0.0, 1.0, 0.5, 1.0, 0.0] @=> float x[];
<<< p.peaks(x).size() >>>;

