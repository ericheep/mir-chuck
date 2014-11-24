// Spectral.ck

public class Spectral {

    // spectral centroid
    fun float centroid(float X[], float sr, int fft_size) {

        // array for our bin frequencies
        float fft_frqs[fft_size/2 + 1];

        // finds center bin frequencies
        for (int i; i < fft_frqs.cap(); i++) {
            sr/fft_size * i => fft_frqs[i];
        }

        float den;
        float power[X.cap()];
        for (int i; i < X.cap(); i++) {
            X[i] * X[i] => power[i]; 
            power[i] +=> den;
        }

        float num;
        for (int i; i < X.cap(); i++) {
            fft_frqs[i] * power[i] +=> num; 
        }

        return num/den;
    }
    
    // spectral spread
    fun float spread(float X[]) {

    }

    // spectral flatness
    fun float flatness(float X) {

    }
}
