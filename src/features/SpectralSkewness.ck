// Eric Heep
// SpectralSkewness.ck


public class SpectralSkewness {

    fun float mu(int k, float X[]) {
        0.0 => float numerator;
        0.0 => float denominator;

        for (0 => int i; i < X.size(); i++) {
            Math.pow(i, k) * Math.fabs(X[i]) +=> numerator;
            X[i] +=> denominator;
        }

        return numerator / denominator;
    }

    fun float compute(float X[]) {
        mu(1, X) => float mu1;
        mu(2, X) => float mu2;
        mu(3, X) => float mu3;

        2 * Math.pow(mu1, 3) - 3 * mu1 * mu2 + mu3 => float numerator;
        Math.pow(Math.sqrt(mu2 - Math.pow(mu1, 2)), 3) => float denominator;

        return numerator / denominator;
    }
}
