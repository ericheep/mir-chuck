// MFCCs.ck


public class MFCCs {

    private void power(float X[]) {
        for (0 => int i; i < X.size(); i++) {
            X[i] * X[i] => X[i];
        }
    }

    private void log(float X[]) {
        for (int i; i < X.size(); i++) {
            Math.log(X[i] + 1.0) => X[i];
        }
    }

    private void discreteCosineTransform(float X[]) {
        X.cap() => int N;
        float dct[N];
        for (int k; k < N; k++) {
            float sum;
            for (int n; n < N; n++) {
                X[n] * Math.cos(pi/N * (n + 0.5) * k) +=> sum;
            }
            sum => dct[k];
        }
        dct @=> X;
    }

    fun float[] compute(float X[]) {
        power(X);
        log(X);
        discreteCosineTransform(X);

        return X;
    }
}
