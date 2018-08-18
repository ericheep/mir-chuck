// MFCCs.ck


public class MFCCs {

    private fun void power(float X[]) {
        for (0 => int i; i < X.size(); i++) {
            X[i] * X[i] => X[i];
        }
    }

    private fun void log(float X[]) {
        for (int i; i < X.size(); i++) {
            Math.log(X[i] + 1.0) => X[i];
        }
    }

    private fun void discreteCosineTransform(float X[]) {
        X.cap() => int N;
        float dct[N];
        for (int k; k < N; k++) {
            float sum;
            for (int n; n < N; n++) {
                x[n] * Math.cos(pi/N * (n + 0.5) * k) +=> sum;
            }
            sum => dct[k];
        }
        out @=> X;
    }

    public fun float[] compute(float X[]) {
        return discreteCosineTransform(log(power(X)));
    }
}
