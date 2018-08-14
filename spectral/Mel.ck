// Mel.ck
// Eric Heep

public class Mel {

    float runningDeltas[3][0];

    fun float[] deltas(float X[]) {
        X.size() => int N;

        if (runningDeltas[0].size() == 0) {
            for (0 => int i; i < 3; i++) {
                runningDeltas[i].size(N);
            }
        }

        for (2 => int i; i > 0; i--) {
            for (0 => int j; j < N; j++) {
                runningDeltas[i - 1][j] => runningDeltas[i][j];
            }
        }

        for (0 => int i; i < N; i++) {

        }
    }

    // main method to call in operation
    fun float[][] calc(int fft_size, float sr, string filter) {
        0 => int n_filts;
        0 => float minFrq;
        0 => float maxFrq;

        if (filter == "mel") {
            32 => n_filts;
            40.0 => minFrq;
            sr/2.0 => minFrq;
        }
        if (filter == "bark") {
            24 => n_filts;
            50.0 => minFrq;
            13500.0 => maxFrq;
        }
        if (filter == "constantQ") {
            // 88 piano keys between 27.5 hz (low A) to 4186.01hz (high C)
            88 * 3 => n_filts;
            27.5 => minFrq;
            4186.01 => maxFrq;
        }
        if (filter == "cent") {
            // 3300 cents between 55.0 hz (low A) to 880.0hz (high A), broken up into whole steps
            165 => n_filts;
            110.0 => minFrq;
            880.0 => maxFrq;
        }

        return calc(fft_size, sr, filter, n_filts, 1.0, minFrq, maxFrq);
    }

    // method with optional parameters to call (width and n_filts)
    fun float[][] calc(int fft_size, float sr, string filter, int n_filts, float width, float minFrq, float maxFrq) {

        float fft_frqs[fft_size/2 + 1];
        float bin_frqs[n_filts + 2];

        // finds center bin frequencies
        for (int i; i < fft_frqs.cap(); i++) {
            sr/fft_size * i => fft_frqs[i];
        }

        // mel scale transformation
        if (filter == "mel") {
            hz2mel(minFrq) => float minmel;
            hz2mel(maxFrq) => float maxmel;
            for (int i; i < bin_frqs.cap(); i++) {
                mel2hz(minmel + i/(bin_frqs.cap() - 1.0) * (maxmel - minmel)) => bin_frqs[i];
            }
        }

        // critical band bark transformation
        if (filter == "bark") {
            hz2bark(minFrq) => float minbark;
            hz2bark(maxFrq) => float maxbark;
            for (int i; i < bin_frqs.cap(); i++) {
                bark2hz(minbark + i/(bin_frqs.cap() - 1.0) * (maxbark - minbark)) => bin_frqs[i];
            }
        }

        // constant Q transformation
        if (filter == "constantQ") {
            hz2pitch(minFrq) => float minpitch;
            hz2pitch(maxFrq) => float maxpitch;
            for (int i; i < bin_frqs.cap(); i++) {
                pitch2hz(minpitch + i/(bin_frqs.cap() - 1.0) * (maxpitch - minpitch)) => bin_frqs[i];
            }
        }

        // cent transformation
        if (filter == "cent") {
            hz2cent(minFrq) => float minCent;
            hz2cent(maxFrq) => float maxCent;
            for (int i; i < bin_frqs.cap(); i++) {
                cent2hz(minCent + i/(bin_frqs.cap() - 1.0) * (maxCent - minCent)) => bin_frqs[i];
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

    // converts hz to cent scale
    fun float hz2cent(float frq) {
        return 1200 * Math.log2(frq/440) + 5700;
    }

    // converts cent to hz
    fun float cent2hz(float cent) {
        return Math.pow(2, (cent - 5700)/1200) * 440;
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

Mel mel;

[1.0, 2.0, 3.0, 4.0, 5.0] @=> float arr[];
mel.deltas(arr);
