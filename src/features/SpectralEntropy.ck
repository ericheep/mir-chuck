// SpectralEntropy.ck


public class SpectralEntropy {

    fun float entropy(float X[]) {
        X.size() => int N;
        float psd[X.size()];

        0.0 => float sum;

        // power spectral density
        for (0 => int i; i < N; i++) {
            (X[i] * X[i]) * (1.0/N) => psd[i];
            psd[i] +=> sum;
        }

        0.0 => float entropy;

        // normalize
        for (0 => int i; i < N; i++) {
            psd[i]/sum => psd[i];
        }

        // entropy
        for (0 => int i; i < N; i++) {
            psd[i] * Math.log2(psd[i]) +=> entropy;
        }

        return -entropy;
    }
}
