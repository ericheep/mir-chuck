// mel.ck
// Eric Heep

public class mel {
    // class for calculating mel weights given parameters of an fft
    // includes an optional parameter for 24 bark bands
    fun float[][] calc(int nfft, int nfilts, float sr, float width) {
        return calc(nfft, nfilts, sr, width, "mel");
    }

    fun float[][] calc(int nfft, int nfilts, float sr, float width, string mode) {
        /* Creates a 2D array of nfilts by nfft windows
        mode : type of bands, "bark" or "mel" 
        nfft : fft size
        nfilts : number of mel filters
        sr : sample rate
        width : triangular window spacing, 1.0 for 50% overlapping
        */

        if (mode == "bark") {
            24 => nfilts;
        }

        float fftfrqs[Math.floor(nfft/2) $ int + 1];
        float binfrqs[nfilts + 2];
        float wts[nfilts][nfft];

        for (int i; i < fftfrqs.cap(); i++) {
            (i * sr)/nfft => fftfrqs[i];
        }

        if (mode == "mel") {
            hz2mel(40.0) => float minmel;
            hz2mel(sr/2.0) => float maxmel;
            for (int i; i < binfrqs.cap(); i++) {
                mel2hz(minmel + i/(binfrqs.cap() - 1.0) * (maxmel - minmel)) => binfrqs[i];
            }
        }

        if (mode == "bark") {
            hz2bark(50.0) => float minbark;
            hz2bark(13500) => float maxbark;
            for (int i; i < binfrqs.cap(); i++) {
                bark2hz(minbark+ i/(binfrqs.cap() - 1.0) * (maxbark - minbark)) => binfrqs[i];
            }
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
        /* Finds the max of two floats
        */
        float max;
        if (x > y) x => max;
        else y => max;
        return max;
    }

    fun float min(float x, float y) {
        /* Finds the min of two floats
        */
        float min;
        if (x < y) x => min;
        else y => min;
        return min;
    }
    
    fun float hz2mel(float frq) {
        /* Converts hz to mel scale
        */
        return Math.log10(1 + frq/700) * 2595;
    }

    fun float mel2hz(float mel) {
        /* Converts mel scale to hz
        */
        return 700 * (Math.pow(10, mel/2595) - 1);
    }

    fun float hz2bark(float frq) {
        /* Converts hz to bark scale
        */
        return (26.81 * frq)/(1960 + frq) - 0.51;
    }

    fun float bark2hz(float bark) {
        /* Converts bark scale to hz
        */
        return (-19600 * bark - 9996)/(10 * bark - 263); 
    }
}
