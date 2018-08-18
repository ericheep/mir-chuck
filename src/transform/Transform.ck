// Transform.ck


public class Transform {

    // main method to call in operation
    fun float[][] compute(int N, float sr, string filter) {
        0 => int numFilters;
        0 => float minFrq;
        0 => float maxFrq;

        if (filter == "mel") {
            32 => numFilters;
            40.0 => minFrq;
            sr/2.0 => minFrq;
        }
        if (filter == "bark") {
            24 => numFilters;
            50.0 => minFrq;
            13500.0 => maxFrq;
        }
        if (filter == "constantQ") {
            // 88 piano keys between 27.5 hz (low A) to 4186.01hz (high C)
            88 * 3 => numFilters;
            27.5 => minFrq;
            4186.01 => maxFrq;
        }
        if (filter == "cent") {
            // 3300 cents between 55.0 hz (low A) to 880.0hz (high A), broken up into whole steps
            165 => numFilters;
            110.0 => minFrq;
            880.0 => maxFrq;
        }

        return compute(N, sr, filter, numFilters, 1.0, minFrq, maxFrq);
    }

    // method with optional parameters to call (width and numFilters)
    fun float[][] compute(int N, float sr, string filter, int numFilters, float width, float minFrq, float maxFrq) {

        float fftFrqs[N/2 + 1];
        float binFrqs[numFilters + 2];

        // finds center bin frequencies
        for (int i; i < fftFrqs.cap(); i++) {
            sr/N * i => fftFrqs[i];
        }

        // mel scale transformation
        if (filter == "mel") {
            hz2mel(minFrq) => float minmel;
            hz2mel(maxFrq) => float maxmel;
            for (int i; i < binFrqs.cap(); i++) {
                mel2hz(minmel + i/(binFrqs.cap() - 1.0) * (maxmel - minmel)) => binFrqs[i];
            }
        }

        // critical band bark transformation
        if (filter == "bark") {
            hz2bark(minFrq) => float minbark;
            hz2bark(maxFrq) => float maxbark;
            for (int i; i < binFrqs.cap(); i++) {
                bark2hz(minbark + i/(binFrqs.cap() - 1.0) * (maxbark - minbark)) => binFrqs[i];
            }
        }

        // constant Q transformation
        if (filter == "constantQ") {
            hz2pitch(minFrq) => float minpitch;
            hz2pitch(maxFrq) => float maxpitch;
            for (int i; i < binFrqs.cap(); i++) {
                pitch2hz(minpitch + i/(binFrqs.cap() - 1.0) * (maxpitch - minpitch)) => binFrqs[i];
            }
        }

        // cent transformation
        if (filter == "cent") {
            hz2cent(minFrq) => float minCent;
            hz2cent(maxFrq) => float maxCent;
            for (int i; i < binFrqs.cap(); i++) {
                cent2hz(minCent + i/(binFrqs.cap() - 1.0) * (maxCent - minCent)) => binFrqs[i];
            }
        }

        // weight matrix
        float w[numFilters][N];

        for (int i; i < numFilters; i++) {
            float fs[3];

            for (int j; j < 3; j++) {
                binFrqs[i + j] => fs[j];
            }
            for (int j; j < 3; j++) {
                width * (fs[j]- fs[1]) + fs[1] => fs[j];
            }

            // low and high bins
            float lo[fftFrqs.cap()];
            float hi[fftFrqs.cap()];

            for (int j; j < fftFrqs.cap(); j++) {
                (fftFrqs[j] - fs[0])/(fs[1] - fs[0]) => lo[j];
                (fs[2] - fftFrqs[j])/(fs[2] - fs[1]) => hi[j];
            }
            for (int j; j < fftFrqs.cap(); j++) {
                max(0, min(lo[j], hi[j])) => w[i][j];
            }
        }

        return w;
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
