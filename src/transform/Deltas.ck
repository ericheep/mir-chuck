// Deltas.ck


public class Deltas {

    0 => int deltaSize;
    0 => int N;

    // default
    float runningDeltas[][];
    setDepth(2);

    fun void setDepth(int n) {
        n => N;
        N * 2 + 1 => deltaSize;

        float allocDeltas[deltaSize][0];
        allocDeltas @=> runningDeltas;
    }

    fun float[] compute(float X[]) {

        X.size() => int size;

        if (runningDeltas[0].size() != X.size()) {
            for (0 => int i; i < deltaSize; i++) {
                runningDeltas[i].size(size);
            }
        }

        for (deltaSize - 1 => int i; i > 0; i--) {
            for (0 => int j; j < size; j++) {
                runningDeltas[i - 1][j] => runningDeltas[i][j];
            }
        }

        for (0 => int i; i < size; i++) {
            X[i] => runningDeltas[0][i];
        }

        0.0 => float denominator;
        for (1 => int i; i <= N; i++) {
            i * i +=> denominator;
        }
        2.0 *=> denominator;

        float d[size];
        for (0 => int i; i < size; i++) {
            0.0 => float numerator;
            for (1 => int j; j <= N; j++) {
                j * (runningDeltas[N + j][i] - runningDeltas[N - j][i]) +=> numerator;
            }
            numerator/denominator => d[i];
        }

        return d;
    }
}
