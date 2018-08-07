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

    fun float[] filter(float x[], int m) {
        x.size() => int N;

        for (0 => int i; i < N; i++) {
            0.0 => float sum;
            for (0 => int j; j < m; j++) {
                if (i + j < N) {
                    x[i + j] +=> sum;
                }
            }
            sum/m => x[i];
        }

        return x;
    }
}

Peaks p;

[0.0, 1.0, 0.5, 1.0, 0.0, 0.2, 0.4] @=> float x[];

p.filter(x, 2) @=> x;
<<< x[0], x[1], x[2], x[3], x[4], x[5], x[6] >>>;


