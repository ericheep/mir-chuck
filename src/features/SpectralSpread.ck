// SpectralSpread.ck


public class SpectralSpread {

    fun float centroid(float X[], float sr, int N) {

        // array for our bin frequencies
        float fftFrqs[N/2 + 1];

        // finds center bin frequencies
        for (int i; i < fftFrqs.size(); i++) {
            sr/N * i => fftFrqs[i];
        }

        float den;
        float power[X.size()];
        for (int i; i < X.size(); i++) {
            X[i] * X[i] => power[i];
            power[i] +=> den;
        }

        float num;
        for (int i; i < X.size(); i++) {
            fftFrqs[i] * power[i] +=> num;
        }

        return num/den;
    }

    fun float compute(float X[], float sr, int N) {

        // required centroid for spread
        centroid(X, sr, N) => float cent;

        // array for our bin frequencies
        float fftFrqs[N/2 + 1];

        // finds center bin frequencies
        for (int i; i < fftFrqs.size(); i++) {
            sr/N * i => fftFrqs[i];
        }

        float num, den;
        float power[X.size()];
        float square[X.size()];

        for(int i; i < X.size(); i++) {
            X[i] * X[i] => power[i];
            Math.pow(fftFrqs[i] - cent, 2) => square[i];
            power[i] * square[i] +=> num;
            power[i] +=> den;
        }
        return Math.sqrt(num/den);
    }
}

