// Mel.ck
// Eric Heep

public class Mel {
  
    // main method to call in operation
    fun float[][] calc(int fft_size, float sr, string filter) {
        return calc(fft_size, sr, 0, 1.0, filter);
    }

    // method with optional parameters to call (width and n_filts)
    fun float[][] calc(int fft_size, float sr, int n_filts, float width, string filter) {

        float fft_frqs[fft_size/2 + 1];
        float bin_frqs[0];

        // finds center bin frequencies
        for (int i; i < fft_frqs.cap(); i++) {
            sr/fft_size * i => fft_frqs[i];
        }

        // mel scale transformation
        if (filter == "mel") {
            if (n_filts == 0) {
                // default number of mel bands
                32 => n_filts;
            }
            n_filts + 2 => bin_frqs.size;
            hz2mel(40.0) => float minmel;
            hz2mel(sr/2.0) => float maxmel;
            for (int i; i < bin_frqs.cap(); i++) {
                mel2hz(minmel + i/(bin_frqs.cap() - 1.0) * (maxmel - minmel)) => bin_frqs[i];
            }
        }

        // critical band bark transformation
        if (filter == "bark") {
            if (n_filts == 0) {
                // 24 critical bands betweeen 50hz and 13.5khz
                24 => n_filts;
            }
            n_filts + 2 => bin_frqs.size;
            hz2bark(50.0) => float minbark;
            hz2bark(13500) => float maxbark;
            for (int i; i < bin_frqs.cap(); i++) {
                bark2hz(minbark + i/(bin_frqs.cap() - 1.0) * (maxbark - minbark)) => bin_frqs[i];
            }
        }

        // constant Q transformation
        if (filter == "constantQ") {
            if (n_filts == 0) {
                // 88 piano keys between 27.5 hz (low A) to 4186.01hz (high C)
                88 * 3 => n_filts;
            }
            n_filts + 2 => bin_frqs.size;
            hz2pitch(27.5) => float minpitch;
            hz2pitch(4186.01) => float maxpitch;
            for (int i; i < bin_frqs.cap(); i++) {
                pitch2hz(minpitch + i/(bin_frqs.cap() - 1.0) * (maxpitch - minpitch)) => bin_frqs[i];
            }
        }

        // weight matrix
        float w[n_filts][fft_size];

        for (int i; i < n_filts; i++) {
            float fs[3];
            
            for (int j; j < 3; j++) {
                bin_frqs[i + j] => fs[j]; 
            }
            for (int j; j < 3; j++) {
                width * (fs[j]- fs[1]) + fs[1] => fs[j];
            }

            // low and high bins
            float lo[fft_frqs.cap()];
            float hi[fft_frqs.cap()];

            for (int j; j < fft_frqs.cap(); j++) {
                (fft_frqs[j] - fs[0])/(fs[1] - fs[0]) => lo[j]; 
                (fs[2] - fft_frqs[j])/(fs[2] - fs[1]) => hi[j];
            }
            for (int j; j < fft_frqs.cap(); j++) {
                max(0, min(lo[j], hi[j])) => w[i][j];
            }
        }

        return w;
    }

    // converts hz to q scale
    fun float hz2pitch(float frq) {
        return 12 * Math.log2(frq/440) + 49;
    }

    // converts frq to hz
    fun float pitch2hz(float p) {
        return Math.pow(2, (p - 49)/12) * 440;
    }

    // converts hz to mel scale
    fun float hz2mel(float frq) {
        return Math.log10(1 + frq/700) * 2595;
    }

    // converts mel scale to hz
    fun float mel2hz(float mel) {
        return 700 * (Math.pow(10, mel/2595) - 1);
    }

    // converts hz to bark scal
    fun float hz2bark(float frq) {
        return (26.81 * frq)/(1960 + frq) - 0.51;
    }

    // converts bark scale to hz
    fun float bark2hz(float bark) {
        return (-19600 * bark - 9996)/(10 * bark - 263); 
    }

    // maximum value, utility function
    fun float max(float x, float y) {
        if (x > y) return x;
        else return y;
    }

    // minimum value, utility function
    fun float min(float x, float y) {
        if (x < y) return x;
        else return y;
    }
}
