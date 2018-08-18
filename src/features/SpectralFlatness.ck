// Eric Heep
// SpectralFlatness.ck


public class SpectralFlatness {

    fun float compute(float X[]) {
        X.size() => int N;
        float normalizedX[N];

        0.0 => float powerSum;
        for (0 => int i; i < N; i++) {
            X[i] * X[i] +=> powerSum;
        }

        for (0 => int i; i < N; i++) {
            (X[i] * X[i])/powerSum => normalizedX[i];
        }

        0.0 => float sum;
        for (0 => int i; i < N; i++) {
            normalizedX[i] + 0.00000001 => float bin;
            bin * Math.log2(bin) +=> sum;
        }

        return -1.0/Math.log2(N) * sum;
    }
}
