// Transform.ck


public class Transform {

    float mx[][];

    0.0 => float width;
    fun float setWidth(float w) {
        w => width;
    }
    setWidth(1.0);

    fun float[][] mel(float sr, int N) {
        32 =>       int numFilters;
        40.0 =>     float minFrq;
        sr/2.0 =>   float maxFrq;
        mel(sr, N, numFilters, minFrq, maxFrq);
    }

    fun float[][] mel(float sr, int N, int numFilters, float minFrq, float maxFrq) {
        hz2mel(minFrq) => float minMel;
        hz2mel(maxFrq) => float maxMel;

        float binFrqs[numFilters + 2];
        for (0 => int i; i < binFrqs.size(); i++) {
            mel2hz(minMel + i/(binFrqs.size() - 1.0) * (maxMel - minMel)) => binFrqs[i];
        }

        coefficents(sr, N, numFilters, width, binFrqs) @=> mx;
    }

    fun float[][] bark(float sr, int N) {
        24 =>       int numFilters;
        50.0 =>     float minFrq;
        13500.0 =>  float maxFrq;
        bark(sr, N, numFilters, minFrq, maxFrq);
    }

    fun float[][] bark(float sr, int N, int numFilters, float minFrq, float maxFrq) {
        hz2bark(minFrq) => float minBark;
        hz2bark(maxFrq) => float maxBark;

        float binFrqs[numFilters + 2];
        for (0 => int i; i < binFrqs.size(); i++) {
            bark2hz(minBark + i/(binFrqs.size() - 1.0) * (maxBark - minBark)) => binFrqs[i];
        }

        coefficents(sr, N, numFilters, width, binFrqs) @=> mx;
    }

    fun float[][] constantQ(float sr, int N) {
        // recommend a high N >= 4096
        88 * 3 =>   int numFilters;
        27.5 =>     float minFrq;
        4186.01 =>  float maxFrq;
        constantQ(sr, N, numFilters, minFrq, maxFrq);
    }

    fun float[][] constantQ(float sr, int N, int numFilters, float minFrq, float maxFrq) {
        hz2pitch(minFrq) => float minPitch;
        hz2pitch(maxFrq) => float maxPitch;

        float binFrqs[numFilters + 2];
        for (0 => int i; i < binFrqs.size(); i++) {
            pitch2hz(minPitch + i/(binFrqs.size() - 1.0) * (maxPitch - minPitch)) => binFrqs[i];
        }

        coefficents(sr, N, numFilters, width, binFrqs) @=> mx;
    }

    fun float[][] cent(float sr, int N) {
        // recommend a high N >= 4096
        330 =>      int numFilters;
        55.0 =>     float minFrq;
        880.0 =>    float maxFrq;
        cent(sr, N, numFilters, minFrq, maxFrq);
    }

    fun float[][] cent(float sr, int N, int numFilters, float minFrq, float maxFrq) {
        hz2cent(minFrq) => float minCent;
        hz2cent(maxFrq) => float maxCent;

        float binFrqs[numFilters + 2];
        for (0 => int i; i < binFrqs.size(); i++) {
            cent2hz(minCent + i/(binFrqs.size() - 1.0) * (maxCent - minCent)) => binFrqs[i];
        }

        coefficents(sr, N, numFilters, width, binFrqs) @=> mx;
    }

    fun float[][] coefficents(float sr, int N, int numFilters, float width, float binFrqs[]) {
        float fftFrqs[N/2 + 1];

        // finds center bin frequencies
        for (0 => int i; i < fftFrqs.size(); i++) {
            sr/N * i => fftFrqs[i];
        }

        // weight matrix
        float w[numFilters][N];

        for (0 => int i; i < numFilters; i++) {
            float fs[3];

            for (int j; j < 3; j++) {
                binFrqs[i + j] => fs[j];
            }
            for (int j; j < 3; j++) {
                width * (fs[j]- fs[1]) + fs[1] => fs[j];
            }

            // low and high bins
            float lo[fftFrqs.size()];
            float hi[fftFrqs.size()];

            for (int j; j < fftFrqs.size(); j++) {
                (fftFrqs[j] - fs[0])/(fs[1] - fs[0]) => lo[j];
                (fs[2] - fftFrqs[j])/(fs[2] - fs[1]) => hi[j];
            }
            for (int j; j < fftFrqs.size(); j++) {
                max(0, min(lo[j], hi[j])) => w[i][j];
            }
        }

        transpose(w) @=> w;
        cutMatrix(w, 0, N/2) @=> w;

        return w;
    }

    fun float[] compute(float X[]) {
        return dot(X, mx);
    }

    // maximum value, utility function
    private float max(float x, float y) {
        if (x > y) return x;
        else return y;
    }

    // minimum value, utility function
    private float min(float x, float y) {
        if (x < y) return x;
        else return y;
    }

    // converts hz to cent scale
    private float hz2cent(float frq) {
        return 1200 * Math.log2(frq/440) + 5700;
    }

    // converts cent to hz
    private float cent2hz(float cent) {
        return Math.pow(2, (cent - 5700)/1200) * 440;
    }

    // converts hz to q scale
    private float hz2pitch(float frq) {
        return 12 * Math.log2(frq/440) + 49;
    }

    // converts frq to hz
    private float pitch2hz(float p) {
        return Math.pow(2, (p - 49)/12) * 440;
    }

    // converts hz to mel scale
    private float hz2mel(float frq) {
        return Math.log10(1 + frq/700) * 2595;
    }

    // converts mel scale to hz
    private float mel2hz(float mel) {
        return 700 * (Math.pow(10, mel/2595) - 1);
    }

    // converts hz to bark scal
    private float hz2bark(float frq) {
        return (26.81 * frq)/(1960 + frq) - 0.51;
    }

    // converts bark scale to hz
    private float bark2hz(float bark) {
        return (-19600 * bark - 9996)/(10 * bark - 263);
    }

    // dot product
    private float[] dot(float x[], float y[][]) {
        1 => int rows_x;
        x.size() => int cols_x;
        y.size() => int rows_y;
        y[0].size() => int cols_y;

        float out[cols_y];

        if (cols_x == rows_y) {
            for (int i; i < cols_y; i++) {
                float prod;
                for (int j; j < rows_y; j++) {
                    x[j] * y[j][i] +=> prod;
                }
                prod => out[i];
            }
            return out;
        }
        else {
            <<< "Length of 'x' (", cols_x, ") array must match number of 'y' rows (", rows_y, ").", "" >>>;
            me.exit();
        }
    }

    // reduces an array
    fun float[] cut(float x[], int low, int high) {
        high - low => int num;
        float out[num];
        for (int i; i < num; i++) {
            x[low + i] => out[i];
        }
        return out;
    }

    // reduces rows of a 2D array
    private float[][] cutMatrix(float x[][], int low, int high) {
        high - low => int rows;
        float out[rows][x[0].size()];
        float temp[x.size()];
        for (int i; i < x[0].size(); i++) {
            for (int j; j < x.size(); j++) {
                x[j][i] => temp[j];
            }
            cut(temp, low, high) @=> float r[];
            for (int j; j < rows; j++) {
                r[j] => out[j][i];
            }
        }
        return out;
    }

    // matrix tranpose
    fun float[][] transpose (float x[][]) {
        float out[x[0].size()][x.size()];
        for (int i; i < x.size(); i++) {
            for (int j; j < x[0].size(); j++) {
                x[i][j] => out[j][i];
            }
        }
        return out;
    }
}
