// Spectral.ck
// Eric Heep & Daniel Reyes

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
    fun float spread(float X[], float sr, int fft_size) {

        // required centroid for spread
        centroid(X, sr, fft_size) => float cent;

        // array for our bin frequencies
        float fft_frqs[fft_size/2 + 1];

        // finds center bin frequencies
        for (int i; i < fft_frqs.cap(); i++) {
            sr/fft_size * i => fft_frqs[i];
        }

        float num, den;
        float power[X.cap()];
        float square[X.cap()];

        for(int i; i < X.cap(); i++) {
            X[i] * X[i] => power[i];
            Math.pow(fft_frqs[i] - cent, 2) => square[i];
            power[i] * square[i] +=> num;
            power[i] +=> den;
        }
        return Math.sqrt(num/den);
    }

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

    // spectral flatness, currently not working
    fun float flatness(float X[]) {
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

    // high-frequency content
    fun float hfc(float X[]) {
        float out;
        for(int k; k < X.cap(); k++){
            X[k] * k +=> out;
        }
        return out;
    }

    // crest factor
    fun float crest(float x[]){
        float max, sum;
        for (int j; j < x.cap(); j++) {
            if (x[j] >= max) {
                x[j] => max;
            }
            x[j] +=> sum;
        }
        return max / sum;
    }
}
