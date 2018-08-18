// SpectralCentroid.ck


public class SpectralCentroid {

    fun float compute(float X[], float sr, int N) {

        // array for our bin frequencies
        float fftFrqs[N/2 + 1];

        // finds center bin frequencies
        for (int i; i < fftFrqs.cap(); i++) {
            sr/N * i => fftFrqs[i];
        }

        0.0 => float den;
        float power[X.cap()];
        for (int i; i < X.cap(); i++) {
            X[i] * X[i] => power[i];
            power[i] +=> den;
        }

        0.0 => float num;
        for (int i; i < X.cap(); i++) {
            fftFrqs[i] * power[i] +=> num;
        }

        return num/den;
    }
}
