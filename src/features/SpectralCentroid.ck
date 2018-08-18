// SpectralCentroid.ck
// Eric Heep


public class SpectralCentroid {

    fun float compute(float X[], float sr, int fft_size) {

        // array for our bin frequencies
        float fft_frqs[fft_size/2 + 1];

        // finds center bin frequencies
        for (int i; i < fft_frqs.cap(); i++) {
            sr/fft_size * i => fft_frqs[i];
        }

        0.0 => float den;
        float power[X.cap()];
        for (int i; i < X.cap(); i++) {
            X[i] * X[i] => power[i];
            power[i] +=> den;
        }

        0.0 => float num;
        for (int i; i < X.cap(); i++) {
            fft_frqs[i] * power[i] +=> num;
        }

        return num/den;
    }
}
