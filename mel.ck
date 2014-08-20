// mel.ck
// Eric Heep

public class mel {
    // class for calculating the mel weights given parameters of an stft matrix
    
    fun float[][] calc(int nfft, int nfilts, float sr, float width) {
        /* Creates a 2D array of nfilts by nfft windows
        nfft : fft size
        nfilts : number of mel filters
        sr : sample rate
        width : triangular window spacing, 1.0 for 50% overlapping
        */

        float fftfrqs[Math.floor(nfft/2) $ int + 1];
        float binfrqs[nfilts + 2];
        float wts[nfilts][nfft];

        hz2mel(40) => float minmel;
        hz2mel(22050) => float maxmel;

        for (int i; i < fftfrqs.cap(); i++) {
            (i * sr)/nfft => fftfrqs[i];
        }

        for (int i; i < binfrqs.cap(); i++) {
            mel2hz(minmel + i/(binfrqs.cap() - 1.0) * (maxmel - minmel)) => binfrqs[i];
        }

        for (int i; i < nfilts; i++) {
            float fs[3];
            for (int j; j < 3; j++) {
                binfrqs[i + j] => fs[j]; 
            }
            for (int j; j < 3; j++) {
                width * (fs[j]- fs[1]) + fs[1] => fs[j];
            }
            float loslope[fftfrqs.cap()];
            float hislope[fftfrqs.cap()];
            for (int j; j < fftfrqs.cap(); j++) {
            (fftfrqs[j] - fs[0])/(fs[1] - fs[0]) => loslope[j]; 
            (fs[2] - fftfrqs[j])/(fs[2] - fs[1]) => hislope[j];
            }
            for (int j; j < fftfrqs.cap(); j++) {
                max(0, min(loslope[j], hislope[j])) => wts[i][j];
            }
        }

        return wts;
    }

    fun float max(float x, float y) {
        float max;
        if (x > y) x => max;
        else y => max;
        return max;
    }

    fun float min(float x, float y) {
        float min;
        if (x < y) x => min;
        else y => min;
        return min;
    }
    
    fun float hz2mel(float frq) {
        /* converts hz to mel scale
        */
        return Math.log10(1 + frq/700) * 2595;
    }

    fun float mel2hz(float mel) {
        /* converts mel scale to hz
        */
        return 700 * (Math.pow(10, mel/2595) - 1);
    }
}
